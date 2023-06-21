import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:reddit/features/post/controller/post.controller.dart';

import '../../core/commen/error_text.dart';
import '../../core/commen/loader.dart';
import '../../core/commen/post_cart.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userCommunityProvider).when(
        data: (data) => ref.watch(userPostsProvider(data)).when(
            data: (data) {
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  final post = data[index];
                  return PostCart(
                    post: post,
                  );
                },
              );
            },
            error: (error, stackTrace) => ErrorText(
                  error: error.toString(),
                ),
            loading: () => Loader()),
        error: (error, stackTrace) => ErrorText(
              error: error.toString(),
            ),
        loading: () => Loader());
  }
}
