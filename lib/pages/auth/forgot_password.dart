import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../models/user.dart';
import '../../services/db.dart';
import '../../utilities.dart';
import '../../widgets.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  final User user;

  const ForgotPasswordScreen({Key? key, required this.user}) : super(key: key);

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {

  final forgotPasswordForm = GlobalKey<FormState>();

  var answer = TextEditingController();
  var password = TextEditingController();
  var password2 = TextEditingController();

  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Forgot Password'),
          centerTitle: true,
        ),
        body: Form(
          key: forgotPasswordForm,
          child: ListView(
            padding: const EdgeInsets.all(30),
            children: [
              Text(
                'Security Question: ${widget.user.question ?? ''}',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Answer to Security Question',
                ),
                controller: answer,
                keyboardType: TextInputType.text,
                validator: (value) => value?.isEmpty != true ? null : 'Security answer is required',
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon( showPassword ? CupertinoIcons.eye_slash : CupertinoIcons.eye),
                      onPressed: () => setState(() => showPassword = !showPassword),
                    )
                ),
                controller: password,
                keyboardType: TextInputType.visiblePassword,
                obscureText: !showPassword,
                validator: (value) => value?.isEmpty != true ? (GetUtils.isLengthBetween(value!, 6, 20) ? null : 'Invalid password') : 'Password is required',
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                    hintText: 'Password Confirmation',
                    suffixIcon: IconButton(
                      icon: Icon( showPassword ? CupertinoIcons.eye_slash : CupertinoIcons.eye),
                      onPressed: () => setState(() => showPassword = !showPassword),
                    )
                ),
                controller: password2,
                keyboardType: TextInputType.visiblePassword,
                obscureText: !showPassword,
                validator: (value) => value?.isEmpty != true ? (value != password.text ? 'Passwords do not match' : null) : 'Password is required',
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 40),
              TextButton(
                onPressed: () async {
                  if( forgotPasswordForm.currentState?.validate() != true ) return;

                  Widgets.load();

                  try {
                    if( widget.user.answer == answer.text ){
                      widget.user.password = Utils.hashPassword(password.text);

                      final isar = await DB.isar();
                      final userId = isar.writeTxnSync((){
                        return isar.users.putSync(widget.user);
                      });

                      Get.back();
                      Get.snackbar("Success", "Password changed successfully");
                    } else {
                      Get.snackbar("Error", "Incorrect security answer");
                    }
                  } catch (e) {
                    // print(e);
                    Get.snackbar("Error", "Could not change password, please try again", duration: const Duration(seconds: 10));
                  }

                  Navigator.pop(context);
                },
                child: Text(
                  'Change Password',
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
