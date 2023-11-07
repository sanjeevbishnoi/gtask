import 'package:flutter/material.dart';
import 'package:gtask/constants/app_constants.dart';
import 'package:gtask/constants/color_constants.dart';
import 'package:gtask/pages/auth/log_out.dart';
import 'package:gtask/pages/splash_page.dart';
import 'package:gtask/pages/components/users_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  HomePageState({Key? key});

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppConstants.homeTitle,
          style: TextStyle(color: ColorConstants.primaryColor),
        ),
        centerTitle: true,
      ),
      body: const SafeArea(
        child: UsersList(),
      ),
      floatingActionButton: LogOut(
        onLogOut: () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const SplashPage()),
            (Route<dynamic> route) => false,
          );
        },
      ),
    );
  }
}
