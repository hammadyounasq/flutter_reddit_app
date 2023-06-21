import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/enums/enums.dart';
import 'package:reddit/core/provider/storage_repository_provider.dart';
import 'package:reddit/core/provider/utils.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/features/post/repository/post_repository.dart';
import 'package:reddit/features/user_profile/controller/user_profile_controller.dart';
import 'package:reddit/models/post_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

import '../../../models/comment_model.dart';
import '../../../models/community_model.dart';

final postController = StateNotifierProvider<PostController, bool>((ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoriProvider);
  return PostController(
      postRepository: postRepository,
      storageRepository: storageRepository,
      ref: ref);
});
final userPostsProvider =
    StreamProvider.family((ref, List<Community> communities) {
  final postControlle = ref.watch(postController.notifier);

  return postControlle.fetchUserPost(communities);
});

final getPostById = StreamProvider.family((ref, String postId) {
  final postBuyId = ref.watch(postController.notifier);
  return postBuyId.getPostId(postId);
});
final getcomment = StreamProvider.family((ref, String postId) {
  final postcoment = ref.watch(postController.notifier);
  return postcoment.fectchcomment(postId);
});

class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  PostController(
      {required PostRepository postRepository,
      required Ref ref,
      required StorageRepository storageRepository})
      : _postRepository = postRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void shareTextpost(
      {required BuildContext context,
      required String title,
      required String description,
      required Community selectedCommunity}) async {
    state = true;
    String postId = Uuid().v1();
    final user = _ref.watch(userProvider)!;
    Post post = Post(
        id: postId,
        title: title,
        communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.banner,
        upvotes: [],
        downvotes: [],
        commentCount: 0,
        username: user.name,
        uid: user.uid,
        type: 'text',
        createdAt: DateTime.now(),
        awards: [],
        description: description);
    final res = await _postRepository.addPost(post);
    _ref
        .read(userProfileControllerProvider.notifier)
        .userKarma(UserKarma.textpost);
    state = false;
    res.fold((l) => showSnackBar(context, l.massage), (r) {
      showSnackBar(context, 'post successfull');
      Routemaster.of(context).pop();
    });
  }

  void sharelinkpost({
    required BuildContext context,
    required String title,
    required String link,
    required Community selectedCommunity,
  }) async {
    state = true;
    String postId = Uuid().v1();
    final user = _ref.watch(userProvider)!;

    Post post = Post(
        id: postId,
        title: title,
        communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.banner,
        upvotes: [],
        downvotes: [],
        commentCount: 0,
        username: user.name,
        uid: user.uid,
        type: 'link',
        createdAt: DateTime.now(),
        awards: [],
        link: link);
    final res = await _postRepository.addPost(post);
    _ref
        .read(userProfileControllerProvider.notifier)
        .userKarma(UserKarma.linkpost);
    state = false;
    res.fold((l) => showSnackBar(context, l.massage), (r) {
      showSnackBar(context, 'post successfull');
      Routemaster.of(context).pop();
    });
  }

  void shareImagePost(
      {required BuildContext context,
      required String title,
      required Community selectedCommunity,
      required File? file}) async {
    state = true;
    String postId = Uuid().v1();
    final user = _ref.read(userProvider)!;
    final imageRes = await _storageRepository.storageFile(
        path: 'posts/${selectedCommunity.name}', id: postId, file: file);

    imageRes.fold((l) => showSnackBar(context, l.massage), (r) async {
      final Post post = Post(
          id: postId,
          title: title,
          communityName: selectedCommunity.name,
          communityProfilePic: selectedCommunity.banner,
          upvotes: [],
          downvotes: [],
          commentCount: 0,
          username: user.name,
          uid: user.uid,
          type: 'image',
          createdAt: DateTime.now(),
          awards: [],
          link: r);
      final res = await _postRepository.addPost(post);
      _ref
          .read(userProfileControllerProvider.notifier)
          .userKarma(UserKarma.imagepost);
      state = false;
      res.fold((l) => showSnackBar(context, l.massage), (r) {
        showSnackBar(context, 'Posted Successfully! ');
        Routemaster.of(context).pop();
      });
    });
  }
  // void shareimagepost(
  //     {required BuildContext context,
  //     required String title,
  //     required Community selectedCommunity,
  //     required File? file}) async {
  //   state = true;
  //   String postId = Uuid().v1();
  //   final imageRes = await _storageRepository.storageFile(
  //       path: 'posts/${selectedCommunity.name}', id: postId, file: file);
  //   final user = _ref.watch(userProvider)!;

  //   imageRes.fold((l) => showSnackBar(context, l.massage), (r) async {
  //     Post post = Post(
  //         id: postId,
  //         title: title,
  //         communityName: selectedCommunity.name,
  //         communityProfilePic: selectedCommunity.banner,
  //         upvotes: [],
  //         downvotes: [],
  //         commentCount: 0,
  //         username: user.name,
  //         uid: user.uid,
  //         type: 'image',
  //         createdAt: DateTime.now(),
  //         awards: [],
  //         link: r);
  //     final res = await _postRepository.addPost(post);
  //     _ref
  //         .read(userProfileControllerProvider.notifier)
  //         .userKarma(UserKarma.imagepost);
  //     state = false;
  //     res.fold((l) => showSnackBar(context, l.massage), (r) {
  //       showSnackBar(context, 'post successfull');
  //       Routemaster.of(context).pop();
  //     });
  //   });
  // }

  void delete(Post post, BuildContext context) async {
    final res = await _postRepository.deletePost(post);
    _ref
        .read(userProfileControllerProvider.notifier)
        .userKarma(UserKarma.deletepost);
    res.fold(
        (l) => null, (r) => showSnackBar(context, 'Post Delete successfull'));
  }

  void add(BuildContext context, String text, Post post) async {
    String commentId = Uuid().v1();
    final user = _ref.read(userProvider)!;
    Comment comment = Comment(
        id: commentId,
        text: text,
        createdAt: DateTime.now(),
        postId: post.id,
        username: user.name,
        profilePic: user.profilePic);
    final res = await _postRepository.addcomment(comment);
    _ref
        .read(userProfileControllerProvider.notifier)
        .userKarma(UserKarma.comment);
    res.fold((l) => showSnackBar(context, l.massage), (r) => null);
  }

  void upvote(Post post) async {
    final user = _ref.read(userProvider)!.uid;
    _postRepository.upvote(post, user);
  }

  void downvote(Post post) async {
    final user = _ref.read(userProvider)!.uid;
    _postRepository.downvote(post, user);
  }

  // void awardPost(
  //     {required Post post,
  //     required BuildContext context,
  //     required String award}) async {
  //   final user = _ref.read(userProvider)!;
  //   final res = await _postRepository.awardPost(post, award, user.uid);
  //   res.fold((l) => showSnackBar(context, l.massage), (r) {
  //     _ref
  //         .read(userProfileControllerProvider.notifier)
  //         .userKarma(UserKarma.awardspost);
  //     _ref.read(userProvider.notifier).update((state) {
  //       state?.awards?.remove(award);
  //       return state;
  //     });
  //     Routemaster.of(context).pop();
  //   });
  // }

  void awardPost(
      {required Post post,
      required String award,
      required BuildContext context}) async {
    final user = _ref.read(userProvider)!;

    final res = await _postRepository.awardPost(post, award, user.uid);
    res.fold((l) => showSnackBar(context, l.massage), (r) {
      _ref
          .read(userProfileControllerProvider.notifier)
          .userKarma(UserKarma.awardspost);
      _ref.read(userProvider.notifier).update((state) {
        state?.awards?.remove(award);
      });
      Routemaster.of(context).pop();
    });
  }

  Stream<Post> getPostId(String postId) {
    return _postRepository.getPostId(postId);
  }

  Stream<List<Post>> fetchUserPost(List<Community> communities) {
    if (communities.isNotEmpty) {
      return _postRepository.fetchUserPost(communities);
    }
    return Stream.value([]);
  }

  Stream<List<Comment>> fectchcomment(String postId) {
    return _postRepository.fectchcomment(postId);
  }
}
