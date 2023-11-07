import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gtask/constants/firestore_constants.dart';
import 'package:gtask/models/user_model.dart';
import 'package:gtask/pages/components/single_user.dart';
import 'package:gtask/providers/home_provider.dart';
import 'package:provider/provider.dart';

class UsersList extends StatelessWidget {
  const UsersList({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    HomeProvider homeProvider =
        Provider.of<HomeProvider>(context, listen: true);
    return StreamBuilder<QuerySnapshot>(
      stream:
          homeProvider.getUsersStream(FirestoreConstants.pathUserCollection),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          if ((snapshot.data?.docs.length ?? 0) > 0) {
            return ListView.separated(
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                QueryDocumentSnapshot<Object?>? document =
                    snapshot.data?.docs[index];
                if (document != null) {
                  UserModel userModel = UserModel.fromDocument(document);
                  return SingleUser(userModel: userModel);
                } else {
                  return const SizedBox.shrink();
                }
              },
              itemCount: snapshot.data?.docs.length ?? 0,
              separatorBuilder: (context, index) => const Divider(),
            );
          } else {
            return const Center(
              child: Text("No users"),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
