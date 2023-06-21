import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/enums/enums.dart';
import 'package:reddit/core/provider/storage_repository_provider.dart';
import 'package:reddit/core/provider/utils.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/features/user_profile/repository/user_profile_repository.dart';
import 'package:reddit/models/user_model.dart';
import 'package:routemaster/routemaster.dart';

import '../../../models/post_model.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  final userRepository = ref.watch(userProfileRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoriProvider);
  return UserProfileController(
      userProfileRepository: userRepository,
      ref: ref,
      storageRepository: storageRepository);
});

final getUserPost = StreamProvider.family((ref, String uid) {
  final userPost = ref.watch(userProfileControllerProvider.notifier);
  return userPost.getUserPost(uid);
});

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _userProfileRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  UserProfileController(
      {required UserProfileRepository userProfileRepository,
      required Ref ref,
      required StorageRepository storageRepository})
      : _userProfileRepository = userProfileRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void editUser(
      {required File? profile,
      required File? bannerFile,
      required String name,
      required BuildContext context}) async {
    UserModel user = _ref.read(userProvider)!;
    if (profile != null) {
      final res = await _storageRepository.storageFile(
          path: 'users/profile', id: user.uid, file: profile);
      res.fold((l) => showSnackBar(context, l.massage),
          (r) => user = user.copyWith(profilePic: r));
    }
    if (bannerFile != null) {
      final res = await _storageRepository.storageFile(
          path: 'users/banner', id: user.uid, file: bannerFile);

      res.fold((l) => showSnackBar(context, l.massage),
          (r) => user = user.copyWith(banner: r));
    }
    user = user.copyWith(name: name);
    final res = await _userProfileRepository.editUser(user);
    res.fold((l) => showSnackBar(context, l.massage), (r) {
      _ref.read(userProvider.notifier).update((state) => user);
      Routemaster.of(context).pop();
    });
  }

  void userKarma(UserKarma karma) async {
    UserModel user = _ref.read(userProvider)!;
    user = user.copyWith(karma: user.karma + karma.karma);
    final res = await _userProfileRepository.userKarma(user);
    res.fold((l) => null,
        (r) => _ref.read(userProvider.notifier).update((state) => user));
  }

  Stream<List<Post>> getUserPost(String uid) {
    return _userProfileRepository.getUserPost(uid);
  }
}
