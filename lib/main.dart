import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/login_screen.dart';

void main() async {
  await Hive.initFlutter();
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meter Reading App',
      theme: ThemeData(primarySwatch: Colors.blue),
       debugShowCheckedModeBanner: false, 
      home: LoginScreen(),
    );
  }
}
