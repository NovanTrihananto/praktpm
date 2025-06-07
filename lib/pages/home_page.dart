import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tpmteori/pages/admin_course_page.dart';
import 'package:tpmteori/pages/user_management_page.dart';
import 'login_page.dart';
import 'profil_page.dart';

class MainPage extends StatefulWidget {
  final Map<String, dynamic> user;

  const MainPage({super.key, required this.user});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

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
    final role = widget.user['role'];

    final adminPages = [
      _buildAdminDashboard(),
      ProfilePage(user: widget.user), // pakai ProfilePage dengan fitur gambar
    ];

    final userPages = [
      _buildUserDashboard(),
      ProfilePage(user: widget.user), // sama untuk user
    ];

    final pages = role == 'admin' ? adminPages : userPages;

    return Scaffold(
      appBar: AppBar(
        title: Text(role == 'admin' ? 'Admin Dashboard' : 'User Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => handleLogout(context),
          ),
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  Widget _buildAdminDashboard() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Selamat datang, Admin ${widget.user['name']}!",
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserManagementPage(),
                ),
              );
            },
            child: const Text("Kelola User"),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminCoursesPage(),
                ),
              );
            },
            child: const Text("Kelola Kursus"),
          ),
        ],
      ),
    );
  }

  Widget _buildUserDashboard() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Halo, ${widget.user['name']} 👋",
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navigasi ke daftar kursus
            },
            child: const Text("Lihat Semua Kursus"),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Navigasi ke kursus yang diikuti
            },
            child: const Text("Kursus yang Diikuti"),
          ),
        ],
      ),
    );
  }
}
