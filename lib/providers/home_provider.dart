import 'package:cloud_firestore/cloud_firestore.dart';

class HomeProvider {
  final FirebaseFirestore firebaseFirestore;

  HomeProvider({required this.firebaseFirestore});

  Stream<QuerySnapshot> getUsersStream(String pathCollection) {
    return firebaseFirestore.collection(pathCollection).snapshots();
  }
}
