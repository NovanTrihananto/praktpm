import 'package:flutter/material.dart';
import '../service/user_service.dart';

class EditUserPage extends StatefulWidget {
  final Map<String, dynamic> user;
  final VoidCallback onUserUpdated;

  const EditUserPage({super.key, required this.user, required this.onUserUpdated});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController genderController;
  String selectedRole = 'user';

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user['name']);
    emailController = TextEditingController(text: widget.user['email']);
    genderController = TextEditingController(text: widget.user['gender']);
    selectedRole = widget.user['role'] ?? 'user';
  }

  Future<void> handleUpdate() async {
    try {
      await UserService.updateUser(
        id: widget.user['id'].toString(),
        name: nameController.text,
        email: emailController.text,
        gender: genderController.text,
        role: selectedRole,
      );
      widget.onUserUpdated(); // Callback untuk refresh
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal update: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit User")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Nama")),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: genderController, decoration: const InputDecoration(labelText: "Gender")),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedRole,
              items: ['admin', 'user'].map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
              onChanged: (val) => setState(() => selectedRole = val!),
              decoration: const InputDecoration(labelText: "Role"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleUpdate,
              child: const Text("Simpan Perubahan"),
            ),
          ],
        ),
      ),
    );
  }
}
