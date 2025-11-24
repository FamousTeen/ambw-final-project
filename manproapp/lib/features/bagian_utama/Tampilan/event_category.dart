import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manpro/common/widgets/background_app.dart';
import 'package:manpro/features/bagian_utama/controllers/eventController.dart';
import 'package:manpro/features/bagian_utama/controllers/eventCategoryController.dart';
import 'package:manpro/utils/constants/image_string.dart';

class EventCategory extends StatelessWidget {
  EventCategory({super.key});

  final EventController eventController = Get.find<EventController>();
  final EventCategoryController categoryController =
      Get.put(EventCategoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundAPP(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const ImageIcon(
                      AssetImage(YPKImages.icon_back_button),
                      size: 32.0,
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  const Text(
                    'Event Categories',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 24.0,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  // Tombol Reset dengan icon baru
                  Obx(() => eventController.selectedCategory.value.isNotEmpty
                      ? TextButton.icon(
                          onPressed: () {
                            eventController.resetFilter();
                            Get.back();
                          },
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text(
                            'Reset Filter',
                            style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                        )
                      : const SizedBox()),
                  const SizedBox(height: 20.0),
                  Expanded(
                    child: Obx(() {
                      if (categoryController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (categoryController.categories.isEmpty) {
                        return const Center(
                          child: Text(
                            'No categories available',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: categoryController.categories.length,
                        itemBuilder: (context, index) {
                          final category = categoryController.categories[index];
                          final isSelected =
                              eventController.selectedCategory.value ==
                                  category.slug;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            child: InkWell(
                              onTap: () {
                                eventController.filterByCategory(category.slug);
                                Get.back();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.blue.withOpacity(0.1)
                                      : Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(15),
                                  border: isSelected
                                      ? Border.all(color: Colors.blue, width: 2)
                                      : null,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      category.name,
                                      style: TextStyle(
                                        fontFamily: 'NunitoSans',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        color: isSelected
                                            ? Colors.blue
                                            : Colors.black,
                                      ),
                                    ),
                                    if (isSelected)
                                      const Icon(
                                        Icons.check_circle,
                                        color: Colors.blue,
                                        size: 24,
                                      )
                                    else
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
