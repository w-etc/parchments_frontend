import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:parchments_flutter/components/validated_input.dart';
import 'package:parchments_flutter/constants/fonts.dart';
import 'package:parchments_flutter/models/parchment.dart';
import 'package:parchments_flutter/services/http_service.dart';

import '../routes.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();


  Future<void> _login(String username, String password) async {
    if (_formKey.currentState.validate()) {
      final result = await HttpService.login(username, password);
      await HttpService.setToken(result['token']);
      Navigator.pushNamed(context, ROUTES_PARCHMENT_DETAIL, arguments: Parchment());
    }
  }

  @override
  Widget build(BuildContext context) {
    ValidatedInput usernameInput = ValidatedInput(hint: 'Your name', obscureText: false,);
    ValidatedInput passwordInput = ValidatedInput(hint: 'Password', obscureText: true,);
    return Scaffold(
        resizeToAvoidBottomInset : false,
        body: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 225,),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              usernameInput,
              passwordInput,
              Container(
                margin: const EdgeInsets.only(top: 50.0),
                child: FlatButton(
                  onPressed: () => _login(usernameInput.text(), passwordInput.text()),
                  child: Text('Sign', style: TextStyle(fontSize: 36, fontFamily: CINZEL, fontWeight: FontWeight.bold,)),
                ),
              )
            ],
          ),
        )
      )
    );
  }
}
