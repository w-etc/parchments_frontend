import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parchments_flutter/components/validated_input.dart';
import 'package:parchments_flutter/constants/colors.dart';
import 'package:parchments_flutter/constants/fonts.dart';
import 'package:parchments_flutter/models/parchment.dart';
import 'package:parchments_flutter/models/validators/no_empty_validator.dart';
import 'package:parchments_flutter/models/validators/same_password_validator.dart';
import 'package:parchments_flutter/services/http_service.dart';

import '../../routes.dart';

class RegisterPage extends StatefulWidget {
  final PageController parentController;
  RegisterPage({this.parentController});


  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _pageController = PageController(initialPage: 0);
  final GlobalKey<FormState> usernameKey = GlobalKey<FormState>();
  ValidatedInput usernameInput;
  final GlobalKey<FormState> passwordKey = GlobalKey<FormState>();
  ValidatedInput passwordInput;
  final GlobalKey<FormState> confirmPasswordKey = GlobalKey<FormState>();
  ValidatedInput confirmPasswordInput;

  void initState() {
    usernameInput = ValidatedInput(hint: 'Your name', obscureText: false, validators: [NoEmptyValidator()],);
    passwordInput = ValidatedInput(hint: 'Password', obscureText: true, validators: [NoEmptyValidator()],);
    confirmPasswordInput = ValidatedInput(hint: 'Confirm your password', obscureText: true, validators: [NoEmptyValidator(), SamePasswordValidator(inputToCompare: passwordInput)],);
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
    _pageController.nextPage(duration: Duration(seconds: 1), curve: Curves.easeInOutQuart);
  }

  _goToConfirmPassword() {
    if (passwordKey.currentState.validate()) {
      _pageController.nextPage(duration: Duration(seconds: 1), curve: Curves.easeInOutQuart);
    }
  }

  _register() async {
    if (confirmPasswordKey.currentState.validate()) {
      final result = await HttpService.register(usernameInput.text(), passwordInput.text());
      await HttpService.setToken(result['token']);
      Navigator.pushNamed(context, ROUTES_PARCHMENT_DETAIL, arguments: Parchment());
    }
  }

  Future<bool> _onBack() async {
    if (_pageController.page != 0) {
      _pageController.previousPage(duration: Duration(seconds: 1), curve: Curves.easeInOutQuart);
      return false;
    }
    Future.delayed(Duration(), () {
      widget.parentController.previousPage(duration: Duration(seconds: 1), curve: Curves.easeInOutQuart);
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBack,
      child: Scaffold(
          resizeToAvoidBottomInset : false,
          body: Builder(
            builder: (BuildContext builderContext) {
              return Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30,),
                  child: PageView(
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      _firstPage(builderContext),
                      _secondPage(),
                      _thirdPage(),
                    ],
                  )
              );
            },
          )
      ),
    );
  }

  Widget _firstPage(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Form(key: usernameKey, child: usernameInput),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15.0),
          child: FlatButton(
            onPressed: () => _checkValidUsername(context),
            child: Text('Next', style: TextStyle(fontSize: 36, fontFamily: CINZEL, fontWeight: FontWeight.bold,)),
          ),
        ),
      ],
    );
  }

  Widget _secondPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Form(key: passwordKey, child: passwordInput),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15.0),
          child: FlatButton(
            onPressed: () => _goToConfirmPassword(),
            child: Text('Next', style: TextStyle(fontSize: 36, fontFamily: CINZEL, fontWeight: FontWeight.bold,)),
          ),
        ),
      ],
    );
  }

  Widget _thirdPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Form(key: confirmPasswordKey, child: confirmPasswordInput),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15.0),
          child: FlatButton(
            onPressed: () => _register(),
            child: Text('Done', style: TextStyle(fontSize: 36, fontFamily: CINZEL, fontWeight: FontWeight.bold,)),
          ),
        ),
      ],
    );
  }
}