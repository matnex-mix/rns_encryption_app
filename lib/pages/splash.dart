import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auth/login.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), (){
      Get.to(() => const LoginScreen());
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          height: 100,
          width: 100,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Image.asset('assets/images/icon.jpg'),
          ),
        ),
      ),
    );
  }
}
