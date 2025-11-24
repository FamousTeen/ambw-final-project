import 'package:flutter/material.dart';
import 'package:manpro/features/bagian_utama/models/eventModel.dart';
import 'package:carousel_slider/carousel_slider.dart';

class EventDetail extends StatelessWidget {
  final Event event;

  const EventDetail({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    // Prepare images for carousel
    List<String> images = [event.image];
    if (event.additionalImages != null) {
      images.addAll(event.additionalImages!);
    }

    // Get status color
    Color statusColor = event.isCompleted
        ? Colors.red
        : event.isOngoing
            ? Colors.blue
            : Colors.green;

    // Get status text
    String statusText = event.isCompleted
        ? 'Selesai'
        : event.isOngoing
            ? 'Sedang Berlangsung'
            : 'Akan Datang';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Event'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Carousel
            CarouselSlider(
              options: CarouselOptions(
                height: 200,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                autoPlay: images.length > 1,
              ),
              items: images.map((imageUrl) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Status
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusText,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Date and Time
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        '${event.date} ${event.time}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Category
                  if (event.category != null)
                    Row(
                      children: [
                        const Icon(Icons.category, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          event.category?.name ?? 'Uncategorized',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),

                  // Registration Info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Pendaftar',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '${event.registrationsCount} ${event.capacity != null ? '/ ${event.capacity}' : ''}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        if (event.canRegister)
                          ElevatedButton(
                            onPressed: () {
                              // Registration logic here
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: const Text('Daftar Sekarang'),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description
                  const Text(
                    'Deskripsi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.content,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
