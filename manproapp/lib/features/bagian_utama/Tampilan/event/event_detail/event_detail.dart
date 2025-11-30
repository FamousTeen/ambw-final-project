import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manpro/features/bagian_utama/controllers/eventController.dart';
import 'package:manpro/utils/constants/image_string.dart';
import 'package:manpro/common/widgets/background_app.dart';
import 'package:manpro/features/bagian_utama/Tampilan/event/event_detail/regis_event/regis_event.dart';

class EventDetail extends StatefulWidget {
  final int eventId;
  final String title;
  final String content;
  final String image;
  final String date;
  final String time;
  final String status;
  final String category;
  final List<String>? additionalImages;
  final int? capacity;
  final int registrationsCount;

  const EventDetail({
    super.key,
    required this.eventId,
    required this.title,
    required this.content,
    required this.image,
    required this.date,
    required this.time,
    required this.status,
    required this.category,
    this.additionalImages,
    this.capacity,
    required this.registrationsCount,
  });

  @override
  State<EventDetail> createState() => _EventDetailState();

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.red;
      case 'ongoing':
        return Colors.blue;
      case 'upcoming':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

class _EventDetailState extends State<EventDetail> {
  final _pageController = PageController();
  final _currentPage = 0.obs;
  final _images = <String>[].obs;
  final _isLoading = true.obs;
  late final EventController _eventController;
  
  // Local state for dynamic updates
  late int _registrationsCount;
  late int? _capacity;

  @override
  void initState() {
    super.initState();
    _eventController = Get.find<EventController>();
    
    // Initialize local state from widget parameters
    _registrationsCount = widget.registrationsCount;
    _capacity = widget.capacity;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeImages();
      _loadEventDetail();
    });
  }

  void _initializeImages() {
    if (widget.image.isNotEmpty) {
      _images.add(widget.image);
    }
    if (widget.additionalImages != null &&
        widget.additionalImages!.isNotEmpty) {
      _images.addAll(widget.additionalImages!);
    }
  }

  Future<void> _loadEventDetail() async {
    try {
      await _eventController.refreshEventDetail(widget.eventId);
      final event = _eventController.events.firstWhereOrNull(
        (e) => e.id == widget.eventId,
      );

      if (event != null) {
        // Update local state with fresh data
        if (mounted) {
          setState(() {
            _registrationsCount = event.registrationsCount;
            _capacity = event.capacity;
          });
        }

        if (event.additionalImages != null &&
            event.additionalImages!.isNotEmpty) {
          _images.clear();
          if (event.image.isNotEmpty) {
            _images.add(event.image);
          }
          _images.addAll(event.additionalImages!);
        }
      }
    } catch (e) {
      print('Error loading event detail: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Improved validation for slot availability
  bool _isSlotAvailable() {
    // If no capacity set, event is always available
    if (_capacity == null) return true;

    // Basic validation checks
    if (_registrationsCount < 0) return false;
    if (_capacity! <= 0) return false;

    // Check if slots are still available
    return _registrationsCount < _capacity!;
  }

  // Improved validation for registration eligibility
  bool _canRegister() {
    // Check event status
    if (widget.status.toLowerCase() != 'upcoming') {
      return false;
    }

    // Check if event data is valid
    if (widget.title.isEmpty || widget.date.isEmpty || widget.content.isEmpty) {
      return false;
    }

    return true;
  }

  // Get text for registration button
  String _getRegistrationButtonText() {
    if (!_canRegister()) {
      return 'Event Not Available';
    }
    return _isSlotAvailable() ? 'Register Now' : 'Slot Penuh';
  }

  // Get color for registration button
  Color _getRegistrationButtonColor() {
    if (!_canRegister() || !_isSlotAvailable()) {
      return Colors.grey;
    }
    return const Color(0xFFF7ABFB);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundAPP(),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
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
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Events',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            fontSize: 24.0,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Category and Status moved to right side
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7ABFB).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.category,
                            style: const TextStyle(
                              color: Color(0xFFF7ABFB),
                              fontSize: 12,
                              fontFamily: 'NunitoSans',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: widget
                                .getStatusColor(widget.status)
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.status,
                            style: TextStyle(
                              color: widget.getStatusColor(widget.status),
                              fontSize: 12,
                              fontFamily: 'NunitoSans',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Image Gallery section
                    Obx(() {
                      if (_isLoading.value) {
                        return const SizedBox(
                          height: 500,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (_images.isEmpty) {
                        return const SizedBox(
                          height: 500,
                          child: Center(child: Text('No images available')),
                        );
                      }

                      return SizedBox(
                        height: 500,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            PageView.builder(
                              controller: _pageController,
                              itemCount: _images.length,
                              onPageChanged: (index) =>
                                  _currentPage.value = index,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 0,
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                      _images[index],
                                      fit: BoxFit.fill,
                                      cacheWidth: 800,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey[300],
                                          child: const Center(
                                            child: Icon(
                                              Icons.error_outline,
                                              color: Colors.grey,
                                              size: 50,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                            if (_images.length > 1)
                              Positioned(
                                bottom: 16,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    _images.length,
                                    (index) => Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 2),
                                      width:
                                          _currentPage.value == index ? 12 : 8,
                                      height:
                                          _currentPage.value == index ? 12 : 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _currentPage.value == index
                                            ? Colors.black.withOpacity(0.9)
                                            : Colors.grey.withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.date,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      fontFamily: 'NunitoSans',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  if (widget.time.isNotEmpty &&
                                      widget.time != '00:00') ...[
                                    const SizedBox(width: 8),
                                    Text(
                                      widget.time,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontFamily: 'NunitoSans',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontFamily: 'NunitoSans',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.content,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'NunitoSans',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (_capacity != null) ...[
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Kapasitas Event',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'NunitoSans',
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '$_registrationsCount / $_capacity',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'NunitoSans',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: _getCapacityColor(),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      _getCapacityStatus(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontFamily: 'NunitoSans',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_canRegister())
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSlotAvailable()
                              ? () => Get.to(() => RegisEvent(
                                    eventId: widget.eventId,
                                    eventName: widget.title,
                                  ))
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _getRegistrationButtonColor(),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: _isSlotAvailable()
                                    ? Colors.black
                                    : Colors.grey,
                                width: 1.5,
                              ),
                            ),
                          ),
                          child: Text(
                            _getRegistrationButtonText(),
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w600,
                              color: _isSlotAvailable()
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCapacityColor() {
    if (_capacity == null) return Colors.blue;

    final percentage = (_registrationsCount / _capacity!) * 100;
    if (percentage >= 100) {
      return Colors.red;
    } else if (percentage >= 80) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  String _getCapacityStatus() {
    if (_capacity == null) return 'Tidak ada batasan slot';

    final percentage = (_registrationsCount / _capacity!) * 100;
    if (percentage >= 100) {
      return 'Slot Penuh';
    } else if (percentage >= 80) {
      return 'Slot Terbatas';
    } else {
      return 'Slot Tersedia';
    }
  }
}
