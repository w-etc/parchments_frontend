import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/Lucas/Parchments/parchments_frontend/lib/screens/auth_page/login_page.dart';
import 'file:///C:/Users/Lucas/Parchments/parchments_frontend/lib/screens/auth_page/register_page.dart';

class AuthPage extends StatefulWidget {

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      body: PageView(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        children: [
          LoginPage(parentController: _pageController),
          RegisterPage(parentController: _pageController,),
        ],
      ),
    );
  }
}
