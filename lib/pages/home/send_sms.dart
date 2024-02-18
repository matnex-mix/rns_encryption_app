import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
// import 'package:flutter_sms/flutter_sms.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sms_advanced/sms_advanced.dart';

import '../../src/rust/api/simple.dart';
import '../../widgets.dart';

class SendSMSScreen extends StatefulWidget {
  const SendSMSScreen({Key? key}) : super(key: key);

  @override
  State<SendSMSScreen> createState() => _SendSMSScreenState();
}

class _SendSMSScreenState extends State<SendSMSScreen> {

  final GlobalKey<FormState> formKey = GlobalKey();

  var phone = TextEditingController();
  var key = TextEditingController();
  var message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Send SMS'),
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
                      hintText: 'Phone number',
                      suffixIcon: IconButton(
                        onPressed: () async {
                          if (await Permission.contacts.request().isGranted) {
                            final contact = await FlutterContacts
                                .openExternalPick();
                            if (contact != null && contact.phones.length > 0) {
                              print(jsonEncode(contact.phones));
                              phone.text = contact.phones[0].number
                                  .removeAllWhitespace
                                  .replaceAll("(", "")
                                  .replaceAll(")", "")
                                  .replaceAll("-", "");
                              setState(() {});
                            } else {
                              Get.snackbar("Error", "No phone number was found please choose a different contact");
                            }
                          }
                        },
                        icon: Icon( Icons.person_search ),
                      )
                  ),
                  controller: phone,
                  keyboardType: TextInputType.text,
                  validator: (value) => value?.isEmpty != true ? (GetUtils.isPhoneNumber(value!) ? null : 'Invalid phone number') : 'Phone number is required',
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 20),
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
                  keyboardType: TextInputType.text,
                  maxLines: 10,
                  validator: (value) => value?.isEmpty != true ? null : 'Message is required',
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 40),
                TextButton(
                  onPressed: () async {
                    if( formKey.currentState?.validate() != true ) return;

                    Widgets.load(dismissible: false);

                    try {
                      // send sms
                      // String _result = await sendSMS(message: message.text, recipients: [phone.text], sendDirect: true);

                      SmsSender sender = SmsSender();
                      await sender.sendSms(SmsMessage(phone.text, encrypt(key: key.text, message: message.text)));

                      formKey.currentState?.reset();
                      Get.snackbar("Success", "SMS sent successfully");
                    } on Exception catch (e) {
                      Get.snackbar("Error", "Message not sent, Please try again");
                    } finally {
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'Send',
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
