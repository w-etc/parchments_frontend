import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:parchments_flutter/constants/fonts.dart';
import 'package:parchments_flutter/constants/urls.dart';
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
  }

  void _write() {
    Navigator.pushNamed(context, '/write');
  }
  
  void _readContinuations(List<Parchment> continuations) {
    Navigator.pushNamed(context, '/parchment/continuations', arguments: continuations);
  }

  @override
  Widget build(BuildContext context) {
    final int parchmentId = ModalRoute.of(context).settings.arguments;
    futureParchment = fetchParchment(parchmentId);

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
                          child: Text(snapshot.data.title, style: TextStyle(fontSize: 26, fontFamily: CINZEL,),),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 100, top: 30,),
                          child: Text(snapshot.data.contents, style: TextStyle(fontSize: 16, fontFamily: NOTO_SERIF, color: Colors.black,), textAlign: TextAlign.justify,),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 20,),
                          child: Text('What comes next?', style: TextStyle(fontSize: 28, fontFamily: CINZEL, color: Colors.black)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FlatButton(
                              onPressed: () =>_readContinuations(snapshot.data.continuations),
                              child: Image(image: AssetImage('assets/glasses.png'), width: 60,),
                            ),
                            FlatButton(
                              onPressed: _write,
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
              return Text('${snapshot.error}');
            }
          },
        ),
      ),
    );
  }
}

Future<Parchment> fetchParchment(parchmentId) async {
  final response = await http.get('$BACKEND_URL/parchment/${parchmentId != null ? parchmentId : 1}');

  if (response.statusCode == 200) {
    return Parchment.fromJson(json.decode(response.body));
  } else {
    return Parchment(contents: 'It seems we couldn\'t get this Parchment');
  }
}