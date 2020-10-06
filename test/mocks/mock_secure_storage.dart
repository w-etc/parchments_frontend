import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MockSecureStorage extends FlutterSecureStorage {

  final storage = Map();

  @override
  Future<String> read({AndroidOptions aOptions, IOSOptions iOptions, String key}) async {
    return storage[key];
  }

  @override
  Future<void> write({AndroidOptions aOptions, IOSOptions iOptions, String key, String value}) async {
    storage[key] = value;
  }
}