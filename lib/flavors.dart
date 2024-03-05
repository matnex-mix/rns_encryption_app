import 'package:flutter/material.dart';

enum Flavor {
  kola,
  abo,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.kola:
        return 'Encryption Demo';
      case Flavor.abo:
        return 'Secure OTP';
      default:
        return 'title';
    }
  }

  static String get icon {
    switch (appFlavor) {
      case Flavor.kola:
        return 'assets/kola/images/icon.jpg';
      case Flavor.abo:
        return 'assets/abo/images/icon.png';
      default:
        return '';
    }
  }

  static String get description {
    switch (appFlavor) {
      case Flavor.kola:
        return 'Encryption to your standard using RNS Base64';
      case Flavor.abo:
        return 'Implementation of Secure OTP';
      default:
        return 'description';
    }
  }

  static Color get primaryColor {
    switch (appFlavor) {
      case Flavor.kola:
        return Colors.deepPurple;
      case Flavor.abo:
        return Colors.blueAccent;
      default:
        return Colors.pink;
    }
  }

}
