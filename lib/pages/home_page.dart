import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tpmteori/pages/course_screen.dart';
import 'package:tpmteori/pages/home_screen.dart';
import 'package:tpmteori/pages/ikutkursus_page.dart';
import 'login_page.dart';
import 'dart:async';
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

  late DateTime _currentTime;
  Timer? _timer;
  String _selectedZone = 'WIB';

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> handleLogout(BuildContext c) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (c) => LoginPage()),
    );
  }

  String getFormattedTime() {
    int offsetHours = 0;
    switch (_selectedZone) {
      case 'WITA':
        offsetHours = 1;
        break;
      case 'WIT':
        offsetHours = 2;
        break;
      case 'London':
        offsetHours = -6;
        break;
      case 'WIB':
      default:
        offsetHours = 0;
    }

    final adjustedTime = _currentTime.add(Duration(hours: offsetHours));
    final h = adjustedTime.hour.toString().padLeft(2, '0');
    final m = adjustedTime.minute.toString().padLeft(2, '0');
    final s = adjustedTime.second.toString().padLeft(2, '0');
    return "$h:$m:$s $_selectedZone";
  }

  @override
  Widget build(BuildContext ctx) {
    final role = widget.user['role'];
    final userId = int.tryParse(widget.user['id'].toString()) ?? 0;

    final pages = <Widget>[
      role == 'admin' ? _buildAdminDashboard() : HomeScreen(user: widget.user),
      CoursesScreen(userId: userId),
      ProfilePage(user: widget.user),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(role == 'admin' ? 'Admin Dashboard' : 'Kursus Online'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Row(
                children: [
                  Text(
                    getFormattedTime(),
                    style: const TextStyle(fontSize: 14, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  const SizedBox(width: 8),
                  DropdownButton<String>(
                    value: _selectedZone,
                    dropdownColor: const Color.fromARGB(255, 0, 0, 0),
                    underline: const SizedBox(),
                    style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 14),
                    iconEnabledColor: const Color.fromARGB(255, 255, 255, 255),
                    items: ['WIB', 'WITA', 'WIT', 'London']
                        .map((zone) => DropdownMenuItem(
                              value: zone,
                              child: Text(zone),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedZone = value;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => handleLogout(ctx),
          ),
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
          Text(
            "Selamat datang, Admin ${widget.user['name']}!",
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const UserManagementPage()),
            ),
            child: const Text("Kelola User"),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AdminCoursesPage()),
            ),
            child: const Text("Kelola Kursus"),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const IkutKursusAdminPage()),
            ),
            child: const Text("Kelola Pendaftaran Kursus"),
          ),
        ],
      ),
    );
  }
}
