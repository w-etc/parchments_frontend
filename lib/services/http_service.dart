import 'dart:convert';

import 'package:http/http.dart' show Client;
import 'package:parchments_flutter/constants/urls.dart';
import 'package:parchments_flutter/models/parchment.dart';
import 'package:parchments_flutter/services/shared_preferences.dart';

class HttpService {

  static Client client = Client();

  static Future<int> login(String name) async {
    final response = await client.get('$BACKEND_URL/writer/$name');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      //TODO: Show a toast asking the user to try again
    }
  }

  static Future<Parchment> getParchment(int parchmentId) async {
    final response = await client.get('$BACKEND_URL/parchment/${parchmentId != null ? parchmentId : 1}');

    if (response.statusCode == 200) {
      return Parchment.fromJson(json.decode(response.body));
    } else {
      return Parchment(contents: 'It seems we couldn\'t get this Parchment');
    }
  }

  static Future<Parchment> createParchment(Parchment parchment) async {
    final writerId = await getWriterId();
    final response = await client.post(
        '$BACKEND_URL/parchment',
        headers: {'Content-type': 'application/json'},
        body: jsonEncode({
          'parchment': {'title': parchment.title, 'contents': parchment.contents,},
          'writerId': writerId,
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
}