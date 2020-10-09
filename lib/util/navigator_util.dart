import 'package:flutter/cupertino.dart';
import 'package:parchments_flutter/models/redirection.dart';
import 'package:parchments_flutter/routes.dart';
import 'package:parchments_flutter/services/storage_provider.dart';

Future<void> takeAuthorizedUserTo(BuildContext context, String route, dynamic arguments) async {
  String token = await StorageProvider().getToken();
  if (token != null) {
    Navigator.pushNamed(context, route, arguments: arguments);
  } else {
    Navigator.pushNamed(context, ROUTES_AUTH, arguments: Redirection(to: route, arguments: arguments));
  }
}