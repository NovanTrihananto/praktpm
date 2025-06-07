import 'package:flutter/material.dart';
import '../service/kursus_service.dart';

class AddCoursePage extends StatefulWidget {
  const AddCoursePage({super.key});

  @override
  State<AddCoursePage> createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  final KursusService kursusService = KursusService();

  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _guruController = TextEditingController();
  final TextEditingController _waktuController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _imgController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _kategoriController = TextEditingController();

  Future<void> _tambahKursus() async {
    final judul = _judulController.text;
    final guru = _guruController.text;
    final waktu = int.tryParse(_waktuController.text) ?? 0;
    final harga = int.tryParse(_hargaController.text) ?? 0;
    final img = _imgController.text;
    final deskripsi = _deskripsiController.text;
    final kategori = _kategoriController.text;

    if (judul.isEmpty ||
        guru.isEmpty ||
        waktu <= 0 ||
        harga <= 0 ||
        kategori.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul, Guru, Waktu, Harga, dan Kategori harus diisi dengan benar')),
      );
      return;
    }

    try {
      await kursusService.createKursus({
        'Judul': judul,
        'Guru': guru,
        'Waktu': waktu,
        'harga': harga,
        'Img': img.isEmpty ? null : img,
        'Deskripsi': deskripsi.isEmpty ? null : deskripsi,
        'Kategori': kategori,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kursus berhasil ditambahkan')),
      );

      Navigator.pop(context, true); // kembali ke halaman daftar kursus, bawa info sudah tambah
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan kursus: $e')),
      );
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    _guruController.dispose();
    _waktuController.dispose();
    _hargaController.dispose();
    _imgController.dispose();
    _deskripsiController.dispose();
    _kategoriController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Kursus')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _judulController,
              decoration: const InputDecoration(labelText: 'Judul Kursus'),
            ),
            TextField(
              controller: _guruController,
              decoration: const InputDecoration(labelText: 'Guru'),
            ),
            TextField(
              controller: _waktuController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Waktu (jam)'),
            ),
            TextField(
              controller: _hargaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Harga'),
            ),
            TextField(
              controller: _imgController,
              decoration: const InputDecoration(labelText: 'URL Gambar'),
            ),
            TextField(
              controller: _deskripsiController,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
            ),
            TextField(
              controller: _kategoriController,
              decoration: const InputDecoration(labelText: 'Kategori'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _tambahKursus,
              child: const Text('Tambah Kursus'),
            ),
          ],
        ),
      ),
    );
  }
}
