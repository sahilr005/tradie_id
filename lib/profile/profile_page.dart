import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tradie_id/config/config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController firstNameControllers =
      TextEditingController(text: box!.get("name").toString());

  TextEditingController emailControllers =
      TextEditingController(text: box!.get("email").toString());

  String? _imagePath;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = path.basename(pickedFile.path);
      var savedImage = await pickedFile.saveTo('${appDir.path}/$fileName');

      setState(() {
        _imagePath = '${appDir.path}/$fileName';
        box!.put("imagePath", '${appDir.path}/$fileName');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Profile", style: TextStyle(fontSize: 22)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // GestureDetector(
              //   onTap: () {
              //     _pickImage(); // Open image picker when the avatar is tapped
              //   },
              //   child: box!.get("imagePath") != null
              //       ? CircleAvatar(
              //           radius: 50,
              //           backgroundImage: FileImage(File(box!.get("imagePath"))),
              //         )
              //       : box!.get("image") == null ||
              //               box!.get("image").toString().isEmpty
              //           ? const CircleAvatar(
              //               radius: 50,
              //               child: Icon(Icons.add_a_photo),
              //             )
              //           : CircleAvatar(
              //               radius: 50,
              //               backgroundImage:
              //                   NetworkImage(box!.get("image").toString()),
              //             ),
              // ),
              const SizedBox(height: 20),
              Card(
                borderOnForeground: true,
                shape: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'First Name',
                            border: OutlineInputBorder()),
                        controller: firstNameControllers,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Enter First Name';
                          }
                          return null;
                        },
                      ),
                      // const SizedBox(height: 15),
                      // const Text("Last Name",
                      //     style: TextStyle(color: Colors.black)),
                      // const SizedBox(height: 5),
                      // TextFormField(
                      //   decoration: const InputDecoration(
                      //     hintText: 'Last Name',
                      //   ),
                      //   controller: cardNoControllers,
                      //   keyboardType: TextInputType.name,
                      //   textInputAction: TextInputAction.next,
                      //   validator: (String? value) {
                      //     if (value!.isEmpty) {
                      //       return 'Enter Last Name';
                      //     }
                      //     return null;
                      //   },
                      // ),
                      const SizedBox(height: 15),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Email', border: OutlineInputBorder()),
                        controller: emailControllers,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Enter Email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () {
              //     // Add functionality here
              //   },
              //   child: const Text('Edit Profile'),
              // ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ElevatedButton(
            onPressed: () {
              box!.put("name", firstNameControllers.text.toString());
              box!.put("email", emailControllers.text.toString());
              Fluttertoast.showToast(msg: "Profile Updated");
              setState(() {});
            },
            child: const Text("Save")),
      ),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      //   child: Column(
      //     mainAxisSize: MainAxisSize.min,
      //     children: [
      //       ElevatedButton(
      //         style: ElevatedButton.styleFrom(
      //             foregroundColor: Colors.white, backgroundColor: Colors.red),
      //         onPressed: () {
      //           box!.clear();
      //           setState(() {});
      //           Navigator.pushAndRemoveUntil(
      //               context,
      //               MaterialPageRoute(builder: (a) => LoginPage()),
      //               (route) => false);
      //         },
      //         child: const Padding(
      //           padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
      //           child: Center(
      //             child: Text(
      //               'Logout',
      //               style: TextStyle(
      //                 fontSize: 16,
      //                 fontWeight: FontWeight.w600,
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),
      //       ElevatedButton(
      //         style: ElevatedButton.styleFrom(
      //             foregroundColor: Colors.white, backgroundColor: Colors.red),
      //         onPressed: () {
      //           deleteAcDialog(context);
      //         },
      //         child: const Padding(
      //           padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
      //           child: Center(
      //             child: Text(
      //               'Delete Account',
      //               style: TextStyle(
      //                 fontSize: 16,
      //                 fontWeight: FontWeight.w600,
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  Future<dynamic> deleteAcDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          title: const Text("Delete Account"),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("No"),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                final Uri emailLaunchUri = Uri(
                  scheme: 'mailto',
                  path: 'support@e-soft.com',
                  query: encodeQueryParameters(<String, String>{
                    'subject': 'Delete Account',
                  }),
                );
                try {
                  await launchUrl(emailLaunchUri);
                } catch (e) {
                  log(e.toString());
                }
              },
              child: const Text("Yes"),
            ),
          ],
          content: const Text(
            "Do you want to delete your account?",
            style: TextStyle(fontSize: 16),
          ),
        );
      },
    );
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}
