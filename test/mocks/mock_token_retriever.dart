import 'package:parchments_flutter/services/http_service.dart';

class MockTokenRetriever extends TokenRetriever {
  @override
  getToken() async {
    return 'test token';
  }

  @override
  setToken(dynamic token) async {
  }
}