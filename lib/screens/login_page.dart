import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:parchments_flutter/constants/fonts.dart';
import 'package:parchments_flutter/routes.dart';
import 'package:parchments_flutter/services/http_service.dart';
import 'package:parchments_flutter/services/shared_preferences.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final writerNameController = TextEditingController();

  Future<void> _login(String name) async {
    final writerId = await HttpService.login(name);
    await setWriterId(writerId);
    Navigator.pushNamed(context, ROUTES_PARCHMENT_DETAIL);
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
