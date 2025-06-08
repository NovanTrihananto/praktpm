import 'package:flutter/material.dart';
import 'package:tpmteori/service/kursus_service.dart';
import 'package:tpmteori/pages/detail_kursus.dart';

class CoursesScreen extends StatefulWidget {
  final int userId;
  const CoursesScreen({super.key, required this.userId});
  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  late Future<List<dynamic>> futureIkutKursus;

  @override
  void initState() {
    super.initState();
    // Panggil endpoint yang sudah include relasi kursus berdasarkan userId
    futureIkutKursus = KursusService().fetchKursusDiikuti(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kursus yang Diikuti')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<dynamic>>(
          future: futureIkutKursus,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Gagal memuat data: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('Belum mengikuti kursus apapun.');
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final ikutKursusData = snapshot.data![index];
                  return _buildCourseCard(ikutKursusData);
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildCourseCard(Map<String, dynamic> ikutKursusData) {
    final kursus = ikutKursusData['kursus'] ?? {};
    final title = kursus['Judul'] ?? 'Tanpa Judul';
    final desc = kursus['Deskripsi'] ?? '';
    final price = kursus['harga'] != null ? 'Rp ${kursus['harga']}' : 'Gratis';
    final imageUrl = kursus['Img'];

    final pembayaran = ikutKursusData['pembayaran'] ?? 'pending';
    final status = ikutKursusData['status'] ?? 'aktif';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                image:
                    imageUrl != null && imageUrl.isNotEmpty
                        ? DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        )
                        : null,
              ),
              child:
                  imageUrl == null || imageUrl.isEmpty
                      ? const Icon(
                        Icons.image_not_supported,
                        color: Colors.blue,
                        size: 32,
                      )
                      : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.payment, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        'Pembayaran: $pembayaran',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.verified_user,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Status: $status',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => DetailKursusScreen(
                              kursus: kursus,
                              userId: widget.userId,
                            ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(80, 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Lihat Detail',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
