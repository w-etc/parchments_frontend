import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:parchments_flutter/constants/urls.dart';
import 'package:parchments_flutter/models/parchment.dart';
import 'package:parchments_flutter/services/shared_preferences.dart';

class HttpService {

  static Future<int> login(String name) async {
    final response = await http.get('$BACKEND_URL/writer/$name');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      //TODO: Show a toast asking the user to try again
    }
  }

  static Future<Parchment> getParchment(int parchmentId) async {
    final response = await http.get('$BACKEND_URL/parchment/${parchmentId != null ? parchmentId : 1}');

    if (response.statusCode == 200) {
      return Parchment.fromJson(json.decode(response.body));
    } else {
      return Parchment(contents: 'It seems we couldn\'t get this Parchment');
    }
  }

  static Future<num> createParchment(int previousParchmentId, Parchment parchment) async {
    final writerId = await getWriterId();
    final response = await http.post(
        '$BACKEND_URL/parchment',
        headers: {'Content-type': 'application/json'},
        body: jsonEncode({
          'parchment': {'title': parchment.title, 'contents': parchment.contents,},
          'writerId': writerId,
          'previousParchmentId': previousParchmentId,
        })
    );
    if (response.statusCode == 200) {
      print('Success!');
    } else {
      print('Failed');
    }
    return json.decode(response.body);
  }
}