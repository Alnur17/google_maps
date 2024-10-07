import 'package:flutter/material.dart';
import 'package:google_maps/src/views/google_map_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Maps',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        useMaterial3: false,
      ),
      home: const GoogleMapScreen(),
    );
  }
}

