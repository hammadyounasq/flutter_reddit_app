import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/provider/failure.dart';
import 'package:reddit/core/provider/storage_repository_provider.dart';

import 'package:reddit/core/provider/utils.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/features/community/repository/community_repository.dart';
import 'package:reddit/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

import '../../../models/post_model.dart';

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  final storageRepository = ref.watch(storageRepositoriProvider);
  final communityRepository = ref.watch(communityRepositoryProvider);
  return CommunityController(
      communityRepository: communityRepository,
      ref: ref,
      storageRepository: storageRepository);
});

final userCommunityProvider = StreamProvider(((ref) {
  final communitycomm = ref.watch(communityControllerProvider.notifier);
  return communitycomm.getUserCommunity();
}));
final searchCommunitydelegates = StreamProvider.family((ref, String query) {
  final searchcommunity = ref.watch(communityControllerProvider.notifier);
  return searchcommunity.searchDelegate(query);
});

final getCommunityByNameProvide = StreamProvider.family((ref, String name) {
  final communityName = ref.watch(communityControllerProvider.notifier);
  return communityName.getCommunityByName(name);
});

final getCommuniyPost = StreamProvider.family((ref, String name) {
  final communityPost = ref.watch(communityControllerProvider.notifier);
  return communityPost.getCommunityPost(name);
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  CommunityController(
      {required CommunityRepository communityRepository,
      required Ref ref,
      required StorageRepository storageRepository})
      : _communityRepository = communityRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void createCommunity(String name, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';
    Community community = Community(
      id: name,
      name: name,
      banner: Constants.bannerDefault,
      avatar: Constants.bannerDefault,
      members: [uid],
      mods: [uid],
    );
    final res = await _communityRepository.createCommunity(community);
    state = false;
    res.fold((l) => showSnackBar(context, l.massage), (r) {
      showSnackBar(context, 'Community created successfully!');
      Routemaster.of(context).pop();
    });
  }

  void joineCommunity(Community communityName, BuildContext context) async {
    final user = _ref.read(userProvider)!;
    Either<Faiture, void> res;
    if (communityName.members.contains(user.uid)) {
      res = await _communityRepository.leaveCommunity(
          communityName.name, user.uid);
    } else {
      res = await _communityRepository.joinCommunity(
          communityName.name, user.uid);
    }
    res.fold((l) => showSnackBar(context, l.massage), (r) {
      if (communityName.members.contains(user.uid)) {
        showSnackBar(context, 'community leave ');
      } else {
        showSnackBar(context, 'community join ');
      }
    });
  }

  void addmod(
      String communityName, List<String> uid, BuildContext context) async {
    final res = await _communityRepository.addmods(communityName, uid);
    return res.fold((l) => showSnackBar(context, l.massage),
        (r) => Routemaster.of(context).pop());
  }

  void editCommunity(
      {required Community community,
      required File? profileFile,
      required File? bannerFile,
      required BuildContext context}) async {
    state = true;
    if (profileFile != null) {
      final res = await _storageRepository.storageFile(
          path: 'communities/profile', id: community.id, file: profileFile);
      res.fold((l) => showSnackBar(context, l.massage),
          (r) => community = community.copyWith(avatar: r));
    }

    if (bannerFile != null) {
      final res = await _storageRepository.storageFile(
          path: 'communities/banner', id: community.id, file: bannerFile);
      res.fold((l) => showSnackBar(context, l.massage),
          (r) => community = community.copyWith(banner: r));
    }
    final res = await _communityRepository.editCommunity(community);
    state = false;
    res.fold((l) => showSnackBar(context, l.massage),
        (r) => Routemaster.of(context).pop());
  }

  Stream<Community> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }

  Stream<List<Community>> searchDelegate(String query) {
    return _communityRepository.searchDelegate(query);
  }

  Stream<List<Community>> getUserCommunity() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getUserCommunity(uid);
  }

  Stream<List<Post>> getCommunityPost(String name) {
    return _communityRepository.getCommunityPost(name);
  }
}
