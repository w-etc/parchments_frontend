import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:parchments_flutter/constants/util.dart';

class StorageProvider {
  static FlutterSecureStorage storage = new FlutterSecureStorage();

  Future<bool> hasToken() async {
    return await this.getToken() != null;
  }

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

  Future<void> setId(int id) async {
    await storage.write(key: WRITER_ID, value: id.toString());
  }

  Future<int> getId() async {
    final writerIdString = await storage.read(key: WRITER_ID);
    return int.parse(writerIdString);
  }

  Future<bool> userIsAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}