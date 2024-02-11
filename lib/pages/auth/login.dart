import 'package:encryption_demo2/models/user.dart';
import 'package:encryption_demo2/pages/home/dashboard.dart';
import 'package:encryption_demo2/providers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';

import '../../services/db.dart';
import '../../src/rust/api/simple.dart';
import '../../utilities.dart';
import '../../widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final loginForm = GlobalKey<FormState>();
  final registrationForm = GlobalKey<FormState>();

  final loginEmail = TextEditingController();
  final loginPassword = TextEditingController();

  final registerEmail = TextEditingController();
  final registerPassword = TextEditingController();
  final registerPassword2 = TextEditingController();
  final registerName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Log In',
              ),
              Tab(
                text: 'Sign Up',
              ),
            ]
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(25),
          child: TabBarView(
            children: [
              Form(
                key: loginForm,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Email address'
                      ),
                      controller: loginEmail,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => value?.isEmpty != true ? null : 'Email address is required',
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: 'Password'
                      ),
                      controller: loginPassword,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      validator: (value) => value?.isEmpty != true ? null : 'Password is required',
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 40),
                    TextButton(
                      onPressed: () async {
                        if( loginForm.currentState?.validate() != true ) return;

                        Widgets.load();

                        final user = (await DB.isar()).users
                            .filter()
                            .emailEqualTo(loginEmail.text)
                            .passwordEqualTo(Utils.hashPassword(loginPassword.text))// use index
                            .findFirstSync();

                        if( user == null ){
                          Get.snackbar("Error", "Invalid credentials");
                          Navigator.pop(context);
                        } else {
                          providerContainer.read(loggedInUserProvider.notifier).state = user;
                          Get.offAll(const DashboardScreen());
                        }
                      },
                      child: Text(
                        'Log In',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
                        fixedSize: MaterialStateProperty.all(const Size(150, 50)),
                      ),
                    ),
                  ],
                ),
              ),
              Form(
                key: registrationForm,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: 'Email address'
                      ),
                      controller: registerEmail,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => value?.isEmpty != true ? (GetUtils.isEmail(value!) ? null : 'Invalid email address') : 'Email address is required',
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: 'Display Name'
                      ),
                      controller: registerName,
                      keyboardType: TextInputType.text,
                      validator: (value) => value?.isEmpty != true ? null : 'Display name is required',
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: 'Password'
                      ),
                      controller: registerPassword,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      validator: (value) => value?.isEmpty != true ? (GetUtils.isLengthBetween(value!, 6, 20) ? null : 'Invalid password') : 'Password is required',
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: 'Password Confirmation'
                      ),
                      controller: registerPassword2,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      validator: (value) => value?.isEmpty != true ? (value != registerPassword.text ? 'Passwords do not match' : null) : 'Password is required',
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 40),
                    TextButton(
                      onPressed: () async {
                        if( registrationForm.currentState?.validate() != true ) return;

                        Widgets.load();

                        try {
                          final user = User()
                            ..email = registerEmail.text
                            ..password = Utils.hashPassword(registerPassword.text)
                            ..displayName = registerName.text;
                          final isar = await DB.isar();
                          final userId = isar.writeTxnSync((){
                            return isar.users.putSync(user);
                          });

                          providerContainer.read(loggedInUserProvider.notifier).state = user..id = userId;
                          Get.snackbar("Success", "Registration completed successfully");
                          await Future.delayed(const Duration(seconds: 2));
                          Get.offAll(const DashboardScreen());
                        } catch (e) {
                          print(e);
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
                        fixedSize: MaterialStateProperty.all(const Size(150, 50)),
                      ),
                    ),
                  ],
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
}
