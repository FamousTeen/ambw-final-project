import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manpro/common/widgets/background_app.dart';
import 'package:manpro/utils/constants/image_string.dart';
import 'package:manpro/features/bagian_utama/controllers/eventController.dart';

// Widget untuk form pendaftaran event
class RegisEvent extends StatefulWidget {
  // Parameter yang dibutuhkan
  final String eventName;
  final int eventId;

  // Constructor
  const RegisEvent({
    super.key,
    required this.eventName,
    required this.eventId,
  });

  @override
  State<RegisEvent> createState() => _RegisEventState();
}

class _RegisEventState extends State<RegisEvent> {
  // Controller untuk input field
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // Controller untuk event dan form
  final eventController = Get.find<EventController>();
  final _formKey = GlobalKey<FormState>();

  // Membersihkan controller saat widget dihapus
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  // Fungsi untuk mengirim data pendaftaran
  Future<void> _submitRegistration() async {
    // Validasi form terlebih dahulu
    if (_formKey.currentState!.validate()) {
      try {
        // Mencoba mendaftarkan event
        await eventController.registerEvent(
          eventId: widget.eventId,
          name: nameController.text.trim(),
          email: emailController.text.trim(),
        );
      } catch (e) {
        // Menampilkan pesan error jika gagal
        Get.snackbar(
          'Error',
          e.toString().contains('duplicate')
              ? 'Anda sudah terdaftar di event ini'
              : 'Gagal mendaftar. Silakan coba lagi.',
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
          duration: const Duration(seconds: 3),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background aplikasi
          const BackgroundAPP(),

          // Konten utama
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tombol kembali
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const ImageIcon(
                          AssetImage(YPKImages.icon_back_button),
                          size: 32.0,
                        ),
                      ),
                      const SizedBox(height: 25.0),

                      // Judul halaman
                      const Text(
                        'Daftar Event',
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
                            // Nama event yang dipilih
                            Text(
                              'Event: ${widget.eventName}',
                              style: const TextStyle(
                                fontFamily: 'NunitoSans',
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Input field untuk nama
                            TextFormField(
                              controller: nameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Mohon masukkan nama Anda';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'Nama',
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

                            // Input field untuk email
                            TextFormField(
                              controller: emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Mohon masukkan email Anda';
                                }
                                if (!GetUtils.isEmail(value)) {
                                  return 'Mohon masukkan email yang valid';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'Email',
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
                            const SizedBox(height: 30),

                            // Tombol submit
                            SizedBox(
                              width: double.infinity,
                              child: Obx(() => ElevatedButton(
                                    // Nonaktifkan tombol saat loading
                                    onPressed: eventController.isLoading.value
                                        ? null
                                        : _submitRegistration,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFF7ABFB),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: const BorderSide(
                                          color: Colors.black,
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                    // Tampilkan loading indicator atau teks
                                    child: eventController.isLoading.value
                                        ? const CircularProgressIndicator()
                                        : const Text(
                                            'Daftar',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: "Montserrat",
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                          ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
