import 'dart:async';
import 'package:encryption_demo2/pages/splash.dart';
import 'package:encryption_demo2/providers.dart';
import 'package:encryption_demo2/src/rust/frb_generated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'flavors.dart';

FutureOr<void> main() async {
  await RustLib.init();
  runApp(UncontrolledProviderScope(
      container: providerContainer,
      child: GetMaterialApp(
        title: F.title,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: F.primaryColor),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      )
  ));
}