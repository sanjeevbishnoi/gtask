import 'package:flutter/material.dart';
import 'package:gtask/constants/color_constants.dart';
import 'package:gtask/models/user_model.dart';
import 'package:gtask/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SingleUser extends StatelessWidget {
  const SingleUser({
    super.key,
    required this.userModel,
  });

  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    return Card(
      color: ColorConstants.bgColor,
      child: Row(
        children: <Widget>[
          userModel.photoUrl.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(25.0),
                      child: Image.network(
                        userModel.photoUrl,
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return SizedBox(
                            width: 50,
                            height: 50,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: ColorConstants.primaryColor,
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, object, stackTrace) {
                          return const Icon(
                            Icons.account_circle,
                            size: 50,
                            color: ColorConstants.textColor,
                          );
                        },
                      )),
                )
              : const Icon(
                  Icons.account_circle,
                  size: 50,
                  color: ColorConstants.textColor,
                ),
          Flexible(
            child: Container(
              margin: const EdgeInsets.only(left: 20),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                    child: Text(
                      authProvider.currentUserId == userModel.id
                          ? '${userModel.nickname}(You)'
                          : userModel.nickname,
                      maxLines: 1,
                      style: const TextStyle(
                        color: ColorConstants.primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
