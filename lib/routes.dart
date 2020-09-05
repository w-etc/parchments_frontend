import 'package:flutter/widgets.dart';
import 'package:parchments_flutter/screens/continuations_page.dart';
import 'package:parchments_flutter/screens/create_parchment_page.dart';
import 'package:parchments_flutter/screens/login_page.dart';
import 'package:parchments_flutter/screens/parchment_page.dart';

const ROUTES_HOME = '/';
const ROUTES_PARCHMENT_DETAIL = '/parchment';
const ROUTES_PARCHMENT_CREATE = '/write';
const ROUTES_PARCHMENT_CONTINUATIONS = '/parchment/continuations';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  ROUTES_HOME: (BuildContext context) => LoginPage(),
  ROUTES_PARCHMENT_DETAIL: (BuildContext context) => ParchmentPage(),
  ROUTES_PARCHMENT_CREATE: (BuildContext context) => CreateParchmentPage(),
  ROUTES_PARCHMENT_CONTINUATIONS: (BuildContext context) => ContinuationsPage(),
};