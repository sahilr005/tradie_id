import 'package:flutter/material.dart';
import 'package:tradie_id/home/ui/resumeDetials.dart';

class JobApplicationForm extends StatefulWidget {
  const JobApplicationForm({super.key});

  @override
  _JobApplicationFormState createState() => _JobApplicationFormState();
}

class _JobApplicationFormState extends State<JobApplicationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String? _selectedPosition;
  String? _selectedExperience;
  String? _selectedEducation;
  String? _uploadedResume = '';

  final List<String> _positions = [
    'Software Engineer',
    'UI/UX Designer',
    'Project Manager'
  ];
  final List<String> _experienceLevels = [
    'Entry Level',
    'Mid Level',
    'Senior Level'
  ];
  final List<String> _educationLevels = [
    'High School',
    'Bachelor\'s',
    'Master\'s',
    'PhD'
  ];

  void _handleResumeUpload(String value) {
    setState(() {
      _uploadedResume = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Application Form'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    // You can add more email validation logic here
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    // You can add more phone number validation logic here
                    return null;
                  },
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                  maxLines: 3,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField(
                  value: _selectedPosition,
                  items: _positions.map((position) {
                    return DropdownMenuItem(
                      value: position,
                      child: Text(position),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPosition = value;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Position'),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a position';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField(
                  value: _selectedExperience,
                  items: _experienceLevels.map((level) {
                    return DropdownMenuItem(
                      value: level,
                      child: Text(level),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedExperience = value;
                    });
                  },
                  decoration:
                      const InputDecoration(labelText: 'Experience Level'),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select your experience level';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField(
                  value: _selectedEducation,
                  items: _educationLevels.map((level) {
                    return DropdownMenuItem(
                      value: level,
                      child: Text(level),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedEducation = value;
                    });
                  },
                  decoration:
                      const InputDecoration(labelText: 'Education Level'),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select your education level';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print('Form submitted');
                      print('Name: ${_nameController.text}');
                      print('Email: ${_emailController.text}');
                      print('Phone: ${_phoneController.text}');
                      print('Address: ${_addressController.text}');
                      print('Position: $_selectedPosition');
                      print('Experience: $_selectedExperience');
                      print('Education: $_selectedEducation');
                      print('Resume: $_uploadedResume');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (a) => ResumeDisplay(
                                    name: _nameController.text,
                                    email: _emailController.text,
                                    phone: _phoneController.text,
                                    address: _addressController.text,
                                    position: _selectedPosition.toString(),
                                    experience: _selectedExperience.toString(),
                                    education: _selectedEducation.toString(),
                                    resume: _uploadedResume.toString(),
                                  )));
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
