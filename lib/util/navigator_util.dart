import 'package:flutter/cupertino.dart';
import 'package:parchments_flutter/routes.dart';
import 'package:parchments_flutter/services/http_service.dart';

Future<void> takeAuthorizedUserTo(BuildContext context, String route, dynamic arguments) async {
  String token = await HttpService.getToken();
  if (token != null) {
    Navigator.pushNamed(context, route, arguments: arguments);
  } else {
    Navigator.pushNamed(context, ROUTES_AUTH);
  }
}