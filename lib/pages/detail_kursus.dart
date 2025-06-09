import 'package:flutter/material.dart';
import 'package:tpmteori/service/kursus_service.dart';

class DetailKursusScreen extends StatefulWidget {
  final Map<String, dynamic> kursus;
  final int userId;

  const DetailKursusScreen({
    super.key,
    required this.kursus,
    required this.userId,
  });

  @override
  State<DetailKursusScreen> createState() => _DetailKursusScreenState();
}

class _DetailKursusScreenState extends State<DetailKursusScreen> {
  String selectedCurrency = 'IDR';

  final Map<String, double> currencyRates = {
    'IDR': 1,
    'USD': 0.000067,
    'EUR': 0.000061,
    'JPY': 0.0098,
  };

  String formatHarga(double harga, String mataUang) {
    if (mataUang == 'IDR') {
      return "Rp ${harga.toStringAsFixed(0)}";
    }
    return "${harga.toStringAsFixed(2)} $mataUang";
  }

  @override
  Widget build(BuildContext context) {
    final kursus = widget.kursus;
    final title = kursus['Judul'] ?? 'Tanpa Judul';
    final guru = kursus['Guru'] ?? '-';
    final waktu = kursus['Waktu']?.toString() ?? '0';
    final hargaInt = kursus['harga'] ?? 0;
    final hargaAsli = hargaInt is int ? hargaInt.toDouble() : 0.0;
    final convertedHarga = hargaAsli * (currencyRates[selectedCurrency] ?? 1);
    final imageUrl = kursus['Img'];
    final deskripsi = kursus['Deskripsi'] ?? '-';
    final kategori = kursus['Kategori'] ?? '-';
    final kursusId = kursus['id'];

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
            // Gambar
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
            Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Kategori: $kategori',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 16),

            Row(
              children: [
                const Icon(Icons.person, color: Colors.blue),
                const SizedBox(width: 8),
                Text('Pengajar: $guru', style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(Icons.schedule, color: Colors.orange),
                const SizedBox(width: 8),
                Text('Durasi: $waktu menit', style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(Icons.attach_money, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  'Harga: ${formatHarga(convertedHarga, selectedCurrency)}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedCurrency,
                  items: currencyRates.keys
                      .map((currency) => DropdownMenuItem<String>(
                            value: currency,
                            child: Text(currency),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedCurrency = value);
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Text('Deskripsi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(deskripsi, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 40),

            // Tombol Daftar
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Konfirmasi'),
                      content: const Text('Yakin ingin mendaftar ke kursus ini?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('Ya, Daftar'),
                        ),
                      ],
                    ),
                  );

                  if (confirm != true) return;

                  try {
                    final success = await KursusService()
                        .daftarKursus(widget.userId, kursusId);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(success
                            ? 'Berhasil mendaftar kursus.'
                            : 'Gagal mendaftar kursus.'),
                        backgroundColor:
                            success ? Colors.green : Colors.red,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Terjadi kesalahan: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Daftar Kursus', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

