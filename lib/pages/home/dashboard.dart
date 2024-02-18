import 'package:encryption_demo2/pages/home/compare.dart';
import 'package:encryption_demo2/pages/home/send_email.dart';
import 'package:encryption_demo2/pages/home/send_sms.dart';
import 'package:encryption_demo2/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import 'decryption.dart';
import 'encryption.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(loggedInUserProvider);

    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Image.asset('assets/images/icon.jpg'),
              ),
            ),
            Text('RNS + BASE64', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 25),),
            const SizedBox(height: 70),
            Text('Welcome ${user?.displayName ?? 'User'}, \nwhat would you like to do?', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
            const SizedBox(height: 50),
            TextButton(
              onPressed: () => Get.to(() => SendEmail()),
              child: Text('Send Email')
            ),
            TextButton(
                onPressed: () => Get.to(() => SendSMSScreen()),
                child: Text('Send SMS')
            ),
            TextButton(
                onPressed: () => Get.to(() => CompareScreen()),
                child: Text('Compare with others')
            ),
            TextButton(
                onPressed: () => Get.to(() => EncryptionScreen()),
                child: Text('Encrypt text')
            ),
            TextButton(
                onPressed: () => Get.to(() => DecryptionScreen()),
                child: Text('Decrypt ciphertext')
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
