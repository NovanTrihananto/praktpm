import 'package:flutter/material.dart';
import 'package:tpmteori/pages/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kursus App',
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

