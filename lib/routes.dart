import 'package:flutter/widgets.dart';
import 'package:parchments_flutter/screens/login_page.dart';
import 'package:parchments_flutter/screens/parchment_page.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  "/": (BuildContext context) => LoginPage(),
  "/parchment": (BuildContext context) => ParchmentPage(),
};