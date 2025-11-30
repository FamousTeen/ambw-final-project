import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manpro/features/bagian_utama/Tampilan/article/article.dart';
import 'package:manpro/features/bagian_utama/Tampilan/donation/donation.dart';
import 'package:manpro/features/bagian_utama/Tampilan/donation/donation_gallery/donation_gallery.dart';
import 'package:manpro/features/bagian_utama/Tampilan/event/event.dart';
import 'package:manpro/features/bagian_utama/Tampilan/event/event_detail/event_detail.dart';
import 'package:manpro/features/bagian_utama/Tampilan/profile_yayasan/profile_yayasan.dart';
import 'package:manpro/features/bagian_utama/controllers/eventController.dart';
import 'package:manpro/utils/constants/image_string.dart';
import 'package:manpro/features/bagian_utama/Tampilan/home/side_navbar.dart';
import 'package:manpro/features/bagian_utama/controllers/profileController.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // =========== CONTROLLERS ===========
  final profileController = Get.put(ProfileController());
  late final EventController eventController;

  // =========== UI CONTROLLERS ===========
  final currentPage = 0.obs;
  final pageController = PageController();

  // =========== LIFECYCLE METHODS ===========
  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  // =========== INITIALIZATION ===========
  void _initializeControllers() {
    // Initialize EventController once
    eventController = Get.put(EventController());

    // Load events after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (eventController.events.isEmpty) {
        eventController.getActiveEventImages();
      }
    });
  }

  // =========== BUILD METHOD ===========
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer:
          SideNavbar(), // Menggunakan side navbar dari class SideNavbar di sebelah kanan
      body: Container(
        // Background app
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25.0, 7.0, 12.0, 0.0),
          // Wrap the content in a scroll view so the UI doesn't overflow
          // on smaller screens or when keyboard is visible.
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Gambar logo yayasan
                    Container(
                      padding: const EdgeInsets.only(left: 13.0),
                      width: 120,
                      height: 120,
                      child: Transform.scale(
                        scale: 1.8,
                        child: Image.asset(
                          'assets/logos/logo yayasan.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const Spacer(),

                    // Pencetan garis tiga
                    Builder(
                      builder: (BuildContext context) {
                        return IconButton(
                          icon: Image.asset(
                              'assets/icons/garis tiga.jpg'), // Ganti dengan path ikon kamu
                          onPressed: () {
                            Scaffold.of(context)
                                .openEndDrawer(); // Membuka side navbar di sebelah kanan
                          },
                        );
                      },
                    ),
                  ],
                ),
                Obx(
                  () => Text(
                    'Halo, ${profileController.userData['nama_lengkap'] ?? 'User'} !',
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 24.0,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 27.0),

                //Tulisan event information
                const Text(
                  'Event Information',
                  style: TextStyle(
                    fontFamily: 'NunitoSans',
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 15.0),

                // Box gambar event
                Padding(
                  padding: const EdgeInsets.only(right: 13.0),
                  child: Container(
                    height: 500.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Obx(() {
                          if (eventController.isLoading.value) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          return PageView.builder(
                            controller: pageController,
                            onPageChanged: (index) {
                              currentPage.value = index;
                            },
                            itemCount: eventController.events.length,
                            itemBuilder: (context, index) {
                              final event = eventController.events[index];
                              return GestureDetector(
                                onTap: () {
                                  Get.to(() => EventDetail(
                                        title: event.title,
                                        content: event.content,
                                        image: event.image,
                                        date: event.date,
                                        registrationsCount:
                                            event.registrationsCount,
                                        time: event.time,
                                        eventId: event.id,
                                        category: event.category?.name ??
                                            'Uncategorized',
                                        status: event.status,
                                        additionalImages:
                                            event.additionalImages,
                                      ));
                                },
                                child: Card(
                                  margin: const EdgeInsets.all(8.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.network(
                                      event.image,
                                      fit: BoxFit.fill,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          YPKImages.gbr_event1,
                                          fit: BoxFit.fill,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                        Positioned(
                          bottom: 10,
                          left: 0,
                          right: 0,
                          child: Obx(
                            () => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                eventController.events.length,
                                (index) => Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  width: currentPage.value == index ? 12 : 8,
                                  height: currentPage.value == index ? 12 : 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: currentPage.value == index
                                        ? Colors.black.withOpacity(0.9)
                                        : Colors.grey.withOpacity(0.7),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 100),

                //Menu di home screen
                Padding(
                  padding: const EdgeInsets.only(right: 13.0),
                  child: Container(
                    height: 275.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 6,
                          blurRadius: 7,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.fromLTRB(22.5, 15.0, 22.5, 15.0),
                      child: Column(
                        children: [
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Bagian UI Events
                              Column(
                                children: [
                                  SizedBox(
                                    height: 80,
                                    width: 80,
                                    child: IconButton(
                                      onPressed: () =>
                                          Get.to(() => const Event()),
                                      icon: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 7.0),
                                        child: Transform.scale(
                                          scale: 1.55,
                                          child: Image.asset(
                                            'assets/icons/icon event.png',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    'Events',
                                    style: TextStyle(
                                      fontFamily: 'NunitoSans',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                ],
                              ),
                              const Spacer(),

                              // Bagian UI Article
                              Column(
                                children: [
                                  SizedBox(
                                    height: 80,
                                    width: 80,
                                    child: IconButton(
                                      onPressed: () =>
                                          Get.to(() => const Article()),
                                      icon: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            13.0, 0.0, 0.0, 3.0),
                                        child: Transform.scale(
                                          scale: 1.18,
                                          child: Image.asset(
                                            'assets/icons/icon article.png',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    'Article',
                                    style: TextStyle(
                                      fontFamily: 'NunitoSans',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                ],
                              ),
                              const Spacer(),

                              // Bagian UI Profile Yayasan
                              Column(
                                children: [
                                  SizedBox(
                                    height: 80,
                                    width: 80,
                                    child: IconButton(
                                      onPressed: () =>
                                          Get.to(() => const ProfileYayasan()),
                                      icon: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            3.0, 0.0, 0.0, 0.0),
                                        child: Transform.scale(
                                          scale: 1.28,
                                          child: Image.asset(
                                            YPKImages.icon_profile_yayasan,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    'Profile\nYayasan',
                                    style: TextStyle(
                                      fontFamily: 'NunitoSans',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Bagian UI Donation
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 300.0), // 👈 shift right
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 80,
                                      width: 80,
                                      child: IconButton(
                                        onPressed: () =>
                                            Get.to(() => const Donation()),
                                        icon: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0.0, 0.0, 7.0, 0.0),
                                          child: Transform.scale(
                                            scale: 0.95,
                                            child: Image.asset(
                                              'assets/icons/icon donation.png',
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      'Donation',
                                      style: TextStyle(
                                        fontFamily: 'NunitoSans',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 10.0),
                                  ],
                                ),
                              ),

                              const Spacer(),

                              // Bagian UI Donation Gallery
                              Container(
                                margin: const EdgeInsets.fromLTRB(
                                    250.0, 6.0, 3.0, 0.0),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 80,
                                      width: 80,
                                      child: IconButton(
                                        onPressed: () => Get.to(
                                            () => const DonationGallery()),
                                        icon: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0.0, 15.0, 1.0, 0.0),
                                          child: Transform.scale(
                                            scale: 1.45,
                                            child: Image.asset(
                                              'assets/icons/icon donation gallery.png',
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      'Donation\nGallery',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'NunitoSans',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),

                              // Bagian UI Report
                              // Column(
                              //   children: [
                              //     SizedBox(
                              //       height: 80,
                              //       width: 80,
                              //       child: IconButton(
                              //         onPressed: () => Get.to(() => DonationGoal()),
                              //         icon: Padding(
                              //           padding: const EdgeInsets.fromLTRB(0.0, 5.0, 9.0, 0.0),
                              //           child: Transform.scale(
                              //             scale: 0.85,
                              //             child: Image.asset(
                              //               'assets/icons/icon report.png',
                              //               fit: BoxFit.contain,
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //     const Text(
                              //       'Report',
                              //       style: TextStyle(
                              //         fontFamily: 'NunitoSans',
                              //         fontWeight: FontWeight.w500,
                              //       ),
                              //     ),
                              //     const SizedBox(height: 10.0),
                              //   ],
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(),
    );
  }
}
