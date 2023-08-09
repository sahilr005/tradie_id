import 'package:flutter/material.dart';
import 'package:tradie_id/home/ui/card_list.dart';
import 'package:tradie_id/profile/profile_page.dart';

import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tradie Id"),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Card(
                child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (a) => const CardListScreen()));
                    },
                    title: const Text("My Cards"),
                    trailing: const Icon(Icons.arrow_forward_ios)),
              ),
              Card(
                child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (a) => const ProfilePage()));
                    },
                    title: const Text("Profile"),
                    trailing: const Icon(Icons.person)),
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
                  trailing: const Icon(Icons.arrow_forward_ios_rounded),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () async {
                    try {
                      !await launchUrl(Uri.parse(
                          "https://esofttechnologies.com.au/contact.html"));
                    } catch (e) {}
                  },
                  title: const Text("Contact Us"),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationLegalese: "Tradie Id",
                      applicationName: "E-soft",
                      applicationVersion: "1.0.0",
                    );
                  },
                  title: const Text("About Us"),
                  trailing: const Icon(Icons.info),
                ),
              ),
            ],
          )),
    );
  }
}
