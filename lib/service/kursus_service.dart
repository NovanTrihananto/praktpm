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
}

