import 'dart:async'; // Import the Timer class
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'meter_detail_screen.dart'; // Import the MeterDetailsScreen

class MeterListScreen extends StatefulWidget {
  final String token;

  const MeterListScreen({Key? key, required this.token}) : super(key: key);

  @override
  _MeterListScreenState createState() => _MeterListScreenState();
}

class _MeterListScreenState extends State<MeterListScreen> {
  late List<Map<String, dynamic>> meters = [];
  List<Map<String, dynamic>> filteredMeters = [];
  final TextEditingController _searchController = TextEditingController();
  Timer? _timer; // Declare a timer variable

  @override
  void initState() {
    super.initState();
    _fetchMeters();
    // Set up a timer to call _fetchMeters every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      _fetchMeters();
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchMeters() async {
    final response = await http.get(
      Uri.parse('https://mra3.onebrain.me/api/get_assigned_meters.php'),
      headers: {
        'Authorization': 'Bearer ${widget.token}', // Pass token in header
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> metersData = data['data'];

      // Filter only meters with status 'pending'
      setState(() {
        meters = List<Map<String, dynamic>>.from(
            metersData.where((meter) => meter['status'] == 'pending'));
        filteredMeters = meters;
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to load meters')));
      }
    }
  }

  void _filterMeters(String query) {
    final results = meters
        .where((meter) => meter['AccountName']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();
    setState(() {
      filteredMeters = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assigned Meters'),
        backgroundColor: Color.fromARGB(255, 206, 27, 32),
        foregroundColor: Color.fromARGB(255, 255, 255, 255),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchMeters,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 255, 200, 200), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by account name...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onChanged: _filterMeters,
              ),
            ),
            Expanded(
              child: filteredMeters.isEmpty
                  ? Center(
                      child: Text(
                        'No pending meters',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredMeters.length,
                      itemBuilder: (context, index) {
                        final meter = filteredMeters[index];
                        return Card(
                          margin: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4.0,
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.electric_meter_outlined,
                                        color: Colors.blue),
                                    SizedBox(width: 8),
                                    Text(
                                      'Name: ${meter['AccountName']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Account Number ${meter['AccountNum']}',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Assigned Date: ${meter['assigned_date']}',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Status: ${meter['status']}',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Previous Reading: ${meter['PreviousReading']}',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Address: ${meter['Address']}',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'CA: ${meter['CA']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Navigate to the MeterDetailsScreen and pass meter data
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MeterDetailsScreen(
                                              token: widget.token,
                                              meter: meter,
                                            ),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color.fromARGB(255, 209, 31, 31),
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 12),
                                        textStyle: const TextStyle(fontSize: 16),
                                      ),
                                      child: Text('ACCESS >'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
