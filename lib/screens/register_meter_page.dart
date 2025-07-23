import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class RegisterMeterPage extends StatefulWidget {
  @override
  _RegisterMeterPageState createState() => _RegisterMeterPageState();
}

class _RegisterMeterPageState extends State<RegisterMeterPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _meterController = TextEditingController();
  final TextEditingController _mruController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _buildingController = TextEditingController();
  final TextEditingController _ticketController = TextEditingController();

  // Variables for location and image
  String _currentLocation = "Not captured yet";
  File? _selectedImage;

  // Get current location
  Future<void> _getCurrentLocation() async {
    Location location = Location();
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    LocationData locationData = await location.getLocation();
    setState(() {
      _currentLocation =
          "Lat: ${locationData.latitude}, Lon: ${locationData.longitude}";
    });
  }

  // Pick an image from the camera
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  // Handle form submission
  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload a picture')),
        );
        return;
      }

      print("Meter Number: ${_meterController.text}");
      print("MRU: ${_mruController.text}");
      print("Street: ${_streetController.text}");
      print("Building: ${_buildingController.text}");
      print("Ticket: ${_ticketController.text}");
      print("Location: $_currentLocation");
      print("Image Path: ${_selectedImage!.path}");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meter registered successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register New Meter'),
        backgroundColor: const Color(0xFFD21F20),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFE5E5), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: SingleChildScrollView(
          child: Card(
            elevation: 6,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Form fields
                    _buildTextField(
                        controller: _meterController,
                        label: 'Meter Number',
                        hint: 'Enter meter number'),
                    _buildTextField(
                        controller: _mruController,
                        label: 'MRU Number',
                        hint: 'Enter MRU number'),
                    _buildTextField(
                        controller: _streetController,
                        label: 'Street Name',
                        hint: 'Enter street name'),
                    _buildTextField(
                        controller: _buildingController,
                        label: 'Building Number',
                        hint: 'Enter building number'),
                    _buildTextField(
                        controller: _ticketController,
                        label: 'Ticket Number',
                        hint: 'Enter ticket number'),

                    const SizedBox(height: 16),

                    // Current location field with button
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Current Location',
                              hintText: _currentLocation,
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.location_on,
                              color: Color(0xFFD21F20)),
                          onPressed: _getCurrentLocation,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Image upload section
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD21F20),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.camera_alt, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(
                              _selectedImage == null
                                  ? 'Upload Image'
                                  : 'Change Image',
                              style:
                                  GoogleFonts.poppins(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (_selectedImage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(_selectedImage!, height: 150),
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD21F20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Submit',
                          style: GoogleFonts.poppins(
                              fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String label,
      String? hint}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'Please enter $label' : null,
      ),
    );
  }
}
