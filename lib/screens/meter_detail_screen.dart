import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class MeterDetailsScreen extends StatefulWidget {
  final String token;
  final Map<String, dynamic> meter;

  const MeterDetailsScreen({Key? key, required this.token, required this.meter})
      : super(key: key);

  @override
  _MeterDetailsScreenState createState() => _MeterDetailsScreenState();
}

class _MeterDetailsScreenState extends State<MeterDetailsScreen> {
  final TextEditingController _notesController = TextEditingController();
  String _currentReading = '';
  String _consumption = '0.00';
  late double _previousReading;
  List<String> _options = [];
  String? _selectedOption;
  int Predecimals = 3;
  int Postdecimals = 2;

  File? _image;
  bool _imageCaptured = false;

  List<FocusNode> _focusNodes = [];
  List<TextEditingController> _controllers = [];

  Future<void> fetchDropdownOptions() async {
    final response =
        await http.get(Uri.parse('https://mra3.onebrain.me/api/MrNotes.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _options = List<String>.from(data['data']);
        _selectedOption = _options.isNotEmpty ? _options[0] : null;
      });
    } else {
      throw Exception('Failed to load dropdown options');
    }
  }

  @override
  void initState() {
    super.initState();
    _previousReading =
        double.tryParse(widget.meter['PreviousReading'] ?? '0') ?? 0.0;
    Predecimals = widget.meter['Predecimals'] ?? 3;
    Postdecimals = widget.meter['Postdecimals'] ?? 2;

    fetchDropdownOptions().catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading dropdown options: $error')),
      );
    });

    _focusNodes = List.generate(Predecimals + Postdecimals, (index) => FocusNode());
    _controllers = List.generate(Predecimals + Postdecimals, (index) => TextEditingController());
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitReading() async {
    final String currentReading = _buildCurrentReading();
    double currentReadingValue = double.tryParse(currentReading) ?? 0.0;
    final String? resettable = widget.meter['Resettable'];

    if ((resettable == '02' || resettable == '05') &&
        currentReadingValue <= _previousReading) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Invalid Reading'),
          content: const Text('Current reading cannot be less than previous reading.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    double consumptionValue = currentReadingValue - _previousReading;
    _consumption = consumptionValue.toStringAsFixed(Postdecimals);

    final String notes = _notesController.text;
    final String mrNotes = _selectedOption ?? '';

    if (currentReading.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid reading')));
      return;
    }

    final response = await http.post(
      Uri.parse('https://mra3.onebrain.me/api/submit_reading.php'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'assignment_id': widget.meter['assignment_id'],
        'AccountNum': widget.meter['AccountNum'],
        'current_reading': currentReading,
        'consumption': _consumption,
        'Notes': notes,
        'MrNotes': mrNotes,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reading submitted successfully!')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit reading')));
    }
  }

  void _onFieldChanged(int index, String value) {
    setState(() {
      _currentReading = _buildCurrentReading();
      double currentReadingValue = double.tryParse(_currentReading) ?? 0.0;
      String resettable = widget.meter['Resettable'] ?? '';
      double billFactor = double.tryParse(widget.meter['BillFactor'] ?? '1') ?? 1.0;

      if (resettable == '02' || resettable == '05') {
        _consumption = ((currentReadingValue - _previousReading) * billFactor)
            .toStringAsFixed(Postdecimals);
      } else {
        _consumption = (currentReadingValue * billFactor).toStringAsFixed(Postdecimals);
      }
    });

    if (value.isNotEmpty && index < _focusNodes.length - 1) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  String _buildCurrentReading() {
    final preDecimal = List.generate(Predecimals, (index) {
      return _controllers[index].text.isEmpty ? '' : _controllers[index].text;
    }).join('');
    final postDecimal = List.generate(Postdecimals, (index) {
      return _controllers[Predecimals + index].text.isEmpty
          ? ''
          : _controllers[Predecimals + index].text;
    }).join('');
    return preDecimal.isNotEmpty || postDecimal.isNotEmpty ? '$preDecimal.$postDecimal' : '';
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _imageCaptured = true;
      });
      await _processImageForOCR(_image!);
    }
  }

  Future<void> _processImageForOCR(File image) async {
    final inputImage = InputImage.fromFile(image);
    final textRecognizer = GoogleMlKit.vision.textRecognizer();
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    // Debugging: Print all recognized text
    String allText = recognizedText.text;
    print('All recognized text: $allText');

    String meterReading = '';
    double largestArea = -1;

    // Regex to match numbers (with or without decimals)
    final RegExp numberRegex = RegExp(r'(\d+\.?\d*)');

    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        final text = line.text.trim();
        print('Detected line: $text'); // Debug output
        final matches = numberRegex.allMatches(text);
        for (var match in matches) {
          final numberStr = match.group(0)!;
          final double? value = double.tryParse(numberStr);
          if (value != null) {
            // Calculate the area of the bounding box
            final rect = line.boundingBox;
            final area = (rect.width * rect.height).toDouble();
            print('Number: $numberStr, Area: $area'); // Debug bounding box size

            if (area > largestArea) {
              largestArea = area;
              meterReading = numberStr;
            }
          }
        }
      }
    }

    if (meterReading.isNotEmpty) {
      print('Selected meter reading: $meterReading (Area: $largestArea)');
      _populateReadingFields(meterReading);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No valid meter reading found. Detected text: "$allText"')),
      );
    }

    await textRecognizer.close();
  }

  void _populateReadingFields(String number) {
    final parts = number.split('.');
    final preDecimal = parts[0].padLeft(Predecimals, '0'); // Pad with leading zeros if needed
    final postDecimal = parts.length > 1 ? parts[1].padRight(Postdecimals, '0') : '0' * Postdecimals;

    setState(() {
      // Populate pre-decimal fields (right-aligned)
      for (int i = 0; i < Predecimals; i++) {
        int charIndex = preDecimal.length - (Predecimals - i);
        _controllers[i].text = charIndex >= 0 ? preDecimal[charIndex] : '0';
      }
      // Populate post-decimal fields
      for (int i = 0; i < Postdecimals; i++) {
        _controllers[Predecimals + i].text = i < postDecimal.length ? postDecimal[i] : '0';
      }
      _currentReading = _buildCurrentReading();
      _onFieldChanged(0, _controllers[0].text); // Trigger consumption update
    });
  }

  void _acceptImage() {
    setState(() {
      _imageCaptured = false;
    });
  }

  void _rejectImage() {
    setState(() {
      _image = null;
      _imageCaptured = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meter Details'),
        backgroundColor: const Color(0xFFd02a26),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Account Number: ${widget.meter['AccountNum']}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black)),
                      const SizedBox(height: 8),
                      Text('Account Name: ${widget.meter['AccountName']}',
                          style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                      const SizedBox(height: 8),
                      Text('Address: ${widget.meter['Address']}',
                          style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                      const SizedBox(height: 8),
                      Text('Previous Reading: ${widget.meter['PreviousReading']}',
                          style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                      const SizedBox(height: 8),
                      Text('MeterType: ${widget.meter['MeterType']}',
                          style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                      const SizedBox(height: 10),
                      Text('Status: ${widget.meter['status']}',
                          style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                      const SizedBox(height: 10),
                      Text('Assigned Date: ${widget.meter['assigned_date']}',
                          style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                      const SizedBox(height: 10),
                      Text('Schmr Date: ${widget.meter['SchmrDate']}',
                          style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: IconButton(
                  icon: const Icon(Icons.camera_alt, size: 40, color: Color.fromARGB(255, 145, 6, 15)),
                  onPressed: _pickImage,
                ),
              ),
              const SizedBox(height: 20),
              if (_imageCaptured)
                Column(
                  children: [
                    Image.file(_image!),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: _acceptImage,
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: _rejectImage,
                        ),
                      ],
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Current Reading',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                ],
              ),
              Row(
                children: [
                  ...List.generate(Predecimals, (index) {
                    return SizedBox(
                      width: 50,
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        onChanged: (value) => _onFieldChanged(index, value),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(color: Color(0xFFd02a26), width: 2.0),
                          ),
                          hintText: '0',
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                        ),
                      ),
                    );
                  }),
                  const Text('.', style: TextStyle(fontSize: 30)),
                  ...List.generate(Postdecimals, (index) {
                    return SizedBox(
                      width: 50,
                      child: TextField(
                        controller: _controllers[Predecimals + index],
                        focusNode: _focusNodes[Predecimals + index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        onChanged: (value) => _onFieldChanged(Predecimals + index, value),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(color: Color(0xFFd02a26), width: 2.0),
                          ),
                          hintText: '0',
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                        ),
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 20),
              Text('Consumption: $_consumption',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
              const SizedBox(height: 20),
              const Text('MR Notes',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: _selectedOption,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedOption = newValue;
                  });
                },
                items: _options.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(fontSize: 16)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: 'Custom Notes (if any)',
                  labelStyle: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.all(12),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitReading,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFd02a26),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  elevation: 5,
                ),
                child: const Text(
                  'Submit Reading',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}