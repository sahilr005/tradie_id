import 'package:flutter/material.dart';
import 'package:tradie_id/config/config.dart';
import 'package:tradie_id/home/ui/home_page.dart';
import 'package:tradie_id/login/ui/login_page.dart';
import 'package:tradie_id/profile/profile_page.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setting"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (a) => const ProfilePage()));
                    },
                    title: const Text("Profile"),
                    trailing: const Icon(
                      Icons.person,
                      color: Colors.green,
                    )),
              ),
              if (box!.get("phone").toString() == "8905671058")
                Card(
                  child: ListTile(
                    onTap: () async {
                      try {
                        !await launchUrl(Uri.parse(
                            "https://esofttechnologies.com.au/tradie-id.html"));
                      } catch (e) {}
                    },
                    title: const Text("Our Services"),
                    trailing: const Icon(Icons.sensors_rounded),
                  ),
                ),
              if (box!.get("phone").toString() == "8905671058")
                Card(
                  child: ListTile(
                    onTap: () {
                      showLogoutDialog(context, true);
                    },
                    title: const Text("Delete Account"),
                    trailing: Icon(
                      Icons.delete,
                      color: Colors.red.shade800,
                    ),
                  ),
                ),
              if (box!.get("phone").toString() == "8905671058")
                Card(
                  child: ListTile(
                    onTap: () {
                      showLogoutDialog(context, false);
                    },
                    title: const Text("Log out"),
                    trailing: Icon(
                      Icons.logout,
                      color: Colors.red.shade800,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () async {
                var url = "https://esofttechnologies.com.au/tradie-id.html";
                if (!await launchUrl(Uri.parse(url))) {
                  throw Exception('Could not launch $url');
                }
              },
              child: RichText(
                text: const TextSpan(
                    text: "Powered by ",
                    style: TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                        text: "E-soft Technologies",
                        style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline),
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showLogoutDialog(BuildContext context, bool delete) async {
    bool? logout = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return LogoutDialog(
          delete: delete,
        );
      },
    );

    if (logout!) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
      box!.clear();
      setState(() {});
    }
  }
}
