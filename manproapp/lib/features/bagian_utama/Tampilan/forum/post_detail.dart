import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manpro/common/widgets/background_app.dart';
import 'package:manpro/features/bagian_utama/Controllers/post_controller.dart';
import 'package:manpro/features/bagian_utama/Models/post_Model.dart';
import 'package:manpro/features/bagian_utama/Tampilan/forum/post_field.dart';
import 'package:manpro/navbar.dart';
import 'package:manpro/utils/constants/image_string.dart';

class PostDetail extends StatefulWidget {
  const PostDetail({super.key, required this.post});

  final PostModel post;

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  final PostController _postController = Get.find<PostController>();
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _postController.getComments(widget.post.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: IconButton(
            onPressed: () {
              Get.to(() => const Navbar(), arguments: 0);
            },
            icon: const ImageIcon(
              AssetImage(YPKImages.icon_back_button),
              size: 32.0,
            ),
          ),
        ),
        title: Text(
          widget.post.user?.username ?? '',
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            fontSize: 20.0,
            color: Colors.black,
          ),
        ),
      ),
      body: Stack(
        children: [
          const BackgroundAPP(),
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.post.user?.username ?? '',
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16.0,
                                  ),
                                ),
                                Text(
                                  widget.post.user?.email ?? '',
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  widget.post.content ?? '',
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Comments',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            fontSize: 18.0,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Obx(
                          () => Column(
                            children: _postController.comments
                                .map(
                                  (comment) => Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            comment.user?.username ?? '',
                                            style: const TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            comment.body ?? '',
                                            style: const TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: PostField(
                        hintText: 'Write a comment...',
                        controller: _commentController,
                        obscureText: false,
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () async {
                        if (_commentController.text.isNotEmpty) {
                          await _postController.createComment(
                            widget.post.id,
                            _commentController.text,
                          );
                          _commentController.clear();
                        }
                      },
                      icon: const Icon(
                        Icons.send,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
