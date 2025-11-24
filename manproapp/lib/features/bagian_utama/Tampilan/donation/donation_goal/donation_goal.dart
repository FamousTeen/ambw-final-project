import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manpro/features/bagian_utama/Tampilan/donation/donation.dart';
import 'package:manpro/navbar.dart';
import 'package:manpro/common/widgets/background_app.dart';
import 'package:manpro/utils/constants/image_string.dart';
import '../../../Controllers/donation_goal_controller.dart';

/// DonationGoal widget menampilkan daftar target donasi dengan UI yang menarik
/// Menggunakan GetX untuk state management dan navigasi
class DonationGoal extends StatelessWidget {
  DonationGoal({super.key});

  // Controller untuk mengelola state dan data donasi
  final DonationGoalController controller = Get.put(DonationGoalController());

  // Daftar warna pastel untuk kartu donasi
  static final Map<String, Color> _typeColors = {};
  final List<Color> _pastelColors = const [
    Color(0xFFFFB5B5), // Merah muda
    Color(0xFFA8E6CF), // Hijau mint
    Color(0xFFFFE3B3), // Kuning
    Color(0xFFD4B5FF), // Ungu muda
    Color(0xFFB5D8FF), // Biru muda
    Color(0xFFFFC8A2), // Peach
    Color(0xFFE5B5FF), // Pink muda
    Color(0xFFB5FFD9), // Mint muda
    Color(0xFFFFB5E5), // Pink tua
    Color(0xFFB5FFFF), // Cyan muda
  ];

  // Mendapatkan warna untuk tipe donasi tertentu
  Color _getColorForType(String type) {
    return _typeColors[type] ??=
        _pastelColors[_typeColors.length % _pastelColors.length];
  }

  // Navigasi ke halaman donasi dengan tipe tertentu
  void _navigateToDonation(String type) {
    try {
      Get.to(() => const Donation());
    } catch (e) {
      Get.snackbar(
        'Error',
        'Tidak dapat membuka halaman donasi',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Membersihkan teks dari karakter HTML
  String _sanitizeText(String? text) {
    if (text == null || text.isEmpty) return '';
    return text.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  // Mengubah angka menjadi string dengan aman
  String _formatNumber(num? value) {
    return value?.toString() ?? '0';
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
                    'Report',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 24.0,
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 20.0),

                  // Daftar donasi dengan pull-to-refresh
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        try {
                          await controller.fetchDonationGoals();
                        } catch (e) {
                          // Error sudah ditangani di controller
                        }
                      },
                      child: Obx(() {
                        // Tampilkan loading indicator saat memuat data
                        if (controller.isLoading.value) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        // Tampilkan pesan error jika terjadi kesalahan
                        if (controller.error.isNotEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(_sanitizeText(controller.error.value)),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () =>
                                      controller.fetchDonationGoals(),
                                  child: const Text('Coba Lagi'),
                                ),
                              ],
                            ),
                          );
                        }

                        // Tampilkan pesan jika tidak ada data
                        if (controller.goals.isEmpty) {
                          return const Center(
                            child: Text('Belum ada target donasi'),
                          );
                        }

                        // Tampilkan daftar donasi
                        return ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: controller.goals.length,
                          itemBuilder: (context, index) {
                            final goal = controller.goals[index];
                            final cardColor = _getColorForType(goal.type);
                            final percentage =
                                goal.percentage.clamp(0.0, 100.0);

                            // Kartu donasi
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  borderRadius: BorderRadius.circular(25.0),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2.0,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      // Informasi donasi
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                // Ikon donasi
                                                Container(
                                                  width: 80,
                                                  height: 80,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            40),
                                                    border: Border.all(
                                                      color: Colors.black,
                                                      width: 1.5,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Image.asset(
                                                      YPKImages
                                                          .icon_back_button,
                                                      width: 24,
                                                      height: 24,
                                                      color: Colors.black,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return const Icon(
                                                            Icons.error);
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                // Detail donasi
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        _sanitizeText(
                                                            goal.type),
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        '${_formatNumber(goal.currentQuantity)}/${_formatNumber(goal.targetQuantity)}',
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 16),

                                      // Progress bar donasi
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: LinearProgressIndicator(
                                          value: percentage / 100,
                                          backgroundColor:
                                              Colors.white.withOpacity(0.5),
                                          valueColor:
                                              const AlwaysStoppedAnimation<
                                                  Color>(
                                            Colors.black,
                                          ),
                                          minHeight: 8,
                                        ),
                                      ),

                                      const SizedBox(height: 16),

                                      // Tombol donasi
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () =>
                                                  _navigateToDonation(
                                                      goal.type),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white,
                                                foregroundColor: Colors.black,
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  side: const BorderSide(
                                                    color: Colors.black,
                                                    width: 1.5,
                                                  ),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 12,
                                                ),
                                              ),
                                              child: const Text(
                                                'Donate',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
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
