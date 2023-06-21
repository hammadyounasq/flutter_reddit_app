import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit/core/constants/firebase_constants.dart';
import 'package:reddit/core/provider/failure.dart';
import 'package:reddit/core/provider/type_defs.dart';
import 'package:reddit/models/post_model.dart';
import 'package:reddit/models/user_model.dart';

import '../../../core/provider/provider.dart';

final userProfileRepositoryProvider = Provider(((ref) =>
    UserProfileRepository(firebaseFirestore: ref.watch(firebasetore))));

class UserProfileRepository {
  final FirebaseFirestore _firebaseFirestore;

  UserProfileRepository({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  FutureVoid editUser(UserModel userModel) async {
    try {
      return right(_user.doc(userModel.uid).update(userModel.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Faiture(e.toString()));
    }
  }

  FutureVoid userKarma(UserModel user) async {
    try {
      return right(_user.doc(user.uid).update({'karma': user.karma}));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Faiture(e.toString()));
    }
  }

  Stream<List<Post>> getUserPost(String uid) {
    return _post.where('uid', isEqualTo: uid).snapshots().map((event) => event
        .docs
        .map((e) => Post.fromMap(e.data() as Map<String, dynamic>))
        .toList());
  }

  CollectionReference get _post =>
      _firebaseFirestore.collection(FirebaseConstants.postsCollection);
  CollectionReference get _user =>
      _firebaseFirestore.collection(FirebaseConstants.usersCollection);
}
