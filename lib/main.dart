import 'package:encryption_demo2/pages/splash.dart';
import 'package:encryption_demo2/providers.dart';
import 'package:encryption_demo2/services/base64_plus_key.dart';
import 'package:flutter/material.dart';
import 'package:encryption_demo2/src/rust/api/simple.dart';
import 'package:encryption_demo2/src/rust/frb_generated.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

Future<void> main() async {

  // print(dkey(["pc/TmW7", "t"]));
  // print(bkey(["wwwwww", "Thats my Kung Fu"]));

  await RustLib.init();
  runApp(UncontrolledProviderScope(
      container: providerContainer,
      child: GetMaterialApp(
        title: 'Encryption Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      )
  ));
}
