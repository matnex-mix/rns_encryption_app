import 'dart:convert';

import 'package:dart_des/dart_des.dart';
import 'package:encrypt/encrypt.dart' as ec;
import 'package:encryption_demo2/pages/comparation_result.dart';
import 'package:encryption_demo2/services/base64_plus_key.dart';
import 'package:encryption_demo2/widgets/custom_select.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripledes_nullsafety/tripledes_nullsafety.dart';

import '../../src/rust/api/simple.dart';
import '../../src/rust/frb_generated.dart';
import '../../widgets.dart';

String getSeconds(int milliseconds){
  return "${(milliseconds/1000000).toPrecision(4)}s";
}

String padTo16Or24(String s){
  int pads = 0;

  if( s.length <= 16 ){
    pads = 16 - s.length;
  } else {
    pads = 24 - s.length;
  }

  for(int i = 0; i < pads; i++){
    s += " ";
  }

  return s;
}

compare (arg) async {
  await RustLib.init();

  final isolatekey = arg[0];
  final isolateMsg = arg[1];
  final selectedEncrypts = arg[2];
  final noReps = arg[3] ?? 1;

  try {
    final List<Map<String, Map<String, dynamic>>> results = [
      {
        'details': {
          'messageSize': isolateMsg.codeUnits.length,
          'keySize': isolatekey.codeUnits.length,
        }
      },
    ];

    for (var i = 1; i < noReps + 1; i++){
      results.add({});
      if (selectedEncrypts.contains("aes")) {
        results[i]['aes'] = {
          'encryption': '',
          'decryption': '',
        };

        final theKey = ec.Key.fromUtf8(padTo16Or24(isolatekey));
        final iv = ec.IV.fromLength(16);

        final encrypter = ec.Encrypter(ec.AES(theKey));

        var before = DateTime.now();
        final encrypted = encrypter.encrypt(
            isolateMsg, iv: iv);
        results[i]['aes']?['encryption'] = getSeconds(DateTime.now().difference(before).inMicroseconds);

        before = DateTime.now();
        final decrypted = encrypter.decrypt(
            encrypted, iv: iv);
        results[i]['aes']?['decryption'] = getSeconds(DateTime.now().difference(before).inMicroseconds);
      }

      if (selectedEncrypts.contains("3des")) {
        results[i]['3des'] = {
          'encryption': '',
          'decryption': '',
        };

        // final encrypter = new BlockCipher(new DESEngine(), isolatekey);
        final encrypter = DES3(key: padTo16Or24(isolatekey).codeUnits, mode: DESMode.ECB);

        var before = DateTime.now();
        final encrypted = encrypter.encrypt(isolateMsg.codeUnits);
        // final encrypted = encrypter.encodeB64(isolateMsg);
        results[i]['3des']?['encryption'] = getSeconds(DateTime.now().difference(before).inMicroseconds);

        before = DateTime.now();
        final decrypted = encrypter.decrypt(encrypted);
        // final decrypted = encrypter.decodeB64(encrypted);
        results[i]['3des']?['decryption'] = getSeconds(DateTime.now().difference(before).inMicroseconds);
      }

      if (selectedEncrypts.contains("base64")) {
        results[i]['base64'] = {
          'encryption': '',
          'decryption': '',
        };

        var before = DateTime.now();
        final encrypted = base64Encode(
            isolateMsg.codeUnits);
        results[i]['base64']?['encryption'] = getSeconds(DateTime.now().difference(before).inMicroseconds);

        before = DateTime.now();
        final decrypted = base64Decode(encrypted);
        results[i]['base64']?['decryption'] = getSeconds(DateTime.now().difference(before).inMicroseconds);
      }

      if (selectedEncrypts.contains("base64+key")) {
        results[i]['base64+key'] = {
          'encryption': '',
          'decryption': '',
        };

        var before = DateTime.now();
        final encrypted = bkey([isolateMsg, isolatekey]);
        results[i]['base64+key']?['encryption'] = getSeconds(DateTime.now().difference(before).inMicroseconds);

        before = DateTime.now();
        final decrypted = dkey([encrypted, isolatekey]);
        results[i]['base64+key']?['decryption'] = getSeconds(DateTime.now().difference(before).inMicroseconds);
      }

      // Our own algorithm | Base 64 RNS
      results[i]['base64+rns'] = {
        'encryption': '',
        'decryption': '',
      };

      var before = DateTime.now();
      final encrypted = encrypt(key: isolatekey, message: isolateMsg);
      results[i]['base64+rns']?['encryption'] = getSeconds(DateTime.now().difference(before).inMicroseconds);

      before = DateTime.now();
      final decrypted = decrypt(key: isolatekey, ciphertext: encrypted);
      results[i]['base64+rns']?['decryption'] = getSeconds(DateTime.now().difference(before).inMicroseconds);
    }

    return results;
  } catch (e) {
    // rethrow;
    return e.toString();
  }
}

class CompareScreen extends StatefulWidget {
  const CompareScreen({Key? key}) : super(key: key);

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {

  final GlobalKey<FormState> formKey = GlobalKey();

  List<String> selectedEncrypts = [];

  var key = TextEditingController();
  var reps = TextEditingController();
  var message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Compare'),
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
                      hintText: 'Message'
                  ),
                  controller: message,
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                  validator: (value) => value?.isEmpty != true ? null : 'Message is required',
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 20),
                CustomMultiselectDropDown(
                  label: "Compare to?",
                  selectedList: (value){
                    selectedEncrypts = value;
                  },
                  listOFStrings: ["aes", "3des", "base64", "base64+key"]
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Repeat e.g 1 - 10'
                  ),
                  controller: reps,
                  keyboardType: TextInputType.text,
                  validator: (value) => value != null && (double.tryParse(value) ?? 0) > 10 ? 'Maximum repetition is 10' : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 40),
                TextButton(
                  onPressed: () async {
                    if( formKey.currentState?.validate() != true ) return;

                    Widgets.load(dismissible: false);
                    final noReps = double.tryParse(reps.text) ?? 1;

                    final result = await compute(compare, [key.text, message.text, selectedEncrypts, noReps]);

                    if( result is List<Map<String, Map<String, dynamic>>> ){
                      Get.off(ComparationResult(
                        result: result
                      ));
                    } else {
                      Get.back();
                      Get.snackbar("Error", result.toString());
                    }
                  },
                  child: Text(
                    'Compare',
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
