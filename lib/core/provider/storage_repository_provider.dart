import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fpdart/fpdart.dart';
import 'package:reddit/core/provider/failure.dart';
import 'package:reddit/core/provider/provider.dart';
import 'package:reddit/core/provider/type_defs.dart';

final storageRepositoriProvider = Provider(
    (ref) => StorageRepository(firebaseStorage: ref.watch(storageProvider)));

class StorageRepository {
  final FirebaseStorage _firebaseStorage;

  StorageRepository({required FirebaseStorage firebaseStorage})
      : _firebaseStorage = firebaseStorage;

  FutureEith<String> storageFile(
      {required path, required String id, required File? file}) async {
    try {
      final ref = _firebaseStorage.ref(path).child(id);
      UploadTask uploadTask = ref.putFile(file!);
      final snapshot = await uploadTask;
      return right(await snapshot.ref.getDownloadURL());
    } catch (e) {
      return left(Faiture(e.toString()));
    }
  }
}
