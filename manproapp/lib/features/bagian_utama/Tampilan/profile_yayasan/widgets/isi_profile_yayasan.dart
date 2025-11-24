import 'package:flutter/material.dart';
import '../../../Controllers/foundation_profile_controller.dart';
import '../../../Models/foundation_profile.dart';

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