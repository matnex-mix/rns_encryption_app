import 'dart:math';

import 'package:encryption_demo2/pages/otp/validate_otp.dart';
import 'package:encryption_demo2/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../utilities.dart';
import '../../widgets.dart';

class SelectModuloScreen extends ConsumerStatefulWidget {
  const SelectModuloScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SelectModuloScreen> createState() => _SelectModuloScreenState();
}

class _SelectModuloScreenState extends ConsumerState<SelectModuloScreen> {

  List<int> selectedModulos = [];
  late List<int> moduloList;

  @override
  void initState() {
    moduloList = Utils.getPrimes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Select 3 numbers",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30,),
            GridView.count(
              shrinkWrap: true,
              mainAxisSpacing: 20,
              crossAxisCount: 3,
              childAspectRatio: 1.5,
              children: moduloList.map<Widget>((e) {
                final check = selectedModulos.indexOf(e);

                return InkWell(
                  customBorder: CircleBorder(),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Theme.of(context).primaryColor),
                      color: check == -1 ? Colors.transparent : Theme.of(context).primaryColor,
                    ),
                    child: Text(
                      '$e',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: check == -1 ? Theme.of(context).primaryColor : Colors.white,
                        fontSize: 30
                      ),
                    ),
                  ),
                  onTap: (){
                    if( check == -1 && selectedModulos.length < 3 ) {
                      selectedModulos.add(e);
                      if( selectedModulos.length == 3 ){
                        // proceed here
                      }
                    } else {
                      selectedModulos.removeAt(check);
                    }

                    setState((){});
                  },
                );
              }).toList()
                ..add(Container(
                  // color: Colors.red,
                ))
                ..add(InkWell(
                  customBorder: CircleBorder(),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Theme.of(context).primaryColor),
                    ),
                    child: Icon(
                      Icons.refresh,
                      color: Theme.of(context).primaryColor,
                      size: 30,
                    ),
                  ),
                  onTap: (){
                    setState(() {
                      moduloList = Utils.getPrimes();
                      selectedModulos = [];
                    });
                  },
                ))
                ..add(Container(
                  // color: Colors.red,
                )),
            ),
            Container(
              margin: EdgeInsets.only(top: 60, bottom: 30),
              child: LinearPercentIndicator(
                alignment: MainAxisAlignment.center,
                width: 240.0,
                lineHeight: 20.0,
                percent: selectedModulos.length/3,
                backgroundColor: Colors.grey.withOpacity(.5),
                progressColor: Theme.of(context).primaryColor,
                animateFromLastPercent: true,
                barRadius: Radius.circular(10),
                animationDuration: 250,
                center: Text(
                  '${selectedModulos.length} of 3',
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () async {
                  Widgets.load();

                  try {

                    final start = DateTime.now();
                    final realOtp = Random().nextInt(899999) + 100000;

                    providerContainer.read(realOtpProvider.notifier).state = realOtp;
                    providerContainer.read(selectedModulosProvider.notifier).state = selectedModulos;

                    providerContainer.read(generateDurationProvider.notifier).state = Utils.getSeconds(DateTime.now().difference(start).inMicroseconds);

                    final text = "Here is your OTP: ${selectedModulos.map((e) => realOtp % e).join('|')}";
                    print(text);
                    // await Utils.sendMail(ref.watch(loggedInUserProvider)!.email!, text, subject: "Your Secure OTP");

                    Get.back();
                    Get.snackbar("Success", "OTP sent successfully!");
                    Get.to(() => const OTPValidationScreen());
                  } catch (e) {
                    print(e);
                    Navigator.pop(context);
                    Get.snackbar("Error", "An error occurred, could not send otp", duration: const Duration(seconds: 10));
                  }
                },
                child: Text(
                  'Proceed',
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                  fixedSize: MaterialStateProperty.all(const Size(150, 50)),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
