import 'package:flutter/cupertino.dart';
import 'package:parchments_flutter/models/redirection.dart';
import 'package:parchments_flutter/routes.dart';
import 'package:parchments_flutter/services/storage_provider.dart';

Future<void> takeAuthorizedUserTo(BuildContext context, String route, dynamic arguments, bool replaceRoute) async {
  String token = await StorageProvider().getToken();
  if (token != null) {
    if (replaceRoute) {
      Navigator.pushReplacementNamed(context, route, arguments: arguments);
      return;
    }
    Navigator.pushNamed(context, route, arguments: arguments);
  } else {
    if (replaceRoute) {
      Navigator.pushReplacementNamed(context, ROUTES_AUTH, arguments: Redirection(to: route, arguments: arguments));
      return;
    }
    Navigator.pushNamed(context, ROUTES_AUTH, arguments: Redirection(to: route, arguments: arguments));
  }
}