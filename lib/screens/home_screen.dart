import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // For date formatting
import 'meter_list_screen.dart';
import 'side_drawer.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  final String token;

  const HomeScreen({super.key, required this.token});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pendingOrders = 0;
  int completedOrders = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrderCounts();
    sendUserLocation();
  }

  Future<void> fetchOrderCounts() async {
    try {
      setState(() {
        isLoading = true; // Start loading when refreshing
      });

      final response = await http.get(
        Uri.parse('https://mra3.onebrain.me/api/get_assigned_meters.php'),
        headers: {'Authorization': 'Bearer ${widget.token}'}, // Add token if required
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Check if the status is success
        if (data['status'] == 'success') {
          final List<dynamic> orders = data['data'];

          int pending = 0;
          int completed = 0;

          // Loop through the orders and count the statuses
          for (var order in orders) {
            if (order['status'] == 'pending') {
              pending++;
            } else if (order['status'] == 'completed') {
              completed++;
            }
          }

          // Update the state with the counts
          if (mounted) {
            setState(() {
              pendingOrders = pending;
              completedOrders = completed;
              isLoading = false;
            });
          }
        } else {
          _showSnackBar('Failed to fetch data. Status not "success".');
          setState(() => isLoading = false);
        }
      } else {
        _showSnackBar('Failed to fetch order counts. Please try again.');
        setState(() => isLoading = false);
      }
    } catch (e) {
      _showSnackBar('Error: $e');
      setState(() => isLoading = false);
    }
  }

  // New function to send user location as JSON
  Future<void> sendUserLocation() async {
    try {
      // Example user location data
      String userId = "123";
      String latitude = "111.123";
      String longitude = "905.555";

      // Prepare JSON data
      Map<String, String> userLocation = {
        'user_id': userId,
        'latitude': latitude,
        'longitude': longitude,
      };

      // Send POST request with JSON data
      final response = await http.post(
        Uri.parse('https://mra3.onebrain.me/api/user_location.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userLocation),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          _showSnackBar('Location updated successfully!');
        } else {
          _showSnackBar('Failed to update location.');
        }
      } else {
        _showSnackBar('Failed to send location. Please try again.');
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get current date and day
    String formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 206, 27, 32),
        foregroundColor: Color.fromARGB(255, 255, 255, 255),
        centerTitle: true,
        title: const Text(
          "Home",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchOrderCounts, // Refresh button action
          ),
        ],
      ),
      drawer: SideDrawer(token: widget.token),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 255, 200, 200), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      // Display Date and Day
                      Center(
                        child: Text(
                          formattedDate,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          _buildOrderCard(
                            title: "Pending Orders",
                            count: pendingOrders,
                            color: const Color.fromARGB(255, 206, 27, 32),
                            icon: Icons.pending_actions,
                          ),
                          const SizedBox(width: 16),
                          _buildOrderCard(
                            title: "Completed Orders",
                            count: completedOrders,
                            color: const Color.fromARGB(255, 50, 205, 50),
                            icon: Icons.check_circle,
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MeterListScreen(token: widget.token),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 206, 27, 32),
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'View All Meters',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildOrderCard({
    required String title,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return Expanded(
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
