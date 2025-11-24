import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manpro/common/widgets/background_app.dart';
import 'package:manpro/features/bagian_utama/Tampilan/event/event_detail/event_detail.dart';
import 'package:manpro/navbar.dart';
import 'package:manpro/utils/constants/image_string.dart';
import 'package:manpro/features/bagian_utama/controllers/eventController.dart';
import 'package:manpro/features/bagian_utama/Tampilan/event_category.dart';

class Event extends StatelessWidget {
  const Event({super.key});

  @override
  Widget build(BuildContext context) {
    final eventController = Get.find<EventController>();

    // Load events jika belum ada
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (eventController.events.isEmpty) {
        eventController.getEvents();
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          const BackgroundAPP(),
          SafeArea(
            child: RefreshIndicator(
              onRefresh: () => eventController.getEvents(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      IconButton(
                        onPressed: () => Get.to(() => const Navbar()),
                        icon: const ImageIcon(
                          AssetImage(YPKImages.icon_back_button),
                          size: 32.0,
                          semanticLabel: 'Back button',
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      const Text(
                        'Events',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          fontSize: 24.0,
                          letterSpacing: -0.5,
                        ),
                        semanticsLabel: 'Events page title',
                      ),
                      IconButton(
                        onPressed: () => Get.to(() => EventCategory()),
                        icon: const Icon(Icons.filter_list),
                        tooltip: 'Filter events by category',
                      ),
                      const SizedBox(height: 20),

                      // Event List Section
                      Obx(() {
                        // Loading State
                        if (eventController.isLoading.value) {
                          return Column(
                            children: List.generate(
                                3,
                                (index) => Container(
                                      margin:
                                          const EdgeInsets.only(bottom: 20.0),
                                      width: 350,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    )),
                          );
                        }

                        // Error State
                        if (eventController.errorMessage.value.isNotEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: Colors.red,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  eventController.errorMessage.value,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'NunitoSans',
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () => eventController.getEvents(),
                                  child: const Text('Try Again'),
                                ),
                              ],
                            ),
                          );
                        }

                        // Empty State
                        if (eventController.events.isEmpty) {
                          return const Center(
                            child: Text(
                              'No events available',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'NunitoSans',
                              ),
                              semanticsLabel: 'No events message',
                            ),
                          );
                        }

                        // Events List
                        return Column(
                          children: eventController.events
                              .map(
                                (event) => Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      print('Event tapped:');
                                      print('- Title: ${event.title}');
                                      print('- Image: ${event.image}');
                                      print(
                                          '- Additional Images: ${event.additionalImages}');

                                      Get.to(
                                        () => EventDetail(
                                          title: event.title,
                                          content: event.content,
                                          image: event.image,
                                          date: event.date,
                                          time: event.time,
                                          eventId: event.id,
                                          category: event.category?.name ??
                                              'Uncategorized',
                                          status: event.status,
                                          additionalImages:
                                              event.additionalImages,
                                          capacity: event.capacity,
                                          registrationsCount:
                                              event.registrationsCount,
                                        ),
                                        transition: Transition.fadeIn,
                                        duration:
                                            const Duration(milliseconds: 300),
                                      );
                                    },
                                    child: Align(
                                      alignment:
                                          const FractionalOffset(0.5, 0.2),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: Stack(
                                          children: [
                                            // Event Image
                                            Image.network(
                                              event.image,
                                              width: 350,
                                              height: 200,
                                              fit: BoxFit.cover,
                                              loadingBuilder: (context, child,
                                                  loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                }
                                                return Container(
                                                  width: 350,
                                                  height: 200,
                                                  color: Colors.grey[300],
                                                  child: const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                );
                                              },
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Container(
                                                  width: 350,
                                                  height: 200,
                                                  color: Colors.grey[300],
                                                  child: const Center(
                                                    child: Icon(
                                                      Icons.error_outline,
                                                      size: 48,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            // Event Info Overlay
                                            Positioned(
                                              bottom: 0,
                                              left: 0,
                                              right: 0,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 12),
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          event.date,
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'NunitoSans',
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 4),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.2),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                          child: Text(
                                                            event.category
                                                                    ?.name ??
                                                                'Uncategorized',
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  'NunitoSans',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      event.title,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontFamily:
                                                            'NunitoSans',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      }),
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
