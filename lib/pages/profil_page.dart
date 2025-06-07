import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import '../pages/login_page.dart';

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic> user;

  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Uint8List? imageBytes;

  @override
  void initState() {
    super.initState();
    loadProfileImage();
  }

  Future<void> loadProfileImage() async {
    final box = await Hive.openBox('profileBox');
    final data = box.get('profileImage_${widget.user['id']}');
    if (data != null && data is Uint8List) {
      setState(() {
        imageBytes = data;
      });
    }
  }

  Future<void> saveProfileImage(Uint8List bytes) async {
    final box = await Hive.openBox('profileBox');
    await box.put('profileImage_${widget.user['id']}', bytes);
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      await saveProfileImage(bytes);
      setState(() {
        imageBytes = bytes;
      });
    }
  }

  Future<void> handleLogout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        imageBytes != null
            ? CircleAvatar(
                radius: 60,
                backgroundImage: MemoryImage(imageBytes!),
              )
            : CircleAvatar(
                radius: 60,
                child: Icon(Icons.person, size: 40),
              ),
        SizedBox(height: 10),
        TextButton.icon(
          icon: Icon(Icons.camera_alt),
          label: Text("Ganti Foto Profil"),
          onPressed: pickImage,
        ),
        SizedBox(height: 20),
        Text('Nama: ${widget.user['name']}'),
        Text('Email: ${widget.user['email']}'),
        Text('Role: ${widget.user['role']}'),
        SizedBox(height: 20),
        ElevatedButton.icon(
          icon: Icon(Icons.logout),
          label: Text('Logout'),
          onPressed: () => handleLogout(context),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        ),
      ],
    );
  }
}
