// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import 'package:gtask/constants/firestore_constants.dart';
import 'package:gtask/models/failure.dart';
import 'package:gtask/models/status.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage storage;
  final SharedPreferences prefs;
  Status _status = Status.uninitialized;

  AuthProvider({
    required this.prefs,
    required this.firebaseAuth,
    required this.firebaseFirestore,
    required this.storage,
  });

  Status get status => _status;

  String? get currentUserId {
    return currentUser!.uid;
  }

  User? get currentUser {
    return FirebaseAuth.instance.currentUser!;
  }

  bool isLoggedIn() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null &&
        prefs.getString(FirestoreConstants.id)?.isNotEmpty == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> signIn({required email, required password}) async {
    _status = Status.authenticating;
    notifyListeners();
    try {
      User? firebaseUser = (await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;

      if (firebaseUser != null) {
        await updatePerferences(firebaseUser);
        _status = Status.authenticated;
        notifyListeners();
      } else {
        _status = Status.authenticateException;
        notifyListeners();
      }
    } on FirebaseAuthException catch (e, s) {
      _status = Status.authenticateException;
      notifyListeners();
      throw Failure(message: e.code, stackTrace: s);
    } catch (e, _) {
      _status = Status.authenticateException;
      notifyListeners();
      throw Failure(
          message: e.toString(),
          stackTrace: StackTrace.fromString(e.toString()));
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    Uint8List? file,
  }) async {
    _status = Status.authenticating;
    notifyListeners();
    try {
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        await user.updateDisplayName(name);
        if (file != null) {
          await user.updatePhotoURL(await uploadImageToStorage(
              FirestoreConstants.pathPhotoCollection, file));
        }

        user = currentUser;
        if (user != null) {
          await saveUserInfo(user);
          await updatePerferences(user);
        }
        _status = Status.authenticated;
        notifyListeners();
      }
    } on FirebaseAuthException catch (e, s) {
      _status = Status.authenticateException;
      notifyListeners();
      throw Failure(message: e.message!, stackTrace: s);
    } catch (e, _) {
      _status = Status.authenticateException;
      notifyListeners();
      throw Failure(
          message: e.toString(),
          stackTrace: StackTrace.fromString(e.toString()));
    }
  }

  Future<bool> saveUserInfo(User firebaseUser) async {
    await firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .doc(firebaseUser.uid)
        .set({
      FirestoreConstants.nickname: firebaseUser.displayName ?? "",
      FirestoreConstants.photoUrl: firebaseUser.photoURL ?? "",
      FirestoreConstants.id: firebaseUser.uid,
      FirestoreConstants.createdAt:
          DateTime.now().millisecondsSinceEpoch.toString(),
    });
    return true;
  }

  Future<bool> updatePerferences(User currentUser) async {
    await prefs.setString(FirestoreConstants.id, currentUser.uid);
    await prefs.setString(
        FirestoreConstants.nickname, currentUser.displayName ?? "");
    await prefs.setString(
        FirestoreConstants.photoUrl, currentUser.photoURL ?? "");
    return true;
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
    await prefs.clear();
    _status = Status.uninitialized;
    notifyListeners();
  }

  Future<String> uploadImageToStorage(
    String childName,
    Uint8List file,
  ) async {
    // creating location to our firebase storage
    Reference ref =
        storage.ref().child(childName).child(firebaseAuth.currentUser!.uid);
    // putting in uint8list format -> Upload task like a future but not future
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
