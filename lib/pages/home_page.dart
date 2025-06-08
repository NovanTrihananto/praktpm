import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tpmteori/pages/course_screen.dart';
import 'package:tpmteori/pages/home_screen.dart';
import 'login_page.dart';
import 'profil_page.dart';
import 'user_management_page.dart';
import 'admin_course_page.dart';

class MainPage extends StatefulWidget {
  final Map<String, dynamic> user;
  const MainPage({super.key, required this.user});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  Future<void> handleLogout(BuildContext c) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (c) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext ctx) {
    final role = widget.user['role'];

    // Tambahkan halaman untuk daftar kursus
    final pages = <Widget>[
      role == 'admin' ? _buildAdminDashboard() : HomeScreen(user: widget.user),
      CoursesScreen(), // halaman baru untuk daftar kursus
      ProfilePage(user: widget.user),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(role == 'admin' ? 'Admin Dashboard' : 'Kursus Online'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => handleLogout(ctx),
          )
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Kursus'),
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
          Text("Selamat datang, Admin ${widget.user['name']}!", style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UserManagementPage())),
            child: const Text("Kelola User"),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminCoursesPage())),
            child: const Text("Kelola Kursus"),
          ),
        ],
      ),
    );
  }
}
