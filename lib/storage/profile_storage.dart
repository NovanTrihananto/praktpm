import 'dart:typed_data';
import 'package:hive/hive.dart';

class ProfileStorage {
  static Future<void> saveProfileImage(Uint8List imageBytes) async {
    final box = Hive.box('profileBox');
    await box.put('profileImage', imageBytes);
  }

  static Uint8List? getProfileImage() {
    final box = Hive.box('profileBox');
    return box.get('profileImage');
  }
}
