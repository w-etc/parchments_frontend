import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:parchments_flutter/components/parchment_card/parchment_card.dart';
import 'package:parchments_flutter/components/write_button.dart';
import 'package:parchments_flutter/models/parchment.dart';
import 'package:parchments_flutter/routes.dart';
import 'package:parchments_flutter/screens/continuations_page.dart';
import 'package:parchments_flutter/services/http_service.dart';
import 'package:parchments_flutter/services/storage_provider.dart';

import '../mocks/mock_secure_storage.dart';

const PARCHMENT_DETAIL_KEY = Key('parchment_detail_key');

Widget getMaterialWidget(Widget child) {
  return MaterialApp(
    home: child,
    routes: {
      ROUTES_PARCHMENT_DETAIL: (context) => Scaffold(key: PARCHMENT_DETAIL_KEY,),
    }
  );
}

void main() {
  Widget widget;
  Parchment parchment;

  setUp(() {
    StorageProvider.storage = MockSecureStorage();
    HttpService.client = MockClient((request) async {
      return Response(jsonEncode([]), 200);
    });
    parchment = Parchment(continuations: []);
    ContinuationsPage continuationsPage = ContinuationsPage(parchment: parchment,);
    widget = getMaterialWidget(continuationsPage);
  });

  group('Fetching from backend', () {
    testWidgets('if there are no continuations, renders text with a WriteButton', (WidgetTester tester) async {
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      expect(find.text('Nothing follows...'), findsOneWidget);
      expect(find.byType(WriteButton), findsOneWidget);
    });

    testWidgets('if there are backend continuations, renders a ParchmentCard for each continuation', (WidgetTester tester) async {
      const parchmentJson = {'title': '', 'synopsis': ''};
      HttpService.client = MockClient((request) async {
        return Response(jsonEncode([parchmentJson, parchmentJson, parchmentJson]), 200);
      });

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      expect(find.byType(ParchmentCard), findsNWidgets(3));
    });
  });
}