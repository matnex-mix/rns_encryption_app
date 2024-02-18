import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
// import 'package:flutter_sms/flutter_sms.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sms_advanced/sms_advanced.dart';

import '../../src/rust/api/simple.dart';
import '../../widgets.dart';

class EncryptionScreen extends StatefulWidget {
  const EncryptionScreen({Key? key}) : super(key: key);

  @override
  State<EncryptionScreen> createState() => _EncryptionScreenState();
}

class _EncryptionScreenState extends State<EncryptionScreen> {

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
        title: Text('Encrypt Plaintext'),
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
                    hintText: 'Encryption Key',
                    counterText: key.text.length > 0 ? 'Key Size: ${key.text.length} bytes' : null,
                  ),
                  controller: key,
                  keyboardType: TextInputType.text,
                  validator: (value) => value?.isEmpty != true ? (value!.length > 60 ? 'Key is too long' : null) : 'Key is required',
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: true,
                  onChanged: (value) => setState((){}),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Message',
                    counterText: message.text.length > 0 ? 'Message Size: ${message.text.length} bytes' : null,
                  ),
                  controller: message,
                  keyboardType: TextInputType.text,
                  validator: (value) => value?.isEmpty != true ? null : 'Plain text is required',
                  maxLines: 5,
                  onChanged: (value) => setState((){}),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Cipher Text',
                    fillColor: Colors.grey,
                    counterText: cipher.text.length > 0 ? 'Memory Size: ${cipher.text.length} bytes' : null,
                  ),
                  controller: cipher,
                  keyboardType: TextInputType.text,
                  maxLines: 10,
                  readOnly: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (value) => setState((){}),
                ),
                const SizedBox(height: 40),
                TextButton(
                  onPressed: () async {
                    if( formKey.currentState?.validate() != true ) return;

                    Widgets.load(dismissible: false);

                    try {
                      final ciphertext = encrypt(key: key.text, message: message.text);
                      formKey.currentState?.reset();
                      cipher.text = ciphertext;
                    } on Exception catch (e) {
                      Get.snackbar("Error", "An error occurred, Please try again");
                    } finally {
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'Encrypt',
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
        ),
      ),
    );
  }
}
