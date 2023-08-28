import 'dart:developer';
import 'package:lottie/lottie.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tradie_id/config/config.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:tradie_id/home/ui/home_page.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  // final TextEditingController licenseController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  File? _image;
  String? _base64Image;

  Future getImage() async {
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
                // Center(
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: <Widget>[
                //       const SizedBox(height: 20),
                //       _base64Image == null
                //           ? InkWell(
                //               onTap: () {
                //                 getImage();
                //               },
                //               child: Container(
                //                 decoration: BoxDecoration(
                //                   shape: BoxShape.circle,
                //                   color: Colors.grey.shade300,
                //                 ),
                //                 padding: const EdgeInsets.all(30),
                //                 alignment: Alignment.center,
                //                 child: const Icon(Icons.add_a_photo),
                //               ),
                //             )
                //           : InkWell(
                //               onTap: () {
                //                 getImage();
                //               },
                //               child: Image.memory(base64Decode(_base64Image!),
                //                   height: 200),
                //             ),
                //     ],
                //   ),
                // ),
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
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    // You can add more sophisticated email validation here
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone No.',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 13,
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
                // TextField(
                //   controller: licenseController,
                //   decoration: const InputDecoration(
                //     labelText: 'License No.',
                //     border: OutlineInputBorder(),
                //   ),
                // ),
                // const SizedBox(height: 16.0),
                TextField(
                  controller: roleController,
                  decoration: const InputDecoration(
                    labelText: 'Role',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      EasyLoading.show();
                      try {
                        Response? res = await dio.post(
                          "http://68.178.163.90:4500/api/employe/register",
                          data: {
                            "name": usernameController.text,
                            "email": emailController.text,
                            "phone_no": phoneController.text,
                            "role": roleController.text,
                            "license": "",
                            "city": "",
                            "state": "",
                            "country": "",
                            "description": "",
                            "profileImage": _base64Image ?? "",
                            "password": passwordController.text
                          },
                        );

                        log(res.data.toString());
                        EasyLoading.dismiss();
                        if (res.data["status"] == "error") {
                          Fluttertoast.showToast(
                            msg: res.data["data"]["message"].toString(),
                            toastLength: Toast.LENGTH_LONG,
                          );
                        } else {
                          box!.put('name', usernameController.text);
                          box!.put('phone', phoneController.text);
                          box!.put('email', emailController.text);
                          // ignore: use_build_context_synchronously
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (a) => const HomePage()),
                              (route) => false);
                        }
                      } catch (e) {
                        EasyLoading.dismiss();
                      }
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
}
