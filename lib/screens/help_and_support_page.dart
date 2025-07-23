import 'package:flutter/material.dart';
import 'report_issue_page.dart';

class HelpAndSupportPage extends StatelessWidget {
  const HelpAndSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help and Support'),
        backgroundColor: const Color.fromARGB(255, 206, 27, 32),
         foregroundColor: Color.fromARGB(236, 246, 244, 244),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Introduction Text
            const Text(
              'Welcome to Help and Support',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'We are here to assist you with any issues or questions regarding your meter reading application. Please find below some common FAQs, or feel free to contact us for further assistance.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // FAQ Section
            const Text(
              'Frequently Asked Questions (FAQ)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // FAQ 1
            const ExpansionTile(
              title: Text('How do I submit a meter reading?'),
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'To submit a meter reading, enter your current reading in the "Current Reading" field and tap "Submit." Make sure your reading is accurate and select any relevant notes if necessary.',
                  ),
                ),
              ],
            ),

            // FAQ 2
            const ExpansionTile(
              title: Text('What if I encounter an issue with my meter?'),
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'If you encounter any issues with your meter, such as malfunction, missing meter, or suspicious behavior, please use the "MR Notes" section to specify the issue and submit it.',
                  ),
                ),
              ],
            ),

            // FAQ 3
            const ExpansionTile(
              title: Text('How do I reset my password?'),
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'To reset your password, visit the login page, click on "Forgot Password", and follow the instructions sent to your registered email.',
                  ),
                ),
              ],
            ),

            // FAQ 4
            const ExpansionTile(
              title: Text('How can I upload an image for the meter?'),
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'To upload an image of your meter, click the "Upload Image" button in the meter registration form, and take a photo using your device’s camera.',
                  ),
                ),
              ],
            ),

            // Contact Us Section
            const SizedBox(height: 20),
            const Text(
              'Contact Us',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'If you need further assistance, feel free to contact us through any of the following channels:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Email: mra@brontobyte.in',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              'Phone: +91 8106967613',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Report an Issue Button
            // Inside the Help and Support page
            ElevatedButton(
              onPressed: () {
                // Navigate to the Report an Issue page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReportIssuePage()),
                );
              },
              child: const Text('Report an Issue'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 206, 27, 32),
                foregroundColor: Color.fromARGB(236, 246, 244, 244),
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
