import 'package:flutter/material.dart';
import 'package:tpmteori/pages/admin_page.dart';
import 'package:tpmteori/pages/user_page.dart';
import '../service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String errorMsg = '';

 void handleLogin() async {
  final result = await AuthService.login(
    emailController.text,
    passwordController.text,
  );

  if (result['success']) {
    final user = result['user'];
    final role = user['role'];

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', user['id'].toString());
    await prefs.setString('userName', user['name']);
    await prefs.setString('userRole', user['role']);

    if (role == 'admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminPage(user: user)),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserPage(user: user)),
      );
    }
  } else {
    setState(() {
      errorMsg = result['message'];
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
            SizedBox(height: 16),
            ElevatedButton(onPressed: handleLogin, child: Text("Login")),
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
