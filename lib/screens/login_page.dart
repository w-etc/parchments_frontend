import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:parchments_flutter/constants/fonts.dart';
import 'package:parchments_flutter/constants/shared_preferences.dart';
import 'package:parchments_flutter/constants/urls.dart';
import 'package:parchments_flutter/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  final String title = 'Login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final writerNameController = TextEditingController();

  Future<void> _login(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get('$BACKEND_URL/writer/$name');
    if (response.statusCode == 200) {
      await prefs.setInt(WRITER_ID, jsonDecode(response.body));
      Navigator.pushNamed(context, ROUTES_PARCHMENT_DETAIL);
    } else {
      //TODO: Show a toast asking the user to try again
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset : false,
        body: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 225,),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                    style: TextStyle(fontSize: 18, fontFamily: CINZEL,),
                    decoration: const InputDecoration(
                      hintText: 'Your name',
                      hintStyle: TextStyle(fontSize: 18, fontFamily: CINZEL),
                      contentPadding: EdgeInsets.only(bottom: -15),
                    ),
                    controller: writerNameController,
                  ),
                ),
                Image(image: AssetImage('assets/feather_left.png'), width: 50,),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 50.0),
              child: FlatButton(
                onPressed: () => _login(writerNameController.text),
                child: Text('Sign', style: TextStyle(fontSize: 36, fontFamily: CINZEL)),
              ),
            )
          ],
        ),
      )
    );
  }
}
