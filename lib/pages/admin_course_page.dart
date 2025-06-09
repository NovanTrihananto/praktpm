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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat kursus: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _hapusKursus(int id, String judul) async {
    try {
      await kursusService.deleteKursus(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Kursus berhasil dihapus'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
      _loadKursus();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghapus kursus: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  void _bukaTambahKursus() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCoursePage(),
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

  void _showDeleteConfirmation(Map<String, dynamic> kursus) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_rounded, color: Colors.orange, size: 24),
            const SizedBox(width: 8),
            const Text(
              "Konfirmasi Hapus",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Apakah Anda yakin ingin menghapus kursus ini?",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: kursus['Img'] != null
                        ? Image.network(
                            kursus['Img'],
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              width: 40,
                              height: 40,
                              color: Colors.grey[300],
                              child: Icon(Icons.image_not_supported, 
                                       color: Colors.grey[600], size: 20),
                            ),
                          )
                        : Container(
                            width: 40,
                            height: 40,
                            color: Colors.grey[300],
                            child: Icon(Icons.school_rounded, 
                                     color: Colors.grey[600], size: 20),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          kursus['Judul'] ?? 'Tidak ada judul',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Oleh: ${kursus['Guru'] ?? 'Guru tidak diketahui'}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text(
              "Batal",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _hapusKursus(kursus['id'], kursus['Judul'] ?? '');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text(
              "Hapus",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String? kategori) {
    switch (kategori?.toLowerCase()) {
      case 'programming':
        return Colors.blue;
      case 'design':
        return Colors.purple;
      case 'business':
        return Colors.green;
      case 'marketing':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: const Text(
          'Kelola Kursus',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              onPressed: _bukaTambahKursus,
              icon: const Icon(Icons.add_rounded, size: 20),
              label: const Text(
                'Tambah',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      "Memuat data kursus...",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
            : kursusList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.school_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Belum ada kursus",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Mulai dengan menambahkan kursus pertama",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _bukaTambahKursus,
                          icon: const Icon(Icons.add_rounded),
                          label: const Text('Tambah Kursus'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: kursusList.length,
                    itemBuilder: (context, index) {
                      final kursus = kursusList[index];
                      final kategori = kursus['Kategori'];
                      
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              // Course Image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: kursus['Img'] != null
                                    ? Image.network(
                                        kursus['Img'],
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                            Container(
                                          width: 80,
                                          height: 80,
                                          color: Colors.grey[200],
                                          child: Icon(
                                            Icons.image_not_supported_rounded,
                                            color: Colors.grey[400],
                                            size: 32,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.blue[50],
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          Icons.school_rounded,
                                          color: Colors.blue[300],
                                          size: 32,
                                        ),
                                      ),
                              ),
                              
                              const SizedBox(width: 16),
                              
                              // Course Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      kursus['Judul'] ?? 'Tidak ada judul',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    
                                    const SizedBox(height: 6),
                                    
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.person_rounded,
                                          size: 16,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            kursus['Guru'] ?? 'Guru tidak diketahui',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.w500,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    
                                    const SizedBox(height: 8),
                                    
                                    if (kategori != null && kategori.isNotEmpty)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getCategoryColor(kategori).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(
                                            color: _getCategoryColor(kategori).withOpacity(0.3),
                                          ),
                                        ),
                                        child: Text(
                                          kategori,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: _getCategoryColor(kategori),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              
                              const SizedBox(width: 12),
                              
                              // Action Buttons
                              Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue[50],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.edit_rounded,
                                        color: Colors.blue[600],
                                        size: 20,
                                      ),
                                      onPressed: () => _bukaEditKursus(kursus),
                                      tooltip: 'Edit Kursus',
                                      style: IconButton.styleFrom(
                                        padding: const EdgeInsets.all(8),
                                      ),
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 8),
                                  
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red[50],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.delete_rounded,
                                        color: Colors.red[600],
                                        size: 20,
                                      ),
                                      onPressed: () => _showDeleteConfirmation(kursus),
                                      tooltip: 'Hapus Kursus',
                                      style: IconButton.styleFrom(
                                        padding: const EdgeInsets.all(8),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}