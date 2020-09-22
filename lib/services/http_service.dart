import 'dart:convert';

import 'package:http/http.dart' show Client;
import 'package:parchments_flutter/constants/util.dart';
import 'package:parchments_flutter/constants/urls.dart';
import 'package:parchments_flutter/models/parchment.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HttpService {

  static Client client = Client();
  static TokenRetriever tokenRetriever = TokenRetriever();

  static Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await client.post(
      '$BACKEND_URL/writer/login',
      headers: {'Content-type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      //TODO: Show a toast asking the user to try again
    }
  }

  static Future<Parchment> getParchment(int parchmentId) async {
    final token = await tokenRetriever.getToken();
    final response = await client.get('$BACKEND_URL/parchment/${parchmentId != null ? parchmentId : 1}', headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      return Parchment.fromJson(json.decode(response.body));
    } else {
      return Parchment(contents: 'It seems we couldn\'t get this Parchment');
    }
  }

  static Future<Parchment> createParchment(Parchment parchment) async {
    final token = await tokenRetriever.getToken();
    final response = await client.post(
        '$BACKEND_URL/parchment',
        headers: {'Content-type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode({
          'parchment': {'title': parchment.title, 'contents': parchment.contents,},
          'previousParchmentId': parchment.parentParchmentId,
        })
    );
    if (response.statusCode == 200) {
      print('Success!');
    } else {
      print('Failed');
    }
    return Parchment.fromJson(json.decode(response.body));
  }

  static Future<List<Parchment>> getContinuations(Parchment parchment) async {
    if (parchment.continuations.length > 0) {
      return parchment.continuations;
    }
    Parchment retrievedParchment = await getParchment(parchment.id);
    return retrievedParchment.continuations;
  }

  static Future<void> setToken(dynamic token) async {
    await tokenRetriever.setToken(token);
  }
}

class TokenRetriever {
  getToken() async {
    final storage = new FlutterSecureStorage();
    return await storage.read(key: TOKEN);
  }

  setToken(dynamic token) async {
    final storage = new FlutterSecureStorage();
    await storage.write(key: TOKEN, value: token);
  }
}