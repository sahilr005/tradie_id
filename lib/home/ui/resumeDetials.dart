import 'package:flutter/material.dart';
import 'package:tradie_id/home/ui/home_page.dart';

class ResumeDisplay extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String position;
  final String experience;
  final String education;
  final String resume;

  const ResumeDisplay({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.position,
    required this.experience,
    required this.education,
    required this.resume,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Display'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: $name',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Email: $email'),
            Text('Phone: $phone'),
            Text('Address: $address'),
            const SizedBox(height: 20),
            Text(
              'Position: $position',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Experience: $experience'),
            Text('Education: $education'),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (a) => const HomePage()),
                  (route) => false);
            },
            child: const Text("Done")),
      ),
    );
  }
}
