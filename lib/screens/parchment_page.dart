import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:parchments_flutter/models/parchment.dart';
import 'package:http/http.dart' as http;

class ParchmentPage extends StatefulWidget {
  final String title = 'Login';

  @override
  _ParchmentPageState createState() => _ParchmentPageState();
}

class _ParchmentPageState extends State<ParchmentPage> {
  Future<Parchment> futureParchment;

  @override
  void initState() {
    super.initState();
    futureParchment = fetchParchment();
  }

  @override
  Widget build(BuildContext context) {
    const font = 'ArchitectsDaughter';
    return Scaffold(
      body: Center(
        child: FutureBuilder<Parchment>(
          future: futureParchment,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 50,),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: 50,),
                          child: Text(snapshot.data.title, style: TextStyle(fontSize: 36, fontFamily: font,),),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 100,),
                          child: Text(snapshot.data.contents, style: TextStyle(fontSize: 18, fontFamily: font,),),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 20,),
                          child: Text('What comes next?', style: TextStyle(fontSize: 48, fontFamily: 'Italianno', color: Colors.black)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FlatButton(
                              child: Image(image: AssetImage('assets/glasses.png'), width: 60,),
                            ),
                            FlatButton(
                              child: Image(image: AssetImage('assets/feather_right.png'), width: 42,),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Text("${snapshot.error}");
            }
          },
        ),
      ),
    );
  }
}

Future<Parchment> fetchParchment() async {
  final response = await http.get('${DotEnv().env['HOST']}/parchment/6');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Parchment.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load parchment');
  }
}