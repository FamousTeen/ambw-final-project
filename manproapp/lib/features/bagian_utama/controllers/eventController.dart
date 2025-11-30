import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:manpro/utils/constants/api_constants.dart';
import 'package:manpro/features/bagian_utama/models/eventModel.dart';
import 'package:manpro/features/bagian_utama/Tampilan/event_history/event_history.dart';

// API Response Helper
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
  });
}

class EventController extends GetxController {
  // =========== VARIABLES ===========
  static EventController get instance => Get.find<EventController>();

  // Observable States
  final isLoading = false.obs;
  final events = <Event>[].obs;
  final eventHistory = <EventRegistration>[].obs;
  final selectedCategory = RxString('');
  final errorMessage = RxString('');

  // Cache Management
  final _eventCache = <String, List<Event>>{}.obs;
  final box = GetStorage();

  // =========== LIFECYCLE METHODS ===========
  @override
  void onInit() {
    super.onInit();
    initializeData();
  }

  // =========== INITIALIZATION ===========
  Future<void> initializeData() async {
    await getEvents();
    await getEventHistory();
  }

  // =========== API HELPERS ===========
  Future<Map<String, String>> get _headers async {
    final token = box.read('token');
    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  void _handleError(String operation, dynamic error) {
    print('Error during $operation: $error');
    errorMessage.value = '$operation gagal. $error.';
    Get.snackbar(
      'Error',
      errorMessage.value,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  // =========== EVENT LIST METHODS ===========
  Future<void> getEvents({String? category}) async {
    int retryCount = 0;
    const maxRetries = 3;

    while (retryCount < maxRetries) {
      try {
        if (isLoading.value) return;
        isLoading.value = true;
        errorMessage.value = '';

        // Check cache first
        final cacheKey = category ?? 'all';
        if (_eventCache.containsKey(cacheKey)) {
          events.value = _eventCache[cacheKey]!;
          // Refresh in background
          _refreshEventsInBackground(category);
          return;
        }

        // Build API endpoint
        String endpoint = '${url}events/list';
        if (category != null && category.isNotEmpty) {
          endpoint += '?category=$category';
        }

        // Make API call
        final response = await http.get(
          Uri.parse(endpoint),
          headers: await _headers,
        );

        if (response.statusCode == 200) {
          final responseJson = json.decode(response.body);
          final List<dynamic> data = responseJson['data'];

          // Convert and sort events
          final parsedEvents =
              data.map((json) => Event.fromJson(json)).toList();
          _sortEvents(parsedEvents);

          // Update cache and state
          _eventCache[cacheKey] = parsedEvents;
          events.value = parsedEvents;
          break;
        } else if (response.statusCode == 401) {
          // Handle unauthorized access
          Get.offAllNamed('/login');
          break;
        } else {
          throw 'Failed to load events';
        }
      } catch (e) {
        retryCount++;
        if (retryCount == maxRetries) {
          _handleError('fetching events', e);
        } else {
          await Future.delayed(Duration(seconds: retryCount));
        }
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> _refreshEventsInBackground(String? category) async {
    try {
      String endpoint = '${url}events/list';
      if (category != null && category.isNotEmpty) {
        endpoint += '?category=$category';
      }

      final response = await http.get(
        Uri.parse(endpoint),
        headers: await _headers,
      );

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        final List<dynamic> data = responseJson['data'];

        final parsedEvents = data.map((json) => Event.fromJson(json)).toList();
        _sortEvents(parsedEvents);

        final cacheKey = category ?? 'all';
        _eventCache[cacheKey] = parsedEvents;
        events.value = parsedEvents;
      }
    } catch (e) {
      print('Background refresh failed: $e');
    }
  }

  /// Fetches active events for home screen carousel
  Future<void> getActiveEventImages() async {
    await getEvents();
  }

  // =========== EVENT DETAIL METHODS ===========
  Future<Event?> getEventDetail(int eventId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await http.get(
        Uri.parse('${url}events/$eventId'),
        headers: await _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        return Event.fromJson(data);
      } else if (response.statusCode == 401) {
        Get.offAllNamed('/login');
      }
      return null;
    } catch (e) {
      _handleError('fetching event detail', e);
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshEventDetail(int eventId) async {
    final event = await getEventDetail(eventId);
    if (event != null) {
      final index = events.indexWhere((e) => e.id == eventId);
      if (index != -1) {
        events[index] = event;
      }
    }
  }

  // =========== EVENT REGISTRATION METHODS ===========
  Future<bool> validateEmail(String email) async {
    try {
      final response = await http.post(
        Uri.parse('${url}validate-email'),
        headers: await _headers,
        body: {'email': email},
      );

      return response.statusCode == 200;
    } catch (e) {
      _handleError('validating email', e);
      return false;
    }
  }

  Future<void> registerEvent({
    required int eventId,
    required String name,
    required String email,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Validations
      final event = await getEventDetail(eventId);
      if (event == null) {
        throw 'Event tidak ditemukan';
      }
      if (!event.canRegister) {
        throw 'Pendaftaran untuk event ini sudah ditutup';
      }
      if (!await validateEmail(email)) {
        throw 'Email tidak valid';
      }

      // Register for event
      final response = await http.post(
        Uri.parse('${url}events/register'),
        headers: await _headers,
        body: {
          'event_id': eventId.toString(),
          'name': name,
          'email': email,
        },
      );

      if (response.statusCode == 201) {
        Get.snackbar(
          'Sukses',
          'Berhasil mendaftar event',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await getEventHistory();
        Get.off(() => const EventHistory());
      } else {
        throw 'Gagal mendaftar event';
      }
    } catch (e) {
      _handleError('registering event', e);
    } finally {
      isLoading.value = false;
    }
  }

  // =========== EVENT HISTORY METHODS ===========
  Future<void> getEventHistory() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await http.get(
        Uri.parse('${url}event/history'),
        headers: await _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        eventHistory.value =
            data.map((json) => EventRegistration.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        Get.offAllNamed('/login');
      }
    } catch (e) {
      _handleError('fetching event history', e);
    } finally {
      isLoading.value = false;
    }
  }

  /// Cancels an event registration
  Future<void> cancelEventRegistration(int registrationId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await http.delete(
        Uri.parse('${url}events/registration/$registrationId'),
        headers: await _headers,
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Registration cancelled successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await getEventHistory();
      } else {
        throw 'Failed to cancel registration';
      }
    } catch (e) {
      _handleError('cancelling registration', e);
    } finally {
      isLoading.value = false;
    }
  }

  // =========== HELPER METHODS ===========
  void _sortEvents(List<Event> eventList) {
    eventList.sort((a, b) {
      try {
        final partsA = a.date.split(' ');
        final partsB = b.date.split(' ');

        if (partsA.length != 3 || partsB.length != 3) return 0;

        final yearA = int.parse(partsA[2]);
        final yearB = int.parse(partsB[2]);
        if (yearA != yearB) return yearB.compareTo(yearA);

        final monthA = _parseMonth(partsA[1]);
        final monthB = _parseMonth(partsB[1]);
        if (monthA != monthB) return monthB.compareTo(monthA);

        final dayA = int.parse(partsA[0]);
        final dayB = int.parse(partsB[0]);
        return dayB.compareTo(dayA);
      } catch (e) {
        print('Error sorting dates: $e');
        return 0;
      }
    });
  }

  static int _parseMonth(String month) {
    const months = {
      'January': 1,
      'February': 2,
      'March': 3,
      'April': 4,
      'May': 5,
      'June': 6,
      'July': 7,
      'August': 8,
      'September': 9,
      'October': 10,
      'November': 11,
      'December': 12
    };
    return months[month] ?? 1;
  }

  // =========== CATEGORY METHODS ===========
  Future<void> filterByCategory(String category) async {
    selectedCategory.value = category;
    await getEvents(category: category);
  }

  void resetFilter() {
    selectedCategory.value = '';
    getEvents();
  }
}
