import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class JobListing {
  final String companyName;
  final String position;
  final String description;

  JobListing(
      {required this.companyName,
      required this.position,
      required this.description});
}

class JobListingPage extends StatefulWidget {
  const JobListingPage({super.key});

  @override
  _JobListingPageState createState() => _JobListingPageState();
}

class _JobListingPageState extends State<JobListingPage> {
  List<JobListing> jobListings = [
    JobListing(
      companyName: 'ABC Corporation',
      position: 'Software Engineer',
      description:
          'Join our team as a software engineer and work on exciting projects.',
    ),
    JobListing(
      companyName: 'XYZ Tech',
      position: 'UI/UX Designer',
      description: 'Design user interfaces for cutting-edge applications.',
    ),
    JobListing(
      companyName: 'Tech Innovators',
      position: 'Data Scientist',
      description:
          'Seeking a data scientist to analyze and interpret complex data.',
    ),
    JobListing(
      companyName: 'Global Solutions',
      position: 'Project Manager',
      description: 'Lead cross-functional teams and oversee project execution.',
    ),
    JobListing(
      companyName: 'EcoTech',
      position: 'Environmental Scientist',
      description:
          'Contribute to research and initiatives focused on environmental conservation.',
    ),
    JobListing(
      companyName: 'HealthLife',
      position: 'Medical Doctor',
      description:
          'Provide medical care and consultation to patients in a dynamic healthcare environment.',
    ),
    JobListing(
      companyName: 'Creative Media',
      position: 'Graphic Designer',
      description:
          'Create visually appealing designs for a variety of projects.',
    ),
    JobListing(
      companyName: 'Financial Pros',
      position: 'Financial Analyst',
      description:
          'Analyze financial data to provide insights and make informed business decisions.',
    ),
    JobListing(
      companyName: 'EnergyTech',
      position: 'Renewable Energy Engineer',
      description:
          'Design and develop renewable energy solutions for a sustainable future.',
    ),
    JobListing(
      companyName: 'Travel Explorers',
      position: 'Travel Blogger',
      description:
          'Share your travel experiences and recommendations with a global audience.',
    ),
    // Add more job listings
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Listings'),
      ),
      body: ListView.builder(
        itemCount: jobListings.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              elevation: 2,
              child: InkWell(
                onTap: () {
                  // Implement job details page navigation here
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        jobListings[index].position,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        jobListings[index].companyName,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Job Description:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(jobListings[index].description),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            // Implement apply functionality here
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Application Submitted'),
                                  content: Text(
                                      'You have applied for ${jobListings[index].position} at ${jobListings[index].companyName}.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Text('Apply'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class JobDetailsPage extends StatelessWidget {
  final JobListing jobListing;

  const JobDetailsPage({super.key, required this.jobListing});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(jobListing.position),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              jobListing.companyName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('Job Description:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(jobListing.description),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement apply functionality here
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Application Submitted'),
                      content: Text(
                          'You have applied for ${jobListing.position} at ${jobListing.companyName}.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Fluttertoast.showToast(msg: "Thanks for applying");
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }
}
