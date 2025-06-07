import 'package:flutter/material.dart';
import '../service/kursus_service.dart';
import 'edit_course_page.dart';
import 'addcourse_page.dart';

class AdminCoursesPage extends StatefulWidget {
  const AdminCoursesPage({super.key});

  @override
  State<AdminCoursesPage> createState() => _AdminCoursesPageState();
}

class _AdminCoursesPageState extends State<AdminCoursesPage> {
  final KursusService kursusService = KursusService();

  List<dynamic> kursusList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadKursus();
  }

  Future<void> _loadKursus() async {
    setState(() => isLoading = true);
    try {
      final data = await kursusService.fetchKursus();
      setState(() {
        kursusList = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat kursus: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _hapusKursus(int id) async {
    try {
      await kursusService.deleteKursus(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kursus berhasil dihapus')),
      );
      _loadKursus();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus kursus: $e')),
      );
    }
  }

  void _bukaTambahKursus() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCoursePage (),
      ),
    ).then((value) {
      if (value == true) {
        _loadKursus();
      }
    });
  }

  void _bukaEditKursus(Map<String, dynamic> kursus) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCoursePage(kursus: kursus),
      ),
    ).then((value) {
      if (value == true) {
        _loadKursus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Kursus'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _bukaTambahKursus,
            tooltip: 'Tambah Kursus',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : kursusList.isEmpty
                ? const Center(child: Text('Belum ada kursus'))
                : ListView.builder(
                    itemCount: kursusList.length,
                    itemBuilder: (context, index) {
                      final kursus = kursusList[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: kursus['Img'] != null
                              ? Image.network(
                                  kursus['Img'],
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image),
                                )
                              : const SizedBox(width: 50, height: 50),
                          title: Text(kursus['Judul'] ?? 'Tidak ada judul'),
                          subtitle: Text(
                              '${kursus['Guru'] ?? 'Guru tidak diketahui'} | Kategori: ${kursus['Kategori'] ?? '-'}'),
                          trailing: SizedBox(
                            width: 110,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _bukaEditKursus(kursus),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: const Text('Konfirmasi Hapus'),
                                        content: Text(
                                            'Yakin ingin menghapus kursus "${kursus['Judul']}"?'),
                                        actions: [
                                          TextButton(
                                            child: const Text('Batal'),
                                            onPressed: () => Navigator.pop(context),
                                          ),
                                          TextButton(
                                            child: const Text('Hapus'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              _hapusKursus(kursus['id']);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
