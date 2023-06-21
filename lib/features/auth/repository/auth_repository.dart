import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/constants/firebase_constants.dart';
import 'package:reddit/core/provider/failure.dart';
import 'package:reddit/core/provider/provider.dart';
import 'package:reddit/core/provider/type_defs.dart';
import 'package:reddit/models/user_model.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    firestore: ref.read(firebasetore),
    googleSignIn: ref.read(googleSignInProvider),
    auth: ref.read(authProvider)));

class AuthRepository {
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _auth;
  AuthRepository(
      {required FirebaseFirestore firestore,
      required GoogleSignIn googleSignIn,
      required FirebaseAuth auth})
      : _firestore = firestore,
        _googleSignIn = googleSignIn,
        _auth = auth;

  CollectionReference get _user =>
      _firestore.collection(FirebaseConstants.usersCollection);

  Stream<User?> get authStateChange => _auth.authStateChanges();

  FutureEith<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      late UserModel userModel;

      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
            name: userCredential.user!.displayName ?? 'No name',
            profilePic:
                userCredential.user!.photoURL ?? Constants.avatarDefault,
            banner: Constants.bannerDefault,
            uid: userCredential.user!.uid,
            isAuthenticated: true,
            karma: 0,
            awards: [
              'awesomeAns',
              'gold',
              'platinum',
              'helpful',
              'plusone',
              'rocket',
              'thankyou',
              'til',
            ]);

        await _user.doc(userCredential.user!.uid).set(userModel.toMap());
      } else {
        userModel = await getuserdata(userCredential.user!.uid).first;
      }
      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Faiture(e.toString()));
    }
  }

  FutureEith<UserModel> signInWithGuest() async {
    try {
      var userCredential = await _auth.signInAnonymously();

      UserModel userModel;

      userModel = UserModel(
          name: 'Guest',
          profilePic: Constants.avatarDefault,
          banner: Constants.bannerDefault,
          uid: userCredential.user!.uid,
          isAuthenticated: true,
          karma: 0,
          awards: []);

      await _user.doc(userCredential.user!.uid).set(userModel.toMap());

      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Faiture(e.toString()));
    }
  }

  Stream<UserModel> getuserdata(String uid) {
    return _user.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  void logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:fpdart/fpdart.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:reddit/core/constants/constants.dart';
// import 'package:reddit/core/constants/firebase_constants.dart';
// import 'package:reddit/core/provider/provider.dart';
// import 'package:reddit/core/provider/type_defs.dart';

// import 'package:reddit/models/user_model.dart';

// import '../../../core/provider/failure.dart';

// final authRepositoryProvider = Provider((ref) => AuthRepository(
//     firestore: ref.read(firebasetore),
//     auth: ref.read(authProvider),
//     googleSignIn: ref.read(googleSignInProvider)));

// class AuthRepository {
//   final FirebaseFirestore _firestore;
//   final FirebaseAuth _auth;
//   final GoogleSignIn _googleSignIn;

//   CollectionReference get _user =>
//       _firestore.collection(FirebaseConstants.usersCollection);

//   Stream<User?> get authStateChange => _auth.authStateChanges();

//   AuthRepository(
//       {required FirebaseFirestore firestore,
//       required FirebaseAuth auth,
//       required GoogleSignIn googleSignIn})
//       : _firestore = firestore,
//         _auth = auth,
//         _googleSignIn = googleSignIn;

//   FutureEith<UserModel> signInWithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       final googleAuth = await googleUser?.authentication;

//       final credential = GoogleAuthProvider.credential(
//           accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
//       final UserCredential userCredential =
//           await _auth.signInWithCredential(credential);

//       late UserModel userModel;
//       if (userCredential.additionalUserInfo!.isNewUser) {
//         userModel = UserModel(
//             name: userCredential.user?.displayName ?? 'No Name',
//             profilePic:
//                 userCredential.user?.photoURL ?? Constants.avatarDefault,
//             banner: Constants.bannerDefault,
//             uid: userCredential.user!.uid,
//             isAuthenticated: true,
//             karma: 0,
//             awards: []);
//         final res =
//             await _user.doc(userCredential.user!.uid).set(userModel.toMap());
//       } else {
//         final userModel = await getuserdata(userCredential.user!.uid).first;
//       }
//       return right(userModel);
//     } on FirebaseException catch (e) {
//       throw e.message!;
//     } catch (e) {
//       return left(Faiture(e.toString()));
//     }
//   }

//   Stream<UserModel> getuserdata(String uid) {
//     return _user.doc(uid).snapshots().map(
//         (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
//   }
// }
