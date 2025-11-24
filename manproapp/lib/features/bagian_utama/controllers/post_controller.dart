import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:manpro/features/bagian_utama/Models/post_Model.dart';
import 'package:manpro/utils/constants/api_constants.dart';

class PostController extends GetxController {
  var posts = <PostModel>[].obs;
  var comments = <CommentModel>[].obs;
  var isLoading = false.obs;
  var error = ''.obs;
  final box = GetStorage();

  Map<String, String> get _headers => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      };

  @override
  void onInit() {
    super.onInit();
    getAllPosts();
  }

  Future<void> getAllPosts() async {
    try {
      isLoading.value = true;
      error.value = '';
      
      final response = await http.get(
        Uri.parse('${url}posts'),
        headers: _headers,
      );

      print('Posts response status: ${response.statusCode}');
      print('Posts response headers: ${response.headers}');
      print('Posts response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('Decoded JSON data: $jsonData');
        
        posts.value = List<PostModel>.from(
            jsonData.map((x) {
              print('Processing post: $x');
              return PostModel.fromJson(x);
            }));
            
        print('Processed posts: ${posts.length}');
        for (var post in posts) {
          print('Post ID: ${post.id}');
          print('Post User: ${post.user?.toJson()}');
        }
      } else if (response.statusCode == 401) {
        error.value = 'Unauthorized access. Please login again.';
        Get.offAllNamed('/login');
      }
    } catch (e) {
      error.value = 'Error getting posts: $e';
      print(error.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createPost({required String content}) async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await http.post(
        Uri.parse('${url}posts'),
        headers: _headers,
        body: json.encode({'content': content}),
      );

      print('Create post response: ${response.body}');

      if (response.statusCode == 200) {
        await getAllPosts();
        return true;
      } else if (response.statusCode == 401) {
        error.value = 'Unauthorized access. Please login again.';
        Get.offAllNamed('/login');
      }
      return false;
    } catch (e) {
      error.value = 'Error creating post: $e';
      print(error.value);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getComments(int? postId) async {
    if (postId == null) return;

    try {
      error.value = '';

      final response = await http.get(
        Uri.parse('${url}posts/$postId/comments'),
        headers: _headers,
      );

      print('Get comments response: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        comments
            .assignAll(jsonData.map((x) => CommentModel.fromJson(x)).toList());
      } else if (response.statusCode == 401) {
        error.value = 'Unauthorized access. Please login again.';
        Get.offAllNamed('/login');
      }
    } catch (e) {
      error.value = 'Error getting comments: $e';
      print(error.value);
    }
  }

  Future<void> createComment(int? postId, String body) async {
    if (postId == null || body.isEmpty) return;

    try {
      isLoading.value = true;
      error.value = '';

      final response = await http.post(
        Uri.parse('${url}posts/$postId/comments'),
        headers: _headers,
        body: json.encode({'body': body}),
      );

      print('Create comment response: ${response.body}');

      if (response.statusCode == 200) {
        await getComments(postId);
      } else if (response.statusCode == 401) {
        error.value = 'Unauthorized access. Please login again.';
        Get.offAllNamed('/login');
      }
    } catch (e) {
      error.value = 'Error creating comment: $e';
      print(error.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> likeAndUnlike(int? postId) async {
    if (postId == null) return;

    try {
      error.value = '';
      final response = await http.post(
        Uri.parse('${url}posts/$postId/toggle-like'),
        headers: _headers,
      );

      print('Like/unlike response: ${response.body}');

      if (response.statusCode == 200) {
        await getAllPosts();
      } else if (response.statusCode == 401) {
        error.value = 'Unauthorized access. Please login again.';
        Get.offAllNamed('/login');
      }
    } catch (e) {
      error.value = 'Error toggling like: $e';
      print(error.value);
    }
  }

  Future<bool> deletePost(int? postId) async {
    if (postId == null) return false;

    try {
      isLoading.value = true;
      error.value = '';

      final response = await http.delete(
        Uri.parse('${url}posts/$postId'),
        headers: _headers,
      );

      print('Delete post response: ${response.body}');

      if (response.statusCode == 200) {
        await getAllPosts();
        Get.back(); // Go back to forum page
        Get.snackbar(
          'Success',
          'Post deleted successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else if (response.statusCode == 403) {
        error.value = 'You are not authorized to delete this post';
        Get.snackbar(
          'Error',
          error.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      } else if (response.statusCode == 401) {
        error.value = 'Unauthorized access. Please login again.';
        Get.offAllNamed('/login');
        return false;
      }
      return false;
    } catch (e) {
      error.value = 'Error deleting post: $e';
      print(error.value);
      Get.snackbar(
        'Error',
        'Failed to delete post',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
