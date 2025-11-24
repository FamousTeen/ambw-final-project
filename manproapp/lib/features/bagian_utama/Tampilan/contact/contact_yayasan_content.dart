import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manpro/features/bagian_utama/controllers/contactController.dart';

class ContactYayasanContent extends StatelessWidget {
  ContactYayasanContent({super.key});

  final ContactController contactController = Get.put(ContactController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (contactController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final contact = contactController.contact.value;
      if (contact == null) {
        return const Center(child: Text('Tidak ada data kontak'));
      }

      return Column(
        children: [
          // Alamat
          _buildContactItem(
            icon: Icons.location_on,
            title: 'Alamat',
            content: contact.alamat,
          ),
          const SizedBox(height: 20),

          // Email
          _buildContactItem(
            icon: Icons.email,
            title: 'Email',
            content: contact.email,
          ),
          const SizedBox(height: 20),

          // Nomor Telepon
          _buildContactItem(
            icon: Icons.phone,
            title: 'Nomor Telepon',
            content: contact.noTelp,
          ),
        ],
      );
    });
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 143, 143, 143).withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontFamily: 'NunitoSans',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontFamily: 'NunitoSans',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
