import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manpro/common/widgets/background_app.dart';
import 'package:manpro/navbar.dart';
import 'package:manpro/utils/constants/image_string.dart';
import 'package:manpro/features/bagian_utama/controllers/donationController.dart';
import 'package:manpro/features/bagian_utama/models/donationModel.dart';

/// Halaman Donasi untuk membuat donasi baru
/// Menggunakan StatefulWidget karena perlu mengelola state form
class Donation extends StatefulWidget {
  const Donation({super.key});

  @override
  State<Donation> createState() => _DonationState();
}

class _DonationState extends State<Donation> with WidgetsBindingObserver {
  //================ CONTROLLER & FOCUS NODE ================//
  
  // Controller untuk mengelola data donasi
  final DonationController donationController = Get.put(DonationController());

  // Controller untuk input form
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  // Focus node untuk manajemen keyboard
  final FocusNode quantityFocus = FocusNode();
  final FocusNode notesFocus = FocusNode();

  //================ STATE VARIABLES ================//
  
  // State untuk dropdown
  String? selectedDonationType;
  String? selectedShippingMethod;
  
  // State untuk loading dan error
  bool isSubmitting = false;
  bool isLoading = true;
  String? errorMessage;

  // Debouncer untuk input
  Timer? _debouncer;

  //================ CONSTANTS ================//
  
  // Konstanta untuk validasi dan timeout
  static const int maxQuantityLength = 50;
  static const int maxNotesLength = 500;
  static const Duration networkTimeout = Duration(seconds: 30);
  static const Duration debounceTime = Duration(milliseconds: 500);

