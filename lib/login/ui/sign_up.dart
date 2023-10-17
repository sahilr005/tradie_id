import 'dart:developer';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tradie_id/login/ui/otp_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController countryCodeController =
      TextEditingController(text: "+61");
  final TextEditingController conformController = TextEditingController();
  // final TextEditingController passwordController = TextEditingController();
  File? _image;
  String? _base64Image;

  getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _convertImageToBase64();
      }
    });
  }

  void _convertImageToBase64() async {
    Uint8List imageBytes = await _image!.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    setState(() {
      _base64Image = base64Image;
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Lottie.asset('assets/json/login.json',
                    height: MediaQuery.of(context).size.height * .4),
                const SizedBox(height: 20),
                TextFormField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
         
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone No.',
                    border: const OutlineInputBorder(),
                    prefixIcon: CountryCodePicker(
                      onChanged: (value) {
                        countryCodeController.text = value.dialCode!;
                        setState(() {});
                      },
                      initialSelection: '+61',
                      favorite: const ['+61', '+91'],
                      showCountryOnly: false,
                      showOnlyCountryWhenClosed: false,
                      alignLeft: false,
                    ),
                  ),
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    // You can add more specific phone number validation here
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                // TextFormField(
                //   controller: passwordController,
                //   decoration: const InputDecoration(
                //     labelText: 'Password',
                //     border: OutlineInputBorder(),
                //   ),
                //   keyboardType: TextInputType.visiblePassword,
                //   obscureText: true,
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Please enter your Password';
                //     }
                //     return null;
                //   },
                // ),
                // const SizedBox(height: 16.0),
                // TextFormField(
                //   controller: conformController,
                //   decoration: const InputDecoration(
                //     labelText: 'Confirm Password',
                //     border: OutlineInputBorder(),
                //   ),
                //   keyboardType: TextInputType.visiblePassword,
                //   obscureText: true,
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Please confirm your Password';
                //     }
                //     if (value != passwordController.text) {
                //       return 'Passwords do not match';
                //     }
                //     return null;
                //   },
                // ),
                // const SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      signInWithPhone(context,
                          countryCodeController.text + phoneController.text);
                    }
                  },
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // signin
  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            // await _firebaseAuth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (error) {
            Fluttertoast.showToast(
                msg: error.message.toString(), toastLength: Toast.LENGTH_LONG);
            throw Exception(error.message);
          },
          codeSent: (verificationId, forceResendingToken) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (a) => VerifyOtpScreen(
                  fromLogin: false,
                  verificationId: verificationId,
                  onlyNumber: phoneController.text,
                  name: usernameController.text,
                  // password: passwordController.text,
                  phoneNo: countryCodeController.text + phoneController.text,
                ),
              ),
            );
          },
          codeAutoRetrievalTimeout: (verificationId) {});
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());
      Fluttertoast.showToast(
          msg: e.message.toString(), toastLength: Toast.LENGTH_LONG);
    }
  }
}
