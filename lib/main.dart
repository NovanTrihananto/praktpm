import 'package:flutter/material.dart';
import 'package:tpmteori/pages/splash_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // Hive init untuk Flutter
  await Hive.openBox('profileBox');
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

