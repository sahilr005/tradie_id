import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:tradie_id/config/config.dart';
import 'package:tradie_id/home/ui/home_page.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String name, phoneNo, verificationId, onlyNumber;
  final bool fromLogin;
  const VerifyOtpScreen(
      {super.key,
      required this.name,
      required this.onlyNumber,
      required this.phoneNo,
      required this.verificationId,
      required this.fromLogin});

  @override
  _VerifyOtpScreenState createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  TextEditingController otpController = TextEditingController();

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Image.asset(
                "assets/image3.png",
                height: MediaQuery.of(context).size.height * .2,
              ),
              const SizedBox(height: 50),
              PinCodeTextField(
                appContext: context,
                length: 6,
                controller: otpController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  // Handle OTP input changes
                },
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  inactiveColor: Colors.blue,
                  selectedColor: Colors.lightGreen,
                  activeFillColor: Colors.white,
                  inactiveFillColor: Colors.white,
                  selectedFillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  verifyOtp(
                    context: context,
                    verificationId: widget.verificationId,
                    userOtp: otpController.text,
                    onSuccess: () {},
                  );
                },
                child: const Text('Verify OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // verify otp
  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function onSuccess,
  }) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    EasyLoading.show();
    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);

      User? user = (await firebaseAuth.signInWithCredential(creds)).user;

      if (user != null) {
        box!.put('phone', widget.onlyNumber);
        log("OTP VERIFY");
        EasyLoading.show();
        if (widget.fromLogin) {
          EasyLoading.dismiss();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (a) => const HomePage()),
              (route) => false);
          // LoginModel loginModel =
          //     await ApiCall.postLoginData(phone: widget.phoneNo);
        } else {
          try {
            Response? res = await dio.post(
              "http://68.178.163.90:4500/api/employe/register",
              data: {"name": widget.name, "phone_no": widget.onlyNumber},
            );

            log(res!.data.toString());
            EasyLoading.dismiss();
            if (res.data["status"] == "error") {
              Fluttertoast.showToast(
                msg: res.data["data"]["message"].toString(),
                toastLength: Toast.LENGTH_LONG,
              );
            } else {
              box!.put('phone', widget.onlyNumber);
              box!.put('name', widget.name);
              box!.put('phone', widget.phoneNo);
              // ignore: use_build_context_synchronously
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (a) => const HomePage()),
                  (route) => false);
            }
          } catch (e) {
            Fluttertoast.showToast(
                msg: e.toString(), toastLength: Toast.LENGTH_LONG);
            EasyLoading.dismiss();
          }
        }
      }
      EasyLoading.dismiss();
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
          msg: e.message.toString(), toastLength: Toast.LENGTH_LONG);
      EasyLoading.dismiss();
    }
  }
}
