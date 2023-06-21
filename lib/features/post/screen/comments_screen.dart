import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/features/post/controller/post.controller.dart';

import '../../../core/commen/error_text.dart';
import '../../../core/commen/loader.dart';
import '../../../core/commen/post_cart.dart';
import '../../../models/post_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../widgets/comment_cart.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final String postId;
  CommentsScreen({required this.postId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final commentController = TextEditingController();
  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  void addcomment(Post post) {
    ref
        .watch(postController.notifier)
        .add(context, commentController.text.trim(), post);
    setState(() {
      commentController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuset = !user.isAuthenticated;
    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(getPostById(widget.postId)).when(
          data: (data) {
            return Column(
              children: [
                PostCart(post: data),
                if (!isGuset)
                  TextField(
                    onSubmitted: (value) => addcomment(data),
                    controller: commentController,
                    decoration: InputDecoration(
                        hintText: 'What are your thoughts',
                        filled: true,
                        border: InputBorder.none),
                  ),
                ref.watch(getcomment(widget.postId)).when(
                    data: (data) {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final comment = data[index];
                              return CommentCart(comment: comment);
                            }),
                      );
                    },
                    error: (error, staskTrace) =>
                        ErrorText(error: error.toString()),
                    loading: () => Loader())
                // ref.watch(getcomment(widget.postId)).when(
                //     data: (data) {
                //       return Expanded(
                //         child: ListView.builder(
                //             itemCount: data.length,
                //             itemBuilder: (context, index) {
                //               final comment = data[index];
                //               return CommentCart(comment: comment);
                //             }),
                //       );
                //     },
                //     error: (error, staskTrace) {
                //       print('hi');
                //       return ErrorText(error: error.toString());
                //     },
                //     loading: () => Loader())
              ],
            );
          },
          error: (error, staskTrace) => ErrorText(error: error.toString()),
          loading: () => Loader()),
    );
  }
}
