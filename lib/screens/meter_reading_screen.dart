import 'package:flutter/material.dart';
import 'package:meter_reading_app/services/api_service.dart';

class MeterReadingScreen extends StatelessWidget {
  final String token;
  final Map<String, dynamic> meter;

  final _currentReadingController = TextEditingController();
  final _notesController = TextEditingController();

  MeterReadingScreen({required this.token, required this.meter});

  void submitReading(BuildContext context) async {
    final data = {
      'assignment_id': meter['assignment_id'],
      'current_reading': _currentReadingController.text,
      'consumption': (double.parse(_currentReadingController.text) -
              double.parse(meter['PreviousReading']))
          .toString(),
      'notes': _notesController.text,
    };
    final success = await ApiService.submitReading(token, data);
    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting reading')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Meter Reading')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Meter Serial: ${meter['SerialNo']}'),
            TextField(
              controller: _currentReadingController,
              decoration: InputDecoration(labelText: 'Current Reading'),
            ),
            TextField(
              controller: _notesController,
              decoration: InputDecoration(labelText: 'Notes'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => submitReading(context),
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
