import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Widgets {

  static load({
      bool dismissible = false,
  }){
    Get.dialog(
      PopScope(
        canPop: dismissible,
        child: Center(
          child: SizedBox(
            height: 30,
            width: 30,
            child: CircularProgressIndicator(
              color: Colors.blue,
              strokeWidth: 2,
            ),
          )
        ),
      ),
      barrierColor: Colors.white.withOpacity(0.6),
    );
  }

}