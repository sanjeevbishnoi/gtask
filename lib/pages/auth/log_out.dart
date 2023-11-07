import 'package:flutter/material.dart';
import 'package:gtask/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LogOut extends StatelessWidget {
  final Function onLogOut;
  const LogOut({
    super.key,
    required this.onLogOut,
  });

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    return FloatingActionButton.small(
        child: const Icon(Icons.exit_to_app),
        onPressed: () async {
          await authProvider.signOut();
          onLogOut();
        });
  }
}
