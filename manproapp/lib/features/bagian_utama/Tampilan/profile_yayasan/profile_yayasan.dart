import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manpro/common/widgets/background_app.dart';
import 'package:manpro/navbar.dart';
import 'package:manpro/utils/constants/image_string.dart';
import '../../Controllers/foundation_profile_controller.dart';
import '../../Models/foundation_profile.dart';

class ProfileYayasan extends StatelessWidget {
  const ProfileYayasan({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          BackgroundAPP(),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tombol back
                    TombolBack(),

                    // Tulisan Profile yayasan
                    TulisanProfile(),
                    SizedBox(height: 35.0),

                    // Container putih dengan shadow
                    ContentContainer(),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// Widget Container Konten
class ContentContainer extends StatelessWidget {
  const ContentContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Padding(
        padding: EdgeInsets.all(20.0),
        child: IsiProfileYayasan(),
      ),
    );
  }
}

// Widget Tombol Back
class TombolBack extends StatelessWidget {
  const TombolBack({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      child: IconButton(
        onPressed: () => Get.to(() => const Navbar()),
        icon: const ImageIcon(
          AssetImage(YPKImages.icon_back_button),
          size: 32.0,
        ),
      ),
    );
  }
}

// Widget Tulisan Profile
class TulisanProfile extends StatelessWidget {
  const TulisanProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Profile Yayasan',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w700,
          fontSize: 24.0,
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}

// Widget Isi Profile Yayasan
class IsiProfileYayasan extends StatefulWidget {
  const IsiProfileYayasan({super.key});

  @override
  State<IsiProfileYayasan> createState() => _IsiProfileYayasanState();
}

class _IsiProfileYayasanState extends State<IsiProfileYayasan> {
  final FoundationProfileController _controller = FoundationProfileController();
  late Future<FoundationProfile> _profileFuture;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() {
    setState(() {
      _profileFuture = _controller.getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FoundationProfile>(
      future: _profileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error: ${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadProfile,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: Text(
              'No profile data available',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }

        return Text(
          snapshot.data!.description,
          textAlign: TextAlign.justify,
          style: const TextStyle(
            fontFamily: 'NunitoSans',
            fontWeight: FontWeight.w700,
            fontSize: 16.0,
            height: 1.5,
          ),
        );
      },
    );
  }
}
