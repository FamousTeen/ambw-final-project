import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manpro/common/widgets/background_app.dart';
import 'package:manpro/navbar.dart';
import 'package:manpro/utils/constants/image_string.dart';
import 'package:manpro/features/bagian_utama/controllers/eventController.dart';

class EventHistory extends StatefulWidget {
  const EventHistory({super.key});

  @override
  State<EventHistory> createState() => _EventHistoryState();
}

class _EventHistoryState extends State<EventHistory> {
  // Controller untuk event
  final EventController eventController = Get.put(EventController());

  // Variable untuk status error dan loading
  final error = ''.obs;
  final isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    // Ambil data event history saat widget pertama kali dibuat
    loadEventHistory();
  }

  // Fungsi untuk mengambil data event history
  Future<void> loadEventHistory() async {
    try {
      isLoading.value = true;
      error.value = '';

      // Cek koneksi internet terlebih dahulu (skip jika di web)
      if (!kIsWeb) {
        final result = await InternetAddress.lookup('google.com')
            .timeout(const Duration(seconds: 10));

        if (result.isEmpty || result[0].rawAddress.isEmpty) {
          error.value = 'Tidak ada koneksi internet';
          isLoading.value = false;
          return;
        }
      }

      // Ambil data event history
      await eventController.getEventHistory();
    } on SocketException catch (_) {
      error.value = 'Tidak dapat terhubung ke internet';
    } on TimeoutException catch (_) {
      error.value = 'Koneksi timeout, coba lagi';
    } catch (e) {
      error.value = 'Terjadi kesalahan, coba lagi';
    } finally {
      isLoading.value = false;
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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tombol kembali
                  IconButton(
                    onPressed: () {
                      final controller = Get.put(NavigationController());
                      controller.selectedIndex.value = 0;
                      Get.to(() => const Navbar());
                    },
                    icon: const ImageIcon(
                      AssetImage(YPKImages.icon_back_button),
                      size: 32.0,
                    ),
                  ),
                  const SizedBox(height: 25.0),

                  // Judul halaman
                  const Text(
                    'Riwayat Event',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 24.0,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  // Konten riwayat event
                  Expanded(
                    child: Obx(() {
                      // Tampilkan loading indicator saat mengambil data
                      if (isLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      // Tampilkan pesan error jika terjadi kesalahan
                      if (error.value.isNotEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                error.value,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Montserrat',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: loadEventHistory,
                                child: const Text('Coba Lagi'),
                              ),
                            ],
                          ),
                        );
                      }

                      // Tampilkan pesan jika tidak ada riwayat event
                      if (eventController.eventHistory.isEmpty) {
                        return const Center(
                          child: Text(
                            'Belum ada riwayat event',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        );
                      }

                      // Tampilkan list riwayat event
                      return RefreshIndicator(
                        onRefresh: loadEventHistory,
                        child: ListView.builder(
                          itemCount: eventController.eventHistory.length,
                          itemBuilder: (context, index) {
                            final registration =
                                eventController.eventHistory[index];

                            // Card untuk setiap riwayat event
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
                                  // Nama event
                                  Text(
                                    'Event: ${registration.event?.title ?? "Event tidak ditemukan"}',
                                    style: const TextStyle(
                                      fontFamily: 'NunitoSans',
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  // Nama pendaftar
                                  Text(
                                    'Nama: ${registration.name}',
                                    style: const TextStyle(
                                      fontFamily: 'NunitoSans',
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  // Email pendaftar
                                  Text(
                                    'Email: ${registration.email}',
                                    style: const TextStyle(
                                      fontFamily: 'NunitoSans',
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 15),

                                  // Tombol batalkan pendaftaran
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton.icon(
                                      onPressed: () {
                                        // Dialog konfirmasi pembatalan
                                        Get.dialog(
                                          AlertDialog(
                                            title: const Text(
                                              'Batalkan Pendaftaran',
                                              style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w700,
                                                fontSize: 20.0,
                                              ),
                                            ),
                                            content: const Text(
                                              'Apakah Anda yakin ingin membatalkan pendaftaran ini?',
                                              style: TextStyle(
                                                fontFamily: 'NunitoSans',
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                            actions: [
                                              // Tombol tidak
                                              TextButton(
                                                onPressed: () => Get.back(),
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
                                                onPressed: () async {
                                                  Get.back();
                                                  try {
                                                    await eventController
                                                        .cancelEventRegistration(
                                                            registration.id);
                                                  } catch (e) {
                                                    Get.snackbar(
                                                      'Error',
                                                      'Gagal membatalkan pendaftaran',
                                                      backgroundColor:
                                                          Colors.red[100],
                                                      colorText:
                                                          Colors.red[900],
                                                    );
                                                  }
                                                },
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
                                      },
                                      icon: const Icon(Icons.cancel_outlined,
                                          color: Colors.red),
                                      label: const Text(
                                        'Batalkan Pendaftaran',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    }),
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
