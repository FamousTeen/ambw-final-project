import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:manpro/features/bagian_utama/Models/post_Model.dart';
import 'package:manpro/features/bagian_utama/Tampilan/forum/post_detail.dart';
import 'package:manpro/features/bagian_utama/Controllers/post_controller.dart';

class PostData extends StatefulWidget {
  const PostData({super.key, required this.post});

  final PostModel post;

  @override
  State<PostData> createState() => _PostDataState();
}

class _PostDataState extends State<PostData> {
  final PostController _postController = Get.find<PostController>();
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    final userData = box.read('user');
    final currentUserId = userData != null ? userData['id'] : null;
    final isPostOwner =
        currentUserId != null && widget.post.user?.id == currentUserId;

    // Debug prints
    print('Current User Data: $userData');
    print('Current User ID: $currentUserId');
    print('Post User ID: ${widget.post.user?.id}');
    print('Post Username: ${widget.post.user?.username}');
    print('Is Post Owner: $isPostOwner');

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
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
                  ],
                ),
                if (isPostOwner)
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.red,
                      size: 24,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text(
                            'Delete Post',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          content: const Text(
                            'Are you sure you want to delete this post?',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                await _postController
                                    .deletePost(widget.post.id);
                              },
                              child: const Text(
                                'Delete',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Colors.red,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
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
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () async {
                    await _postController.likeAndUnlike(widget.post.id);
                    _postController.getAllPosts();
                  },
                  icon: Icon(
                    Icons.favorite,
                    color: widget.post.liked == true ? Colors.red : Colors.grey,
                    size: 28,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Get.to(() => PostDetail(post: widget.post));
                  },
                  icon: const Icon(
                    Icons.comment,
                    size: 28,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
