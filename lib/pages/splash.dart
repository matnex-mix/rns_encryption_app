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

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 150,
                width: 150,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Image.asset('assets/images/icon.jpg'),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Encryption to your standard using RNS Base64',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
