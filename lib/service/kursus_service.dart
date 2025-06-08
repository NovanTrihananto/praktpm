import 'dart:convert';
import 'package:http/http.dart' as http;

class KursusService {
  final String baseUrl =
      'https://betpm-700231807331.us-central1.run.app'; // ganti sesuai backend-mu

  Future<List<dynamic>> fetchKursus() async {
    final response = await http.get(Uri.parse('$baseUrl/courses'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load courses');
    }
  }

  Future<void> createKursus(Map<String, dynamic> kursusData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/courses'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(kursusData),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to create course');
    }
  }

  Future<void> updateKursus(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/courses/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update course');
    }
  }

  Future<void> deleteKursus(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/courses/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete course');
    }
  }

  Future<bool> daftarKursus(int userId, int kursusId) async {
    final url = Uri.parse('$baseUrl/ikutkursus');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'idUser': userId, 'idKursus': kursusId}),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<Map<String, dynamic>?> getKursusById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/courses/$id'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data; // Asumsi backend return JSON kursus
      } else {
        print('Gagal load kursus by id: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error getKursusById: $e');
      return null;
    }
  }

  // Tambahkan method ini:
  Future<List<dynamic>> fetchKursusDiikuti(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/ikutkursus/$userId'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal memuat kursus yang diikuti');
    }
  }

  Future<List<dynamic>> fetchAllIkutKursus() async {
    final response = await http.get(Uri.parse('$baseUrl/ikutkursus'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal memuat semua pendaftaran kursus');
    }
  }

  // Update status atau pembayaran (bisa salah satu)
  Future<void> updateIkutKursus(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/ikutkursus/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode != 200) {
      throw Exception('Gagal update data ikut kursus');
    }
  }

  // Hapus pendaftaran ikut kursus
  Future<void> deleteIkutKursus(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/ikutkursus/$id'));
    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus pendaftaran');
    }
  }
}
