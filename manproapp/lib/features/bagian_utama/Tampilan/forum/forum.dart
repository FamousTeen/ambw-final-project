import 'package:flutter/material.dart';
import 'package:manpro/common/widgets/background_app.dart';
import 'package:manpro/navbar.dart';
import 'package:manpro/utils/constants/image_string.dart';
import 'package:get/get.dart';
import 'package:manpro/features/bagian_utama/Tampilan/forum/post_field.dart';
import 'package:manpro/features/bagian_utama/Tampilan/forum/post_data.dart';
import 'package:manpro/features/bagian_utama/Controllers/post_controller.dart';

class Forum extends StatefulWidget {
  const Forum({super.key});

  @override
  State<Forum> createState() => _ForumState();
}

class _ForumState extends State<Forum> {
  final PostController _postController = Get.put(PostController());
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundAPP(),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () =>
                          Get.offAll(() => const Navbar(), arguments: 0),
                      icon: const ImageIcon(
                        AssetImage(YPKImages.icon_back_button),
                        size: 32.0,
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    const Text(
                      'Forum Chat',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        fontSize: 24.0,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Selamat datang di forum kami! Silahkan berbagi pendapat Anda.',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 20),
                    PostField(
                      hintText: 'Tulis pesan Anda...',
                      controller: _textController,
                      obscureText: false,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.withOpacity(0.5),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () async {
                        if (_textController.text.isNotEmpty) {
                          await _postController.createPost(
                            content: _textController.text.trim(),
                          );
                          _textController.clear();
                        }
                      },
                      child: Obx(() {
                        return _postController.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black),
                                ),
                              )
                            : const Text(
                                'Post',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.0,
                                ),
                              );
                      }),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Forum Terbaru',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Obx(() {
                      return _postController.isLoading.value
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _postController.posts.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: PostData(
                                    post: _postController.posts[index],
                                  ),
                                );
                              },
                            );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
