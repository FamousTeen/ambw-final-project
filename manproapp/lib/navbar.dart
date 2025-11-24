import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:manpro/features/bagian_utama/Tampilan/contact/contact.dart';
import 'package:manpro/features/bagian_utama/Tampilan/forum/forum.dart';
import 'package:manpro/features/bagian_utama/Tampilan/home/home.dart';
import 'package:manpro/features/bagian_utama/Tampilan/donation_history/donation_history.dart';
import 'package:manpro/utils/constants/image_string.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80.0,
          elevation: 0,
          backgroundColor: Colors.white,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          destinations: [
            const NavigationDestination(
                icon: Icon(Iconsax.home), label: 'Home'),
            const NavigationDestination(
                icon: Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: ImageIcon(
                    AssetImage(YPKImages.icon_forum),
                  ),
                ),
                label: 'Forum'),
            NavigationDestination(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Transform.scale(
                    scale: 1.35,
                    child: const ImageIcon(
                      AssetImage(YPKImages.icon_contact),
                    ),
                  ),
                ),
                label: 'Contact'),
            NavigationDestination(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Transform.scale(
                    scale: 1.8,
                    child: const ImageIcon(
                      AssetImage(YPKImages.icon_history),
                    ),
                  ),
                ),
                label: 'History'),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const Home(),
    const Forum(),
    const KontakYayasan(),
    DonationHistory()
  ];

  @override
  void onInit() {
    super.onInit();
    // Handle initial index from arguments only when first created
    final arguments = Get.arguments;
    if (arguments != null && arguments is int) {
      selectedIndex.value = arguments;
    }
  }
}
