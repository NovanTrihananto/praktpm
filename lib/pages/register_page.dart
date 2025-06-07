import 'package:flutter/material.dart';
import '../service/auth_service.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final genderController = TextEditingController();
  final passwordController = TextEditingController();
  String errorMsg = '';

  void handleRegister() async {
    final result = await AuthService.register(
      name: nameController.text,
      email: emailController.text,
      gender: genderController.text,
      password: passwordController.text,
    );

    if (result['success']) {
      // ✅ Kembali ke halaman login setelah berhasil register
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Berhasil daftar. Silakan login.')),
      );
      Navigator.pop(context); // kembali ke LoginPage
    } else {
      setState(() {
        errorMsg = result['message'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: "Name")),
            TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: genderController, decoration: InputDecoration(labelText: "Gender (male/female)")),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
            SizedBox(height: 16),
            ElevatedButton(onPressed: handleRegister, child: Text("Register")),
            if (errorMsg.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(errorMsg, style: TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }
}
