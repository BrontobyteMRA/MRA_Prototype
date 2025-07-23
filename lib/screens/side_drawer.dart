import 'package:flutter/material.dart';
import 'meter_list_screen.dart';
import 'login_screen.dart';
import 'register_meter_page.dart';
import 'help_and_support_page.dart';
import 'my_profile.dart';

class SideDrawer extends StatelessWidget {
  final String token;

  const SideDrawer({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 255, 200, 200), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // User details section with wrapped logo as background
            Container(
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image:
                      AssetImage('assets/bbfullogo.png'), // Logo as background
                  fit: BoxFit.cover, // Ensure the image fits the entire section
                  alignment: Alignment.center,
                ),
              ),
              child: Container(
                color: Colors.black.withOpacity(0.5), // Overlay for readability
                child: const Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Mubashir Hussain',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'mub@example.com',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Drawer items
            _buildDrawerItem(
              icon: Icons.person,
              text: 'My Profile',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyProfilePage(
                      name: "Mubashir Hussain",
                      email: "mub@example.com",
                      phoneNumber: "+91 8106967613",
                      employeeId: "EMP12345",
                      department: "Meter Reading",
                      address: "1-2-4/11 Banjara Hills, 500002",
                    ),
                  ),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.speed,
              text: 'View All Meters',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MeterListScreen(token: token),
                  ),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.add_circle_outline,
              text: 'Register New Meter',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterMeterPage()),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.help_outline,
              text: 'Help & Support',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HelpAndSupportPage(),
                  ),
                );
              },
            ),
            const Divider(),
            _buildDrawerItem(
              icon: Icons.logout,
              text: 'Logout',
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required GestureTapCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color.fromARGB(255, 102, 18, 18),
      ),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