  //================ LIFECYCLE METHODS ================//

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeData();
  }

  @override
  void dispose() {
    // Bersihkan resources saat widget di-dispose
    WidgetsBinding.instance.removeObserver(this);
    _debouncer?.cancel();
    quantityController.dispose();
    notesController.dispose();
    quantityFocus.dispose();
    notesFocus.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Refresh data saat aplikasi kembali ke foreground
    if (state == AppLifecycleState.resumed) {
      _refreshData();
    }
  }

  //================ DATA INITIALIZATION ================//

  // Inisialisasi data awal
  Future<void> _initializeData() async {
    if (!mounted) return;
    
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Muat data tipe donasi dan metode pengiriman
      await Future.wait([
        donationController.getDonationTypes().timeout(networkTimeout),
        donationController.getShippingMethods().timeout(networkTimeout),
      ]);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = _getErrorMessage(e);
      });
    } finally {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  // Refresh data
  Future<void> _refreshData() async {
    if (isSubmitting) return;
    await _initializeData();
  }

  //================ ERROR HANDLING ================//

  // Mendapatkan pesan error yang user-friendly
  String _getErrorMessage(dynamic error) {
    if (error is TimeoutException) {
      return 'Koneksi timeout, silakan coba lagi';
    }
    if (error is SocketException) {
      return 'Tidak dapat terhubung ke server, periksa koneksi internet Anda';
    }
    return error.toString().replaceAll('Exception:', '').trim();
  }

  //================ VALIDATION METHODS ================//

  // Validasi format jumlah donasi
  bool _validateQuantity(String value) {
    if (value.isEmpty || value.length > maxQuantityLength) return false;

    // Sanitasi input
    value = value.trim();
    
    // Cek apakah input hanya berisi angka
    final numericRegex = RegExp(r'^[0-9]+$');
    if (numericRegex.hasMatch(value)) {
      final quantity = int.tryParse(value);
      return quantity != null && quantity > 0;
    }

    // Cek apakah input berisi angka dengan satuan yang valid
    final withUnitRegex = RegExp(
      r'^[0-9]+\s*(kg|pcs|items?|box(es)?|pack(s)?|buah|lembar|pasang|set)$',
      caseSensitive: false,
    );
    if (!withUnitRegex.hasMatch(value)) return false;

    // Ekstrak angka dan validasi
    final numStr = value.replaceAll(RegExp(r'[^0-9]'), '');
    final quantity = int.tryParse(numStr);
    return quantity != null && quantity > 0;
  }

  // Sanitasi input untuk keamanan
  String _sanitizeInput(String value, {bool allowNewlines = false}) {
    String sanitized = value;
    
    // Hapus karakter khusus dan HTML
    sanitized = sanitized.replaceAll(RegExp("[<>\"'\\\\\$]"), '');
    
    // Normalisasi line breaks
    sanitized = sanitized.replaceAll(RegExp("(\\r\\n|\\r|\\n){2,}"), '\n');
    
    // Trim whitespace
    sanitized = sanitized.trim();

    // Jika tidak allow newlines, replace dengan spasi
    if (!allowNewlines) {
      sanitized = sanitized.replaceAll(RegExp("\\s+"), ' ');
    }

    return sanitized;
  }

  // Format quantity untuk backend
  String _formatQuantityForBackend(String value) {
    value = _sanitizeInput(value);
    
    // Jika input hanya angka, tambahkan 'pcs'
    final numericRegex = RegExp(r'^[0-9]+$');
    if (numericRegex.hasMatch(value.trim())) {
      return '${value.trim()}pcs';
    }
    return value.trim().toLowerCase();
  }

  // Validasi form secara keseluruhan
  String? _validateForm() {
    if (selectedDonationType == null) {
      return 'Silakan pilih jenis donasi';
    }
    if (selectedShippingMethod == null) {
      return 'Silakan pilih metode pengiriman';
    }
    if (quantityController.text.isEmpty) {
      return 'Silakan masukkan jumlah';
    }
    if (!_validateQuantity(quantityController.text.trim())) {
      return 'Masukkan jumlah yang valid (contoh: 10 atau 5kg, 5pcs)';
    }
    if (notesController.text.isEmpty) {
      return 'Silakan masukkan catatan';
    }
    if (notesController.text.length > maxNotesLength) {
      return 'Catatan tidak boleh lebih dari $maxNotesLength karakter';
    }
    return null;
  }

  //================ FORM SUBMISSION ================//

  // Fungsi untuk mengirim donasi
  Future<void> _submitDonation() async {
    // Cegah pengiriman ganda
    if (isSubmitting) return;

    // Validasi form
    final errorMsg = _validateForm();
    if (errorMsg != null) {
      Get.snackbar(
        'Error',
        errorMsg,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(20.0),
        duration: const Duration(seconds: 3),
      );
      return;
    }

    // Mulai proses pengiriman
    setState(() => isSubmitting = true);

    try {
      // Format dan sanitasi input
      final formattedQuantity = _formatQuantityForBackend(quantityController.text);
      final sanitizedNotes = _sanitizeInput(notesController.text, allowNewlines: true);

      // Buat donasi baru
      await donationController.createDonation(
        DonationModel(
          type: selectedDonationType!,
          quantity: formattedQuantity,
          shippingMethod: selectedShippingMethod!,
          notes: sanitizedNotes,
        ),
      ).timeout(networkTimeout);

      // Kembali ke halaman utama dan buka tab riwayat
      Get.offAll(() => const Navbar(), arguments: 3);
    } catch (e) {
      if (!mounted) return;
      
      Get.snackbar(
        'Error',
        _getErrorMessage(e),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(20.0),
        duration: const Duration(seconds: 3),
      );
    } finally {
      if (mounted) {
        setState(() => isSubmitting = false);
      }
    }
  }

  //================ NAVIGATION HELPERS ================//

  // Cek apakah ada perubahan yang belum disimpan
  bool _hasUnsavedChanges() {
    return quantityController.text.isNotEmpty ||
        notesController.text.isNotEmpty ||
        selectedDonationType != null ||
        selectedShippingMethod != null;
  }

  // Tampilkan dialog konfirmasi
  Future<bool> _showConfirmationDialog() async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text(
          'Batalkan Perubahan?',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w700,
          ),
        ),
        content: const Text(
          'Apakah Anda yakin ingin membatalkan formulir donasi ini?',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text(
              'Tidak',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text(
              'Ya',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  //================ BUILD METHOD ================//

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!_hasUnsavedChanges()) return true;
        return _showConfirmationDialog();
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Background aplikasi
            const BackgroundAPP(),

            // Konten utama
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tombol kembali
                      IconButton(
                        onPressed: () async {
                          if (!_hasUnsavedChanges()) {
                            Get.to(() => const Navbar());
                            return;
                          }
                          if (await _showConfirmationDialog()) {
                            Get.to(() => const Navbar());
                          }
                        },
                        icon: const ImageIcon(
                          AssetImage(YPKImages.icon_back_button),
                          size: 32.0,
                          semanticLabel: 'Kembali ke halaman sebelumnya',
                        ),
                      ),

                      const SizedBox(height: 25.0),

                      // Judul halaman
                      const Text(
                        'Donasi',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          fontSize: 24.0,
                          letterSpacing: -0.5,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Form container
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 3,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header kategori
                            Container(
                              height: 60.0,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF7ABFB),
                                borderRadius: BorderRadius.circular(27),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2.0,
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'Kategori',
                                  style: TextStyle(
                                    fontSize: 23,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Loading indicator atau error message
                            if (isLoading)
                              const Center(
                                child: CircularProgressIndicator(),
                              )
                            else if (errorMessage != null)
                              Center(
                                child: Column(
                                  children: [
                                    Text(
                                      errorMessage!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                    const SizedBox(height: 10),
                                    ElevatedButton(
                                      onPressed: _refreshData,
                                      child: const Text('Coba Lagi'),
                                    ),
                                  ],
                                ),
                              )
                            // Form fields
                            else
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Dropdown jenis donasi
                                  DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      hintText: 'Pilih Jenis Donasi',
                                      hintStyle: const TextStyle(
                                        fontFamily: 'NunitoSans',
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF333333),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 15,
                                      ),
                                    ),
                                    initialValue: selectedDonationType,
                                    items: donationController.donationTypes
                                        .map((type) => DropdownMenuItem<String>(
                                              value: type.name,
                                              child: Text(type.name),
                                            ))
                                        .toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedDonationType = newValue;
                                      });
                                    },
                                  ),

                                  const SizedBox(height: 20),

                                  // Input jumlah donasi
                                  TextFormField(
                                    controller: quantityController,
                                    focusNode: quantityFocus,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    maxLength: maxQuantityLength,
                                    onChanged: (value) {
                                      _debouncer?.cancel();
                                      _debouncer = Timer(debounceTime, () {
                                        if (mounted) {
                                          setState(() {});
                                        }
                                      });
                                    },
                                    onFieldSubmitted: (_) {
                                      notesFocus.requestFocus();
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Jumlah (contoh: 10 atau 5kg, 5pcs)',
                                      hintStyle: const TextStyle(
                                        fontFamily: 'NunitoSans',
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF333333),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 15,
                                      ),
                                      counterText: '',
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  // Input catatan
                                  TextFormField(
                                    controller: notesController,
                                    focusNode: notesFocus,
                                    maxLines: 3,
                                    maxLength: maxNotesLength,
                                    textInputAction: TextInputAction.done,
                                    onChanged: (value) {
                                      _debouncer?.cancel();
                                      _debouncer = Timer(debounceTime, () {
                                        if (mounted) {
                                          setState(() {});
                                        }
                                      });
                                    },
                                    onFieldSubmitted: (_) {
                                      notesFocus.unfocus();
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Catatan',
                                      hintStyle: const TextStyle(
                                        fontFamily: 'NunitoSans',
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF333333),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 15,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  // Dropdown metode pengiriman
                                  DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      hintText: 'Pilih Pengiriman',
                                      hintStyle: const TextStyle(
                                        fontFamily: 'NunitoSans',
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF333333),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 15,
                                      ),
                                    ),
                                    initialValue: selectedShippingMethod,
                                    items: donationController.shippingMethods
                                        .map((method) => DropdownMenuItem<String>(
                                              value: method.name,
                                              child: Text(method.name),
                                            ))
                                        .toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedShippingMethod = newValue;
                                      });
                                    },
                                  ),

                                  const SizedBox(height: 30),

                                  // Tombol konfirmasi
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: isSubmitting ? null : _submitDonation,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFF7ABFB),
                                        padding: const EdgeInsets.symmetric(vertical: 15),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          side: const BorderSide(
                                            color: Colors.black,
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                      child: isSubmitting
                                          ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(
                                                  Colors.black,
                                                ),
                                              ),
                                            )
                                          : const Text(
                                              'Konfirmasi',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: "Montserrat",
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
