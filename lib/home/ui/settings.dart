import 'package:flutter/material.dart';
import 'package:tradie_id/config/config.dart';
import 'package:tradie_id/home/ui/home_page.dart';
import 'package:tradie_id/login/ui/login_page.dart';
import 'package:tradie_id/profile/profile_page.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

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
              Card(
                child: ListTile(
                  onTap: () async {
                    try {
                      !await launchUrl(Uri.parse(
                          "https://esofttechnologies.com.au/portfolio.html"));
                    } catch (e) {}
                  },
                  title: const Text("Our Services"),
                  trailing: const Icon(Icons.sensors_rounded),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationLegalese: "E-soft",
                      applicationName: "Tradie Id",
                      applicationVersion: "1.0.0",
                    );
                  },
                  title: const Text("About Us"),
                  trailing: const Icon(
                    Icons.info,
                    color: Colors.blue,
                  ),
                ),
              ),
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
