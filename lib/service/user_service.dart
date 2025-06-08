import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static const String baseUrl =
      'https://betpm-700231807331.us-central1.run.app';

  static Future<List<dynamic>> getUsers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/users'));
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 'Success') {
        return data['data'];
      } else {
        throw Exception(data['message'] ?? 'Gagal mendapatkan data user');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  static Future<void> deleteUser(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/users/$id'));
      final data = jsonDecode(response.body);

      if (response.statusCode != 200 || data['status'] != 'Success') {
        throw Exception(data['message'] ?? 'Gagal menghapus user');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  static Future<void> updateUser({
    required String id,
    required String name,
    required String email,
    required String gender,
    required String role,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/users/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'gender': gender,
          'role': role,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode != 200 || data['status'] != 'Success') {
        throw Exception(data['message'] ?? 'Gagal update user');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

 static Future<Map<String, dynamic>?> getUserById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$id'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }
}
