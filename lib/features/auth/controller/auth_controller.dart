import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/provider/utils.dart';
import 'package:reddit/features/auth/repository/auth_repository.dart';
import 'package:reddit/models/user_model.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
    (ref) => AuthController(
        authRepository: ref.watch(authRepositoryProvider), ref: ref));

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});
final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getuserdata(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithGoogle();
    state = false;
    user.fold(
        (l) => showSnackBar(context, l.massage),
        (userModel) =>
            _ref.read(userProvider.notifier).update((state) => userModel));
  }

  // void signInWithGuest(BuildContext context) async {
  //   state = true;
  //   final res = await _authRepository.signInWithGuest();
  //   state = false;
  //   res.fold(
  //       (l) => showSnackBar(context, l.massage),
  //       (usermodel) =>
  //           _ref.read(userProvider.notifier).update((state) => usermodel));
  // }

  void signInAsGuest(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithGuest();
    state = false;
    user.fold(
      (l) => showSnackBar(context, l.massage),
      (userModel) =>
          _ref.read(userProvider.notifier).update((state) => userModel),
    );
  }

  void logout() {
    _authRepository.logout();
  }

  Stream<UserModel> getuserdata(String uid) {
    return _authRepository.getuserdata(uid);
  }
}

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:reddit/core/provider/utils.dart';
// import 'package:reddit/features/auth/repository/auth_repository.dart';
// import 'package:reddit/models/user_model.dart';

// final userProvider = StateProvider<UserModel?>((ref) => null);

// final authController = StateNotifierProvider<AuthController, bool>((ref) =>
//     AuthController(authRepository: ref.read(authRepositoryProvider), ref: ref));

// final uuu = StreamProvider.family((ref, String uid) {
//   final authc = ref.watch(authController.notifier);
//   return authc.getuserdata(uid);
// });

// class AuthController extends StateNotifier<bool> {
//   final AuthRepository _authRepository;
//   final Ref _ref;
//   AuthController({required AuthRepository authRepository, required Ref ref})
//       : _authRepository = authRepository,
//         _ref = ref,
//         super(false);
//   Stream<User?> get authStateChange => _authRepository.authStateChange;
//   void signInWithGoogle(WidgetRef ref, BuildContext context) async {
//     state = true;
//     final user = await _authRepository.signInWithGoogle();
//     state = false;
//     user.fold(
//         (l) => showSnackBar(context, l.massage),
//         (usermodel) =>
//             ref.read(userProvider.notifier).update((state) => usermodel));
//   }

//   Stream<UserModel> getuserdata(String uid) {
//     return _authRepository.getuserdata(uid);
//   }
// }
