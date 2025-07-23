import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyProfilePage extends StatelessWidget {
  final String name;
  final String email;
  final String phoneNumber;
  final String employeeId;
  final String department;
  final String address;

  const MyProfilePage({
    Key? key,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.employeeId,
    required this.department,
    required this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 206, 27, 32),
        centerTitle: true,
        title: Text(
          "My Profile",
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 255, 220, 220), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                // Profile Avatar
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Colors.red, Color.fromARGB(255, 206, 27, 32)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.4),
                          blurRadius: 10,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.transparent,
                      child: Text(
                        name[0].toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Name
                Center(
                  child: Text(
                    name,
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 6),

                // Department
                Center(
                  child: Text(
                    department,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Profile Details
                _buildProfileDetail("Email", email),
                _buildProfileDetail("Phone Number", phoneNumber),
                _buildProfileDetail("Employee ID", employeeId),
                _buildProfileDetail("Department", department),
                _buildProfileDetail("Address", address),
              ],
            ),
          ),
        ),
      ),

      // Floating Action Button for Editing Profile
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Edit Profile button pressed!')),
          );
        },
        backgroundColor: const Color.fromARGB(255, 206, 27, 32),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  Widget _buildProfileDetail(String title, String value) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Leading Icon
            Container(
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(10),
              child: Icon(
                _getIconForTitle(title),
                size: 28,
                color: const Color.fromARGB(255, 206, 27, 32),
              ),
            ),
            const SizedBox(width: 16),

            // Text Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForTitle(String title) {
    switch (title) {
      case "Email":
        return Icons.email;
      case "Phone Number":
        return Icons.phone;
      case "Employee ID":
        return Icons.badge;
      case "Department":
        return Icons.work;
      case "Address":
        return Icons.home;
      default:
        return Icons.info;
    }
  }
}
