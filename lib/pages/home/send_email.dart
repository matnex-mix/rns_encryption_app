import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import '../../src/rust/api/simple.dart';
import '../../widgets.dart';

class SendEmail extends StatefulWidget {
  const SendEmail({Key? key}) : super(key: key);

  @override
  State<SendEmail> createState() => _SendEmailState();
}

class _SendEmailState extends State<SendEmail> {

  final GlobalKey<FormState> formKey = GlobalKey();

  var to = TextEditingController(text: '');
  var key = TextEditingController(text: '');
  var subject = TextEditingController(text: '');
  var message = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Send Email'),
        automaticallyImplyLeading: true,
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
                    hintText: 'To'
                  ),
                  controller: to,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value?.isEmpty != true ? (GetUtils.isEmail(value!) ? null : 'Invalid email address') : 'To email address is required',
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
                    hintText: 'Subject'
                  ),
                  controller: subject,
                  keyboardType: TextInputType.text,
                  validator: (value) => value?.isEmpty != true ? (value!.length > 60 ? 'Subject is too long' : null) : 'Subject is required',
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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

                    String username = 'neero@techlava.ng';
                    String password = 'NEERO@Techlava';

                    final smtpServer = SmtpServer('mail.techlava.ng', username: username, password: password);

                    // Create our message.
                    final emailMessage = Message()
                      ..from = Address(username, 'Neero')
                      ..recipients.add(to.text)
                      ..subject = subject.text
                      ..text = encrypt(key: key.text, message: message.text);

                    try {
                      final sendReport = await send(emailMessage, smtpServer);
                      formKey.currentState?.reset();
                      Get.snackbar("Success", "Email sent successfully");
                    } on MailerException catch (e) {
                      print(e.message);
                      Get.snackbar("Error", "Message not sent, Please try again");
                      for (var p in e.problems) {
                        print('Problem: ${p.code}: ${p.msg}');
                      }
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
