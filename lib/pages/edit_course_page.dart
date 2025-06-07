import 'package:flutter/material.dart';
import '../service/kursus_service.dart';

class EditCoursePage extends StatefulWidget {
  final Map<String, dynamic>? kursus; // null kalau tambah baru

  const EditCoursePage({super.key, this.kursus});

  @override
  State<EditCoursePage> createState() => _EditCoursePageState();
}

class _EditCoursePageState extends State<EditCoursePage> {
  final KursusService kursusService = KursusService();

  late TextEditingController _judulController;
  late TextEditingController _guruController;
  late TextEditingController _waktuController;
  late TextEditingController _hargaController;
  late TextEditingController _imgController;
  late TextEditingController _deskripsiController;
  late TextEditingController _kategoriController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    final kursus = widget.kursus;

    _judulController = TextEditingController(text: kursus?['Judul'] ?? '');
    _guruController = TextEditingController(text: kursus?['Guru'] ?? '');
    _waktuController = TextEditingController(
        text: kursus != null ? kursus!['Waktu'].toString() : '');
    _hargaController = TextEditingController(
        text: kursus != null ? kursus!['harga'].toString() : '');
    _imgController = TextEditingController(text: kursus?['Img'] ?? '');
    _deskripsiController = TextEditingController(text: kursus?['Deskripsi'] ?? '');
    _kategoriController = TextEditingController(text: kursus?['Kategori'] ?? '');
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

  Future<void> _submit() async {
    final judul = _judulController.text.trim();
    final guru = _guruController.text.trim();
    final waktu = int.tryParse(_waktuController.text.trim()) ?? 0;
    final harga = int.tryParse(_hargaController.text.trim()) ?? 0;
    final img = _imgController.text.trim();
    final deskripsi = _deskripsiController.text.trim();
    final kategori = _kategoriController.text.trim();

    if (judul.isEmpty ||
        guru.isEmpty ||
        waktu <= 0 ||
        harga <= 0 ||
        kategori.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Judul, Guru, Waktu, Harga, dan Kategori harus diisi dengan benar')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final data = {
        'Judul': judul,
        'Guru': guru,
        'Waktu': waktu,
        'harga': harga,
        'Img': img.isEmpty ? null : img,
        'Deskripsi': deskripsi.isEmpty ? null : deskripsi,
        'Kategori': kategori,
      };

      if (widget.kursus == null) {
        // tambah baru
        await kursusService.createKursus(data);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kursus berhasil ditambahkan')),
        );
      } else {
        // update
        final id = widget.kursus!['id'];
        await kursusService.updateKursus(id, data);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kursus berhasil diperbarui')),
        );
      }

      Navigator.pop(context, true); // refresh list di halaman sebelumnya
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan kursus: $e')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.kursus != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Kursus' : 'Tambah Kursus'),
      ),
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
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _submit,
                    child: Text(isEdit ? 'Update Kursus' : 'Tambah Kursus'),
                  )
          ],
        ),
      ),
    );
  }
}
