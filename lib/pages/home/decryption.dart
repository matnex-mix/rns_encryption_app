import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
// import 'package:flutter_sms/flutter_sms.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sms_advanced/sms_advanced.dart';

import '../../src/rust/api/simple.dart';
import '../../widgets.dart';

class DecryptionScreen extends StatefulWidget {
  const DecryptionScreen({Key? key}) : super(key: key);

  @override
  State<DecryptionScreen> createState() => _DecryptionScreenState();
}

class _DecryptionScreenState extends State<DecryptionScreen> {

  final GlobalKey<FormState> formKey = GlobalKey();

  var key = TextEditingController();
  var cipher = TextEditingController();
  var message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Decrypt Ciphertext'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(25),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                      hintText: 'Encryption Key'
                  ),
                  controller: key,
                  keyboardType: TextInputType.text,
                  validator: (value) => value?.isEmpty != true ? (value!.length > 60 ? 'Key is too long' : null) : 'Key is required',
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                      hintText: 'Cipher Text'
                  ),
                  controller: cipher,
                  keyboardType: TextInputType.text,
                  maxLines: 5,
                  validator: (value) => value?.isEmpty != true ? null : 'Cipher text is required',
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Message',
                    fillColor: Colors.grey
                  ),
                  readOnly: true,
                  controller: message,
                  keyboardType: TextInputType.text,
                  maxLines: 10,
                ),
                const SizedBox(height: 40),
                TextButton(
                  onPressed: () async {
                    if( formKey.currentState?.validate() != true ) return;

                    Widgets.load(dismissible: false);

                    try {
                      final plaintext = decrypt(key: key.text, ciphertext: cipher.text);
                      formKey.currentState?.reset();
                      message.text = plaintext;
                    } on Exception catch (e) {
                      Get.snackbar("Error", "An error occurred, Please try again");
                    } finally {
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'Decrypt',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                    fixedSize: MaterialStateProperty.all(const Size(150, 50)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
