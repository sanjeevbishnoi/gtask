import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gtask/constants/firestore_constants.dart';

class UserModel {
  final String id;
  final String photoUrl;
  final String nickname;

  const UserModel({
    required this.id,
    required this.photoUrl,
    required this.nickname,
  });

  Map<String, String> toMap() {
    return {
      FirestoreConstants.nickname: nickname,
      FirestoreConstants.photoUrl: photoUrl,
    };
  }

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    String photoUrl = "";
    String nickname = "";

    try {
      photoUrl = doc.get(FirestoreConstants.photoUrl);
    } catch (_) {}
    try {
      nickname = doc.get(FirestoreConstants.nickname);
    } catch (_) {}
    return UserModel(
      id: doc.id,
      photoUrl: photoUrl,
      nickname: nickname,
    );
  }
}
