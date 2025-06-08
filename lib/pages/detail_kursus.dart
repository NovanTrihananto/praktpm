import 'package:flutter/material.dart';

class DetailKursusScreen extends StatelessWidget {
  final Map<String, dynamic> kursus;

  const DetailKursusScreen({super.key, required this.kursus});

  @override
  Widget build(BuildContext context) {
    final title = kursus['Judul'] ?? 'Tanpa Judul';
    final guru = kursus['Guru'] ?? '-';
    final waktu = kursus['Waktu']?.toString() ?? '0';
    final harga = kursus['harga']?.toString() ?? 'Gratis';
    final imageUrl = kursus['Img'];
    final deskripsi = kursus['Deskripsi'] ?? '-';
    final kategori = kursus['Kategori'] ?? '-';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Kursus'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar kursus
            if (imageUrl != null && imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(imageUrl),
              )
            else
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.image_not_supported,
                    size: 80, color: Colors.grey),
              ),

            const SizedBox(height: 24),

            // Judul kursus
            Text(
              title,
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // Kategori
            Text(
              'Kategori: $kategori',
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 16),

            // Nama Guru
            Row(
              children: [
                const Icon(Icons.person, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Pengajar: $guru',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Durasi
            Row(
              children: [
                const Icon(Icons.schedule, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  'Durasi: $waktu menit',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Harga
            Row(
              children: [
                const Icon(Icons.attach_money, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  'Harga: Rp $harga',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Deskripsi kursus
            const Text(
              'Deskripsi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              deskripsi,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 40),

            // Tombol Daftar (placeholder)
            Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fitur daftar kursus belum tersedia.'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Daftar Kursus',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
