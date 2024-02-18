import 'package:encryption_demo2/models/user.dart';
import 'package:encryption_demo2/pages/home/dashboard.dart';
import 'package:encryption_demo2/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';

import '../../services/db.dart';
import '../../src/rust/api/simple.dart';
import '../../utilities.dart';
import '../../widgets.dart';
import 'forgot_password.dart';

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
  final answer = TextEditingController();

  String? question;

  bool showPassword = false;
  bool forForgotPassword = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Container(
          // headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled)  => [],
          // scrollDirection: Axis.vertical,
          child: Container(
            // hasScrollBody: false,
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
                      child: ListView(
                        // mainAxisSize: MainAxisSize.min,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 150,
                            height: 150,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Image.asset('assets/images/icon.jpg'),
                            ),
                          ),
                          const SizedBox(height: 20),
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
                            obscureText: !showPassword,
                            validator: (value) => value?.isEmpty != true || forForgotPassword ? null : 'Password is required',
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                          ),
                          const SizedBox(height: 40),
                          TextButton(
                            onPressed: () async {
                              forForgotPassword = false;
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
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () async {
                              forForgotPassword = true;
                              if( loginForm.currentState?.validate() != true ) return;

                              final user = (await DB.isar()).users
                                .filter()
                                .emailEqualTo(loginEmail.text)
                                .findFirstSync();

                              if ( user == null ){
                                Get.snackbar("Error", "An account with this email address does not exist");
                                return;
                              }

                              Get.to(() => ForgotPasswordScreen(user: user));
                            },
                            child: const Text('Forgot Password?'),
                          ),
                        ],
                      ),
                    ),
                    Form(
                      key: registrationForm,
                      child: ListView(
                        // mainAxisSize: MainAxisSize.min,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 150,
                            height: 150,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Image.asset('assets/images/icon.jpg'),
                            ),
                          ),
                          const SizedBox(height: 20),
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
                                hintText: 'Display Name',
                            ),
                            controller: registerName,
                            keyboardType: TextInputType.text,
                            validator: (value) => value?.isEmpty != true ? null : 'Display name is required',
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
                            controller: registerPassword,
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
                            controller: registerPassword2,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: !showPassword,
                            validator: (value) => value?.isEmpty != true ? (value != registerPassword.text ? 'Passwords do not match' : null) : 'Password is required',
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                          ),
                          const SizedBox(height: 20),
                          Container(
                            child: DropdownButton(
                              isExpanded: true,
                              value: question,
                              hint: Text('Select security question'),
                              items: [
                                'What city were you born in?',
                                'What is your oldest sibling’s middle name?',
                                'What was the first concert you attended?',
                                'What was the make and model of your first car?',
                                'In what city or town did your parents meet?',
                                'What is your mother\'s maiden name?',
                                'Dummy'
                              ].map((e) => DropdownMenuItem(value: e, child: Text(e, softWrap: true))).toList(),
                              onChanged: (value) {
                                if ( value != null ){
                                  setState(() {
                                    question = value;
                                  });
                                }
                              }
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
                          const SizedBox(height: 40),
                          TextButton(
                            onPressed: () async {
                              if( registrationForm.currentState?.validate() != true ) return;

                              Widgets.load();

                              try {
                                final user = User()
                                  ..email = registerEmail.text
                                  ..password = Utils.hashPassword(registerPassword.text)
                                  ..displayName = registerName.text
                                  ..answer = answer.text
                                  ..question = question;
                                final isar = await DB.isar();
                                final userId = isar.writeTxnSync((){
                                  return isar.users.putSync(user);
                                });

                                providerContainer.read(loggedInUserProvider.notifier).state = user..id = userId;
                                Get.snackbar("Success", "Registration completed successfully");
                                await Future.delayed(const Duration(seconds: 2));
                                Get.offAll(const DashboardScreen());
                              } catch (e) {
                                // print(e);
                                Navigator.pop(context);
                                Get.snackbar("Error", "Could not register, please check the information and try again", duration: const Duration(seconds: 10));
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
          ),
        )
      ),
    );
  }
}
