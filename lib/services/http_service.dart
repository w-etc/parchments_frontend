import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' show Client;
import 'package:parchments_flutter/constants/colors.dart';
import 'package:parchments_flutter/constants/fonts.dart';
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
    } else if (response.statusCode == 401) {
      throw 'Invalid username or password';
    }
    throw 'Something went wrong. Can you try again?';
  }

  static Future<bool> checkValidUsername(String username) async {
    final response = await client.post(
      '$BACKEND_URL/writer/check',
      headers: {'Content-type': 'application/json'},
      body: jsonEncode({'username': username}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw 'Something went wrong. Can you try again?';
    }
  }

  static Future<Map<String, dynamic>> register(String username, String password) async {
    final response = await client.post(
      '$BACKEND_URL/writer/register',
      headers: {'Content-type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw 'Something went wrong. Can you try again?';
  }

  static Future<Parchment> getParchment(int parchmentId) async {
    final response = await client.get('$BACKEND_URL/parchment/$parchmentId');
    await Future.delayed(Duration(seconds: 2));

    if (response.statusCode == 200) {
      return Parchment.fromJson(json.decode(response.body));
    } else {
      return Parchment(contents: 'It seems we couldn\'t get this Parchment');
    }
  }

  static Future<Parchment> getRandomCoreParchment() async {
    final response = await client.get('$BACKEND_URL/parchment/core/random');
    await Future.delayed(Duration(seconds: 2));

    if (response.statusCode == 200) {
      return Parchment.fromJson(json.decode(response.body));
    } else {
      return Parchment(contents: 'It seems we couldn\'t get this Parchment');
    }
  }

  static Future<Parchment> createParchment(BuildContext context, Parchment parchment) async {
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
      return Parchment.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('You must be logged in to create a new Parchment', style: TextStyle(fontFamily: NOTO_SERIF),), backgroundColor: ERROR_FOCUSED,));
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Something went wrong. Please try again.', style: TextStyle(fontFamily: NOTO_SERIF),), backgroundColor: ERROR_FOCUSED,));
    }
    return null;
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

  static Future<String> getToken() async {
    return await tokenRetriever.getToken();
  }

  static Future<List<Parchment>> getCoreParchments() async {
    final response = await client.get(
      '$BACKEND_URL/parchment/core',
    );

    if (response.statusCode == 200) {
      final parchments = json.decode(response.body) as List;
      return parchments?.map((innerParchment) => Parchment.fromJson(innerParchment))?.toList();
    } else {
      return [];
    }
  }
}

class TokenRetriever {
  Future<String> getToken() async {
    final storage = new FlutterSecureStorage();
    return await storage.read(key: TOKEN);
  }

  Future<void> setToken(dynamic token) async {
    final storage = new FlutterSecureStorage();
    await storage.write(key: TOKEN, value: token);
  }
}