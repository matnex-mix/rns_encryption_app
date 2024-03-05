import 'package:encryption_demo2/pages/home/dashboard.dart';
import 'package:encryption_demo2/providers.dart';
import 'package:encryption_demo2/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';

import '../../src/rust/api/simple.dart';
import '../../widgets.dart';

class OTPValidationScreen extends ConsumerStatefulWidget {
  const OTPValidationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<OTPValidationScreen> createState() => _OTPValidationScreenState();
}

class _OTPValidationScreenState extends ConsumerState<OTPValidationScreen> {

  final otpValidationForm = GlobalKey<FormState>();

  var otp = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(loggedInUserProvider);

    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Validate OTP'),
            centerTitle: true,
          ),
          body: Form(
              key: otpValidationForm,
              child: ListView(
                padding: const EdgeInsets.all(30),
                children: [
                  Text(
                    'Please input the OTP sent to your email address ${user?.email ?? ''}',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Enter the OTP (include the | symbol)',
                    ),
                    controller: otp,
                    keyboardType: TextInputType.text,
                    validator: (value) => value?.isEmpty != true ? null : 'OTP is required',
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 40),
                  TextButton(
                    onPressed: () async {
                      if( otpValidationForm.currentState?.validate() != true ) return;

                      Widgets.load();

                      try {
                        final start = DateTime.now();

                        final modulos = ref.watch(selectedModulosProvider);
                        final remainders = otp.text.split("|").map((e) => int.tryParse(e) ?? 0).toList();
                        final computedOTP = Utils.crt(remainders, modulos);

                        providerContainer.read(validateDurationProvider.notifier).state = Utils.getSeconds(DateTime.now().difference(start).inMicroseconds);
                        print(computedOTP);

                        if( computedOTP == ref.watch(realOtpProvider) ){
                          Get.offAll(() => const DashboardScreen());
                          Get.snackbar("Success", "OTP validated!");
                        } else {
                          Get.snackbar("Error", "Incorrect OTP, please check and try again");
                        }
                      } catch (e) {
                        print(e);
                        Get.snackbar("Error", "Invalid OTP, please try again", duration: const Duration(seconds: 10));
                      }

                      if( Navigator.canPop(context) ) Navigator.pop(context);
                    },
                    child: Text(
                      'Confirm',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                      fixedSize: MaterialStateProperty.all(const Size(150, 50)),
                    ),
                  ),
                ],
              )
          ),
        )
    );
  }
}
