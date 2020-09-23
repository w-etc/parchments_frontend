import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parchments_flutter/components/validated_input.dart';
import 'package:parchments_flutter/constants/colors.dart';
import 'package:parchments_flutter/constants/fonts.dart';
import 'package:parchments_flutter/models/parchment.dart';
import 'package:parchments_flutter/models/validators/no_empty_validator.dart';
import 'package:parchments_flutter/models/validators/same_password_validator.dart';
import 'package:parchments_flutter/services/http_service.dart';

import '../routes.dart';

class RegisterPage extends StatefulWidget {

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int currentStepCount = 0;
  final GlobalKey<FormState> usernameKey = GlobalKey<FormState>();
  ValidatedInput usernameInput;
  Form usernameForm;
  final GlobalKey<FormState> passwordKey = GlobalKey<FormState>();
  ValidatedInput passwordInput;
  Form passwordForm;
  final GlobalKey<FormState> confirmPasswordKey = GlobalKey<FormState>();
  ValidatedInput confirmPasswordInput;
  Form confirmPasswordForm;

  void initState() {
    usernameInput = ValidatedInput(hint: 'Your name', obscureText: false, validators: [NoEmptyValidator()],);
    passwordInput = ValidatedInput(hint: 'Password', obscureText: true, validators: [NoEmptyValidator()],);
    confirmPasswordInput = ValidatedInput(hint: 'Confirm your password', obscureText: true, validators: [NoEmptyValidator(), SamePasswordValidator(inputToCompare: passwordInput)],);
    usernameForm = Form(key: usernameKey, child: usernameInput);
    passwordForm = Form(key: passwordKey, child: passwordInput);
    confirmPasswordForm = Form(key: confirmPasswordKey, child: confirmPasswordInput);
  }

  _checkValidUsername(BuildContext context) async {
    if (!usernameKey.currentState.validate()) {
      return;
    }
    bool isValid = await HttpService.checkValidUsername(usernameInput.text());
    if (!isValid) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('That name is taken', style: TextStyle(fontFamily: NOTO_SERIF),), backgroundColor: ERROR_FOCUSED,));
      return;
    }
    Scaffold.of(context).hideCurrentSnackBar();
    setState(() {
      currentStepCount++;
    });
  }

  _goToConfirmPassword() {
    if (passwordKey.currentState.validate()) {
      setState(() {
        currentStepCount++;
      });
    }
  }

  _register() async {
    if (confirmPasswordKey.currentState.validate()) {
      final result = await HttpService.register(usernameInput.text(), passwordInput.text());
      await HttpService.setToken(result['token']);
      Navigator.pushNamed(context, ROUTES_PARCHMENT_DETAIL, arguments: Parchment());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset : false,
        body: Builder(
          builder: (BuildContext builderContext) {
            return Padding(
                padding: const EdgeInsets.only(left: 30, right: 30,),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: _getCurrentForm(),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15.0),
                      child: _getCurrentButton(builderContext),
                    ),
                  ],
                )
            );
          },
        )
    );
  }

  Widget _getCurrentForm() {
    final List<Widget> allForms = [usernameForm, passwordForm, confirmPasswordForm];
    return allForms[currentStepCount];
  }

  Widget _getCurrentButton(BuildContext context) {
    dynamic callback = () => _register();
    String text = 'Done';
    if (currentStepCount == 0) {
      callback = () => _checkValidUsername(context);
      text = 'Next';
    }
    if (currentStepCount == 1) {
      callback = () => _goToConfirmPassword();
      text = 'Next';
    }
    return FlatButton(
      onPressed: callback,
      child: Text(text, style: TextStyle(fontSize: 36, fontFamily: CINZEL, fontWeight: FontWeight.bold,)),
    );
  }
}