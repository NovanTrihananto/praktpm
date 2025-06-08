import 'package:flutter/material.dart';
import 'package:tpmteori/service/kursus_service.dart';

class IkutKursusAdminPage extends StatefulWidget {
  const IkutKursusAdminPage({super.key});

  @override
  State<IkutKursusAdminPage> createState() => _IkutKursusAdminPageState();
}

class _IkutKursusAdminPageState extends State<IkutKursusAdminPage> {
  late Future<List<dynamic>> allPendaftaran;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    allPendaftaran = KursusService().fetchAllIkutKursus();
  }

  Future<void> _hapus(int idIkutKursus) async {
    await KursusService().deleteIkutKursus(idIkutKursus);
    setState(() {
      _loadData();
    });
  }

  Future<void> _update(int idIkutKursus, String statusBaru, String pembayaranBaru) async {
    await KursusService().updateIkutKursus(idIkutKursus, {
      'status': statusBaru,
      'pembayaran': pembayaranBaru,
    });
    setState(() {
      _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kelola Pendaftaran Kursus")),
      body: FutureBuilder<List<dynamic>>(
        future: allPendaftaran,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text("Terjadi kesalahan: ${snapshot.error}");
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text("Tidak ada data pendaftaran.");
          }

          final data = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              final id = item['id'];
              final userName = item['user']['name'] ?? '-';
              final kursusTitle = item['kursus']['Judul'] ?? '-';
              String status = item['status'] ?? 'aktif';
              String pembayaran = item['pembayaran'] ?? 'pending';

              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("$userName - $kursusTitle", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text("Status: "),
                          DropdownButton<String>(
                            value: status,
                            items: ['aktif', 'selesai'].map((value) {
                              return DropdownMenuItem(value: value, child: Text(value));
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                status = value;
                                _update(id, status, pembayaran);
                              }
                            },
                          ),
                          const SizedBox(width: 20),
                          const Text("Pembayaran: "),
                          DropdownButton<String>(
                            value: pembayaran,
                            items: ['pending', 'lunas'].map((value) {
                              return DropdownMenuItem(value: value, child: Text(value));
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                pembayaran = value;
                                _update(id, status, pembayaran);
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _hapus(id),
                          tooltip: 'Hapus Pendaftaran',
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
