import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:parchments_flutter/components/validated_input.dart';
import 'package:parchments_flutter/constants/colors.dart';
import 'package:parchments_flutter/constants/fonts.dart';
import 'package:parchments_flutter/models/parchment.dart';
import 'package:parchments_flutter/models/validators/no_empty_validator.dart';
import 'package:parchments_flutter/services/http_service.dart';

import '../routes.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();


  Future<void> _login(BuildContext context, String username, String password) async {
    if (_formKey.currentState.validate()) {
      final result = await HttpService.login(username, password);
      if (result == null) {
        final snackBar = SnackBar(content: Text('Invalid username or password', style: TextStyle(fontFamily: NOTO_SERIF),), backgroundColor: ERROR_FOCUSED,);
        Scaffold.of(context).showSnackBar(snackBar);
        return;
      }
      await HttpService.setToken(result['token']);
      Navigator.pushNamed(context, ROUTES_PARCHMENT_DETAIL, arguments: Parchment());
    }
  }

  void _goToRegisterPage() {
    Navigator.pushNamed(context, ROUTES_REGISTER);
  }

  @override
  Widget build(BuildContext context) {
    ValidatedInput usernameInput = ValidatedInput(hint: 'Your name', obscureText: false, validator: NoEmptyValidator(),);
    ValidatedInput passwordInput = ValidatedInput(hint: 'Password', obscureText: true, validator: NoEmptyValidator());
    return Scaffold(
        resizeToAvoidBottomInset : false,
        body: Builder(
          builder: (BuildContext context) {
            return Padding(
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
                        onPressed: () => _login(context, usernameInput.text(), passwordInput.text()),
                        child: Text('Sign', style: TextStyle(fontSize: 36, fontFamily: CINZEL, fontWeight: FontWeight.bold,)),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15.0),
                      child: FlatButton(
                        onPressed: () => _goToRegisterPage(),
                        child: Text('Register', style: TextStyle(fontSize: 36, fontFamily: CINZEL, fontWeight: FontWeight.bold,)),
                      ),
                    ),
                  ],
                ),
              )
            );
          }
        )
    );
  }
}
