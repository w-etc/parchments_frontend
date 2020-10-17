import 'package:flutter/cupertino.dart';
import 'package:parchments_flutter/models/redirection.dart';
import 'package:parchments_flutter/routes.dart';
import 'package:parchments_flutter/services/storage_provider.dart';

Future<void> takeAuthorizedUserTo(BuildContext context, String route, dynamic arguments, bool replaceRoute) async {
  bool hasToken = await StorageProvider().hasToken();
  final routeToGo = hasToken ? route : ROUTES_AUTH;
  final argumentsToUse = hasToken ? arguments : Redirection(to: route, arguments: arguments);
  if (replaceRoute) {
    Navigator.pushReplacementNamed(context, routeToGo, arguments: argumentsToUse);
    return;
  }
  Navigator.pushNamed(context, routeToGo, arguments: argumentsToUse);
}