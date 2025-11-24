import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manpro/common/widgets/background_app.dart';
import 'package:manpro/navbar.dart';
import 'package:manpro/utils/constants/image_string.dart';
import 'package:manpro/features/bagian_utama/controllers/donationController.dart';

/// DonationHistory menampilkan riwayat donasi pengguna
/// Menggunakan GetX untuk state management dan navigasi
class DonationHistory extends StatelessWidget {
  // Controller untuk mengelola data donasi
  final DonationController donationController = Get.put(DonationController());

  DonationHistory({super.key});

  // Membersihkan teks dari karakter HTML
  String _sanitizeText(String? text) {
    if (text == null || text.isEmpty) return '';
    return text.replaceAll(RegExp(r'<[^>]*>'), '');
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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tombol kembali
                  IconButton(
                    onPressed: () {
                      try {
                        final controller = Get.put(NavigationController());
                        controller.selectedIndex.value = 0;
                        Get.to(() => const Navbar());
                      } catch (e) {
                        Get.back(); // Navigasi fallback
                      }
                    },
                    icon: const ImageIcon(
                      AssetImage(YPKImages.icon_back_button),
                      size: 32.0,
                      semanticLabel: 'Kembali',
                    ),
                  ),

                  const SizedBox(height: 25.0),

                  // Judul halaman
                  const Text(
                    'Riwayat Donasi',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 24.0,
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 20.0),

                  // Daftar riwayat donasi dengan pull-to-refresh
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        try {
                          await donationController.getDonations();
                        } catch (e) {
                          // Error sudah ditangani di controller
                        }
                      },
                      child: Obx(() {
                        // Tampilkan loading indicator saat memuat data
                        if (donationController.isLoading.value) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        // Tampilkan pesan error jika terjadi kesalahan
                        if (donationController.hasError.value) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _sanitizeText(donationController.errorMessage.value),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                    fontFamily: 'NunitoSans',
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () => donationController.retryOperation(
                                    donationController.getDonations,
                                  ),
                                  child: const Text(
                                    'Coba Lagi',
                                    style: TextStyle(
                                      fontFamily: 'NunitoSans',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        // Tampilkan pesan jika tidak ada riwayat donasi
                        if (donationController.donations.isEmpty) {
                          return const Center(
                            child: Text(
                              'Belum ada riwayat donasi',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          );
                        }

                        // Tampilkan daftar riwayat donasi
                        return ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: donationController.donations.length,
                          itemBuilder: (context, index) {
                            // Ambil data donasi untuk item saat ini
                            final donation = donationController.donations[index];

                            // Buat kartu riwayat donasi
                            return Container(
                              margin: const EdgeInsets.only(bottom: 20),
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
                                  // Tipe donasi dan status
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Tipe donasi
                                      Expanded(
                                        child: Text(
                                          'Tipe: ${_sanitizeText(donation.type)}',
                                          style: const TextStyle(
                                            fontFamily: 'NunitoSans',
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),

                                      // Badge status
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: donationController.getStatusColor(
                                            donation.status ?? 'pending',
                                          ),
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Text(
                                          donationController.getStatusText(
                                            donation.status ?? 'pending',
                                          ),
                                          style: const TextStyle(
                                            fontFamily: 'NunitoSans',
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 10),

                                  // Detail donasi
                                  Text(
                                    'Jumlah: ${_sanitizeText(donation.quantity)}',
                                    style: const TextStyle(
                                      fontFamily: 'NunitoSans',
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  Text(
                                    'Metode Pengiriman: ${_sanitizeText(donation.shippingMethod)}',
                                    style: const TextStyle(
                                      fontFamily: 'NunitoSans',
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  Text(
                                    'Catatan: ${_sanitizeText(donation.notes)}',
                                    style: const TextStyle(
                                      fontFamily: 'NunitoSans',
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  Text(
                                    'Dibuat pada: ${_sanitizeText(donation.formattedDate)}',
                                    style: const TextStyle(
                                      fontFamily: 'NunitoSans',
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),

                                  // Tombol batalkan (hanya untuk donasi pending)
                                  if (donation.status?.toLowerCase() == 'pending')
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Obx(() => TextButton.icon(
                                        // Nonaktifkan tombol saat proses berjalan
                                        onPressed: donationController.isLoading.value
                                            ? null
                                            : () async {
                                                // Tampilkan dialog konfirmasi
                                                final bool? shouldCancel = await Get.dialog<bool>(
                                                  AlertDialog(
                                                    title: const Text(
                                                      'Batalkan Donasi',
                                                      style: TextStyle(
                                                        fontFamily: 'Montserrat',
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: 20.0,
                                                      ),
                                                    ),
                                                    content: const Text(
                                                      'Apakah Anda yakin ingin membatalkan donasi ini?',
                                                      style: TextStyle(
                                                        fontFamily: 'NunitoSans',
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 16.0,
                                                      ),
                                                    ),
                                                    actions: [
                                                      // Tombol tidak
                                                      TextButton(
                                                        onPressed: () => Get.back(result: false),
                                                        child: const Text(
                                                          'Tidak',
                                                          style: TextStyle(
                                                            fontFamily: 'NunitoSans',
                                                            fontWeight: FontWeight.w700,
                                                          ),
                                                        ),
                                                      ),
                                                      // Tombol ya
                                                      TextButton(
                                                        onPressed: () => Get.back(result: true),
                                                        style: TextButton.styleFrom(
                                                          foregroundColor: Colors.red,
                                                        ),
                                                        child: const Text(
                                                          'Ya',
                                                          style: TextStyle(
                                                            fontFamily: 'NunitoSans',
                                                            fontWeight: FontWeight.w700,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );

                                                // Proses pembatalan jika user menyetujui
                                                if (shouldCancel == true && donation.id != null) {
                                                  try {
                                                    await donationController.cancelDonation(donation.id!);
                                                  } catch (e) {
                                                    // Error sudah ditangani di controller
                                                  }
                                                }
                                              },
                                        // Tampilkan loading indicator atau ikon batal
                                        icon: donationController.isLoading.value
                                            ? const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor: AlwaysStoppedAnimation<Color>(
                                                    Colors.red,
                                                  ),
                                                ),
                                              )
                                            : const Icon(Icons.cancel_outlined, color: Colors.red),
                                        label: const Text(
                                          'Batalkan Donasi',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontFamily: 'NunitoSans',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      )),
                                    ),
                                ],
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
