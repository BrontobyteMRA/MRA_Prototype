import 'package:flutter/material.dart';

class ReportIssuePage extends StatefulWidget {
  const ReportIssuePage({Key? key}) : super(key: key);

  @override
  _ReportIssuePageState createState() => _ReportIssuePageState();
}

class _ReportIssuePageState extends State<ReportIssuePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _issueController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  String? _selectedCategory = 'General';

  // Function to handle issue submission
  void _submitIssue() {
    if (_formKey.currentState!.validate()) {
      // Here you can implement the code to submit the issue
      // For now, we show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Issue reported successfully!')),
      );

      // Reset the form after submission
      _issueController.clear();
      _emailController.clear();
      setState(() {
        _selectedCategory = 'General';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report an Issue'),
        backgroundColor: Color.fromARGB(255, 206, 27, 32),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Issue Description Field
              TextFormField(
                controller: _issueController,
                decoration: InputDecoration(
                  labelText: 'Describe the issue',
                  hintText: 'Provide a detailed description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please describe the issue';
                  }
                  return null;
                },
                maxLines: 5,
              ),
              SizedBox(height: 20),

              // Email Address Field (Optional)
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Your Email (Optional)',
                  hintText: 'Enter your email for follow-up',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value != null && !RegExp(r"^[a-zA-Z0-9]+@([a-zA-Z0-9-]+\.)+[a-zA-Z0-9]{2,4}$").hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Issue Category Dropdown (Optional)
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Issue Category',
                  border: OutlineInputBorder(),
                ),
                items: ['General', 'Bug', 'Feature Request', 'Other']
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
              ),
              SizedBox(height: 20),

              // Submit Button
              ElevatedButton(
                onPressed: _submitIssue,
                child: Text('Submit Issue'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 206, 27, 32),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
