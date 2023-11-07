import 'package:flutter/material.dart';
import 'package:gtask/constants/color_constants.dart';
import 'package:gtask/pages/home_page.dart';
import 'package:gtask/pages/auth/login_page.dart';
import 'package:gtask/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SizedBox(
        width: 20,
        height: 20,
        child: Consumer<AuthProvider>(builder: (context, authModel, child) {
          bool isLoggedIn = authModel.isLoggedIn();
          WidgetsBinding.instance
              .addPostFrameCallback((_) => navigate(context, isLoggedIn));
          return const CircularProgressIndicator(
              color: ColorConstants.primaryColor);
        }),
      )),
    );
  }

  void navigate(BuildContext context, bool isLoggedIn) async {
    if (!context.mounted) return;
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }
}
