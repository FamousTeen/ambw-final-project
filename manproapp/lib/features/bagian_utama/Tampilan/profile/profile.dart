import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manpro/common/widgets/background_app.dart';
import 'package:manpro/features/bagian_utama/Tampilan/profile/edit_profile/edit_profile.dart';
import 'package:manpro/navbar.dart';
import 'package:manpro/utils/constants/image_string.dart';
import 'package:manpro/features/bagian_utama/controllers/profileController.dart';

// Halaman untuk menampilkan profil pengguna
class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // Controller untuk mengelola data profil
  final ProfileController profileController = Get.find<ProfileController>();

  // Map untuk menyimpan text controller
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    // Memuat data profil saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfile();
    });
  }

  // Fungsi untuk memuat data profil
  Future<void> _loadProfile() async {
    try {
      await profileController.getProfile();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal memuat profil'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Fungsi untuk mendapatkan text controller
  TextEditingController _getController(String key, String value) {
    if (!_controllers.containsKey(key)) {
      _controllers[key] = TextEditingController(text: value);
    } else {
      _controllers[key]!.text = value;
    }
    return _controllers[key]!;
  }

  @override
  void dispose() {
    // Membersihkan text controller saat widget di dispose
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Navbar()),
        );
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Background aplikasi
            const BackgroundAPP(),

            // Content
            SafeArea(
              child: Obx(() {
                // Menampilkan loading indicator
                if (profileController.isLoading.value) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'Loading profile...',
                          style: TextStyle(
                            fontFamily: 'NunitoSans',
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Mengambil data profil
                final userData = profileController.userData;

                // Menampilkan pesan jika data kosong
                if (userData.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        const Text(
                          'No profile data available',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _loadProfile,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                }

                // Menampilkan data profil
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tombol back
                        IconButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Navbar()),
                            );
                          },
                          icon: const ImageIcon(
                            AssetImage(YPKImages.icon_back_button),
                            size: 32.0,
                          ),
                        ),

                        const SizedBox(height: 20.0),

                        // Judul halaman
                        const Center(
                          child: Text(
                            'My Profile',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                              fontSize: 24.0,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),

                        // Container untuk data profil
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Foto profil dan tombol edit foto
                              Stack(
                                children: [
                                  // Foto profil
                                  Container(
                                    width: 200,
                                    height: 200,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: AssetImage(YPKImages.gbr_event1),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  // Tombol edit foto
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: IconButton(
                                      icon: const ImageIcon(
                                        AssetImage(YPKImages.icon_edit_gbr),
                                        size: 32.0,
                                      ),
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('Coming soon!'),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              // Field untuk nama lengkap
                              TextField(
                                readOnly: true,
                                controller: _getController('nama_lengkap',
                                    userData['nama_lengkap']?.toString() ?? ''),
                                style: const TextStyle(
                                  fontFamily: "NunitoSans",
                                  fontWeight: FontWeight.w700,
                                ),
                                decoration: const InputDecoration(
                                  labelText: 'Nama Lengkap',
                                  labelStyle: TextStyle(
                                    fontFamily: 'NunitoSans',
                                    fontWeight: FontWeight.w700,
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Field untuk username
                              TextField(
                                readOnly: true,
                                controller: _getController('username',
                                    userData['username']?.toString() ?? ''),
                                style: const TextStyle(
                                  fontFamily: "NunitoSans",
                                  fontWeight: FontWeight.w700,
                                ),
                                decoration: const InputDecoration(
                                  labelText: 'Username',
                                  labelStyle: TextStyle(
                                    fontFamily: 'NunitoSans',
                                    fontWeight: FontWeight.w700,
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Field untuk email
                              TextField(
                                readOnly: true,
                                controller: _getController('email',
                                    userData['email']?.toString() ?? ''),
                                style: const TextStyle(
                                  fontFamily: "NunitoSans",
                                  fontWeight: FontWeight.w700,
                                ),
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: TextStyle(
                                    fontFamily: 'NunitoSans',
                                    fontWeight: FontWeight.w700,
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Field untuk kota asal
                              TextField(
                                readOnly: true,
                                controller: _getController('kota_asal',
                                    userData['kota_asal']?.toString() ?? ''),
                                style: const TextStyle(
                                  fontFamily: "NunitoSans",
                                  fontWeight: FontWeight.w700,
                                ),
                                decoration: const InputDecoration(
                                  labelText: 'Kota Asal',
                                  labelStyle: TextStyle(
                                    fontFamily: 'NunitoSans',
                                    fontWeight: FontWeight.w700,
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Field untuk nomor telepon
                              TextField(
                                readOnly: true,
                                controller: _getController('no_telpon',
                                    userData['no_telpon']?.toString() ?? ''),
                                style: const TextStyle(
                                  fontFamily: "NunitoSans",
                                  fontWeight: FontWeight.w700,
                                ),
                                decoration: const InputDecoration(
                                  labelText: 'No Telpon',
                                  labelStyle: TextStyle(
                                    fontFamily: 'NunitoSans',
                                    fontWeight: FontWeight.w700,
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Tombol Edit Profile
                              ElevatedButton(
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditProfile(
                                        userData:
                                            Map<String, dynamic>.from(userData),
                                      ),
                                    ),
                                  );
                                  if (result == true) {
                                    _loadProfile();
                                  }
                                },
                                child: const Text(
                                  'Edit Profile',
                                  style: TextStyle(
                                    fontFamily: 'NunitoSans',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
