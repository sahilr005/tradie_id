import 'dart:developer';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:tradie_id/config/config.dart';
import 'package:tradie_id/home/ui/home_page.dart';
import 'package:tradie_id/login/bloc/login_bloc.dart';
import 'package:tradie_id/login/bloc/login_state.dart';
import 'package:tradie_id/login/ui/otp_screen.dart';
import 'package:tradie_id/login/ui/sign_up.dart';
import 'package:tradie_id/model/login_model.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(),
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (a) => const HomePage()));
            } else if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            if (state is LoginLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return LoginForm();
            }
          },
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController countryCodeController =
      TextEditingController(text: "+61");
  LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Lottie.asset('assets/json/login.json',
                height: MediaQuery.of(context).size.height * .4),
            const SizedBox(height: 50),
            TextField(
              controller: usernameController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Phone No.',
                border: const OutlineInputBorder(),
                prefixIcon: CountryCodePicker(
                  onChanged: (value) {
                    countryCodeController.text = value.dialCode!;
                  },
                  initialSelection: '+61',
                  favorite: const ['+61', '+91'],
                  showCountryOnly: false,
                  showOnlyCountryWhenClosed: false,
                  alignLeft: false,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // TextField(
            //   controller: passwordController,
            //   decoration: const InputDecoration(
            //     labelText: 'Password',
            //     border: OutlineInputBorder(),
            //   ),
            //   obscureText: true,
            // ),
            // const SizedBox(height: 14.0),
            // InkWell(
            //   onTap: () async {
            //     if (usernameController.text.isEmpty) {
            //       Fluttertoast.showToast(msg: "Enter Email Id");
            //     } else {
            //       Response? res = await Dio().post(
            //           "http://68.178.163.90:4500/api/employe/forgotPassword",
            //           data: {"email": usernameController.text}).catchError((e) {
            //         Fluttertoast.showToast(msg: e.response!.data["message"]);
            //       });

            //       if (res.statusCode == 200) {
            //         Fluttertoast.showToast(
            //           msg: res.data["message"].toString(),
            //           toastLength: Toast.LENGTH_LONG,
            //         );
            //       }
            //     }
            //   },
            //   child: const Align(
            //       alignment: Alignment.centerRight,
            //       child: Text("Forgot Password?")),
            // ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                signInWithPhone(
                    onlyNumber: usernameController.text.length == 9
                        ? "0${usernameController.text}"
                        : usernameController.text,
                    context: context,
                    phoneNumber: countryCodeController.text +
                        (usernameController.text.length == 9
                            ? "0${usernameController.text}"
                            : usernameController.text));
                // final username = usernameController.text;
                // final password = passwordController.text;
                // loginBloc.add(
                //     LoginButtonPressed(username: username, password: password));
              },
              child: const Text('Login'),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (a) => const SignUpScreen()));
              },
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }

  // signin
  void signInWithPhone({
    required BuildContext context,
    required String phoneNumber,
    required String onlyNumber,
  }) async {
    try {
      final response = await dio.post(
        "https://backend.tradieid.net.au/api/employe/login",
        // "https://backend.tradieid.net.au:8500/api/employe/login",
        // 'https://backend.tradieid.net.au:8500/api/employe/login',
        data: {'phone_no': onlyNumber},
      );
      EasyLoading.show();
      log(response.data.toString());
      if (response.statusCode == 200) {
        LoginModel loginModel = LoginModel.fromJson(response.data);

        log(response.data.toString());
        try {
          await _firebaseAuth.verifyPhoneNumber(
              phoneNumber: phoneNumber,
              verificationCompleted:
                  (PhoneAuthCredential phoneAuthCredential) async {
                // await _firebaseAuth.signInWithCredential(phoneAuthCredential);
                EasyLoading.dismiss();
              },
              verificationFailed: (error) {
                EasyLoading.dismiss();
                Fluttertoast.showToast(
                    msg: error.message.toString(),
                    toastLength: Toast.LENGTH_LONG);
                throw Exception(error.message);
              },
              codeSent: (verificationId, forceResendingToken) {
                EasyLoading.dismiss();
                log(verificationId.toString());
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (a) => VerifyOtpScreen(
                              fromLogin: true,
                              onlyNumber: onlyNumber,
                              verificationId: verificationId,
                              name: "",
                              phoneNo: phoneNumber,
                            )));
              },
              timeout: const Duration(minutes: 2),
              codeAutoRetrievalTimeout: (verificationId) {
                EasyLoading.dismiss();
              });
        } on FirebaseAuthException catch (e) {
          log(e.message.toString());
          EasyLoading.dismiss();
          Fluttertoast.showToast(
              msg: e.message.toString(), toastLength: Toast.LENGTH_LONG);
        }
      } else {
        EasyLoading.dismiss();
        Fluttertoast.showToast(msg: response.data["message"]);
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();
      if (e.response != null) {
        log(e.response!.data.toString());
        Fluttertoast.showToast(msg: e.response!.data["message"]);
      } else {
        Fluttertoast.showToast(
            msg: 'An error occurred while processing your request.');
      }
    } catch (e) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: e.toString());
      log(e.toString());
    }
  }
}

class ForgotPasswordDialog extends StatefulWidget {
  const ForgotPasswordDialog({super.key});

  @override
  _ForgotPasswordDialogState createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final TextEditingController _emailController = TextEditingController();

  void _sendPasswordResetEmail() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Forgot Password'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text('Send Email'),
          onPressed: () {
            _sendPasswordResetEmail();
          },
        ),
      ],
    );
  }
}
