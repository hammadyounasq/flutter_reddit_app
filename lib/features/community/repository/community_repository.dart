import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fpdart/fpdart.dart';
import 'package:reddit/core/constants/firebase_constants.dart';
import 'package:reddit/core/provider/provider.dart';
import 'package:reddit/core/provider/type_defs.dart';
import 'package:reddit/models/community_model.dart';

import '../../../core/provider/failure.dart';
import '../../../models/post_model.dart';

final communityRepositoryProvider =
    Provider((ref) => CommunityRepository(firestore: ref.watch(firebasetore)));

class CommunityRepository {
  final FirebaseFirestore _firestore;
  CommunityRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  FutureVoid createCommunity(Community community) async {
    try {
      var communityDoc = await _communitise.doc(community.name).get();
      if (communityDoc.exists) {
        throw 'Community with the same name';
      }
      return right(_communitise.doc(community.name).set(community.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Faiture(
          e.toString(),
        ),
      );
    }
  }

  Stream<List<Community>> getUserCommunity(String uid) {
    return _communitise
        .where('members', arrayContains: uid)
        .snapshots()
        .map((event) {
      List<Community> comunitis = [];
      for (var doc in event.docs) {
        comunitis.add(Community.fromMap(doc.data() as Map<String, dynamic>));
      }
      return comunitis;
    });
  }

  FutureVoid joinCommunity(String name, String uid) async {
    try {
      return right(_communitise.doc(name).update({
        'members': FieldValue.arrayUnion([uid])
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Faiture(e.toString()));
    }
  }

  FutureVoid leaveCommunity(String name, String uid) async {
    try {
      return right(_communitise.doc(name).update({
        'members': FieldValue.arrayRemove([uid])
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Faiture(e.toString()));
    }
  }

  Stream<Community> getCommunityByName(String name) {
    return _communitise.doc(name).snapshots().map(
        (event) => Community.fromMap(event.data() as Map<String, dynamic>));
  }

  FutureVoid editCommunity(Community community) async {
    try {
      return right(_communitise.doc(community.name).update(community.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Faiture(e.toString()));
    }
  }

  Stream<List<Community>> searchDelegate(String query) {
    return _communitise
        .where(
          'name',
          isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
          isLessThan: query.substring(0, query.length - 1) +
              String.fromCharCode(query.codeUnitAt(query.length - 1) + 1),
        )
        .snapshots()
        .map((event) {
      List<Community> communities = [];
      for (var doc in event.docs) {
        communities.add(Community.fromMap(doc.data() as Map<String, dynamic>));
      }
      return communities;
    });
  }

  FutureVoid addmods(String communityName, List<String> uid) async {
    try {
      return right(_communitise.doc(communityName).update({'mods': uid}));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Faiture(e.toString()));
    }
  }

  Stream<List<Post>> getCommunityPost(String name) {
    return _post.where('communityName', isEqualTo: name).snapshots().map(
        (event) => event.docs
            .map((e) => Post.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }

  CollectionReference get _post =>
      _firestore.collection(FirebaseConstants.postsCollection);
  CollectionReference get _communitise =>
      _firestore.collection(FirebaseConstants.communitiesCollection);
}
