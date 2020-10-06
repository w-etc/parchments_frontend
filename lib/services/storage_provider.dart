import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:parchments_flutter/constants/util.dart';

class StorageProvider {
  static FlutterSecureStorage storage = new FlutterSecureStorage();

  Future<String> getToken() async {
    return await storage.read(key: TOKEN);
  }

  Future<void> setToken(dynamic token) async {
    await storage.write(key: TOKEN, value: token);
  }

  Future<void> setUsername(String username) async {
    await storage.write(key: USERNAME, value: username);
  }

  Future<String> getUsername() async {
    return await storage.read(key: USERNAME);
  }
}