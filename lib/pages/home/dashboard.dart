import 'package:encryption_demo2/pages/home/compare.dart';
import 'package:encryption_demo2/pages/home/send_email.dart';
import 'package:encryption_demo2/pages/home/send_sms.dart';
import 'package:encryption_demo2/pages/home/storage_overview.dart';
import 'package:encryption_demo2/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../flavors.dart';
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
    final otpGenTime = ref.watch(generateDurationProvider);
    final otpValTime = ref.watch(validateDurationProvider);
    // final authTime = ref.watch(authenticationDurationProvider);
    final authTime = "${double.tryParse(otpGenTime?.replaceAll('s', '') ?? '') ?? ''}${double.tryParse(otpValTime?.replaceAll('s', '') ?? '')}";
    final regTime = ref.watch(userRegistrationDurationProvider);
    final passGenTime = ref.watch(passwordGenerationDurationProvider);

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
                child: Image.asset(F.icon),
              ),
            ),
            Text(F.appFlavor == Flavor.abo ? F.title : 'RNS + BASE64', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 25),),
            const SizedBox(height: 70),
            Text('Welcome ${user?.displayName ?? 'User'}, \n${F.appFlavor == Flavor.abo ? '\nOTP generation took $otpGenTime,\nOTP validation took $otpValTime\nAuthentication process took: $authTime\nRegistration process took: $regTime\nUsername & Password: $passGenTime' : 'what would you like to do?'}', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
            const SizedBox(height: 50),
            ...F.appFlavor == Flavor.abo ? [
              Container(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () => Get.to(() => const StorageOverviewPage()),
                  child: Text(
                    'Go to Dashboard',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                    fixedSize: MaterialStateProperty.all(const Size(150, 50)),
                  ),
                ),
              ),
            ] : [
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
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
