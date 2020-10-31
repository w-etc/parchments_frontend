import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' show Client;
import 'package:http/src/response.dart';
import 'package:parchments_flutter/constants/colors.dart';
import 'package:parchments_flutter/constants/fonts.dart';
import 'package:parchments_flutter/constants/urls.dart';
import 'package:parchments_flutter/models/breadcrumb.dart';
import 'package:parchments_flutter/models/parchment.dart';
import 'package:parchments_flutter/services/storage_provider.dart';

class HttpService {

  static Client client = Client();
  static StorageProvider storageRetriever = StorageProvider();

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

    if (response.statusCode == 200) {
      return _parchmentWithBreadcrumbs(response);
    } else {
      return Parchment(contents: 'It seems we couldn\'t get this Parchment');
    }
  }

  static Future<Parchment> getRandomCoreParchment() async {
    final response = await client.get('$BACKEND_URL/parchment/core/random');
    await Future.delayed(Duration(seconds: 2));

    if (response.statusCode == 200) {
      return _parchmentWithBreadcrumbs(response);
    } else {
      return Parchment(contents: 'It seems we couldn\'t get this Parchment');
    }
  }

  static Parchment _parchmentWithBreadcrumbs(Response response) {
    final parsedJson = json.decode(response.body);
    final breadcrumbs = ((parsedJson['breadcrumbs']?? []) as List).map((innerBreadcrumb) => Breadcrumb.fromJson(innerBreadcrumb)).toList();
    final parchment = Parchment.fromJson(parsedJson['parchment']);
    parchment.breadcrumbs = breadcrumbs;
    return parchment;
  }

  static Future<Parchment> createParchment(BuildContext context, Parchment parchment) async {
    final token = await storageRetriever.getToken();
    final response = await client.post(
        '$BACKEND_URL/parchment',
        headers: {'Content-type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode({
          'parchment': {'title': parchment.title, 'synopsis': parchment.synopsis, 'contents': parchment.contents,},
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

  static Future<List<Parchment>> getContinuations(Parchment parchment, int pageKey) async {
    final response = await client.get('$BACKEND_URL/parchment/${parchment.id}/continuations?page=$pageKey');
    if (response.statusCode == 200) {
      final parsedBody = json.decode(response.body) as List;
      return parsedBody.map((parchment) => Parchment.fromJson(parchment)).toList();
    } else {
      return [];
    }
  }

  static Future<String> getToken() async {
    return await storageRetriever.getToken();
  }

  static Future<List<Parchment>> getCoreParchments(int pagekey) async {
    final response = await client.get(
      '$BACKEND_URL/parchment/core?page=$pagekey',
    );

    if (response.statusCode == 200) {
      final parchments = json.decode(response.body) as List;
      return parchments?.map((innerParchment) => Parchment.fromJson(innerParchment))?.toList();
    } else {
      return [];
    }
  }

  static Future<List<Parchment>> searchParchmentsByTitle(String title) async {
    final response = await client.get('$BACKEND_URL/parchment/title/$title');

    if (response.statusCode == 200) {
      final parchments = json.decode(response.body) as List;
      return parchments?.map((innerParchment) => Parchment.fromJson(innerParchment))?.toList();
    } else {
      return null;
    }
  }

  static Future<List<Parchment>> getWriterParchments() async {
    final writerId = await storageRetriever.getId();
    final response = await client.get('$BACKEND_URL/parchment/writer/$writerId');

    if (response.statusCode == 200) {
      final parchments = json.decode(response.body) as List;
      return parchments.map((innerParchment) => Parchment.fromJson(innerParchment)).toList();
    } else {
      return null;
    }
  }
}