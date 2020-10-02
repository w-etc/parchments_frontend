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

import '../mocks/mock_token_retriever.dart';
import '../utils.dart';

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
    parchment = Parchment(continuations: []);
    ContinuationsPage continuationsPage = ContinuationsPage(parchment: parchment,);
    widget = getMaterialWidget(continuationsPage);

    HttpService.tokenRetriever = MockTokenRetriever();
    HttpService.client = MockClient((request) async {
      return Response(jsonEncode({'continuations': []}), 200);
    });
  });

  group('Fetching from backend', () {
    testWidgets('if there are no continuations, renders text with a WriteButton', (WidgetTester tester) async {
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      expect(find.text('Nothing follows...'), findsOneWidget);
      expect(find.byType(WriteButton), findsOneWidget);
    });

    testWidgets('if there are backend continuations, renders a ParchmentCard for each continuation', (WidgetTester tester) async {
      const parchmentJson = {'title': '', 'contents': ''};
      HttpService.client = MockClient((request) async {
        return Response(jsonEncode({'continuations': [parchmentJson, parchmentJson, parchmentJson]}), 200);
      });

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      expect(find.byType(ParchmentCard), findsNWidgets(3));
    });
  });

  group('Using local continuations', () {
    setUp(() {
      parchment = Parchment(continuations: [Parchment(title: '', contents: '')]);
      ContinuationsPage continuationsPage = ContinuationsPage(parchment: parchment,);
      widget = getMaterialWidget(continuationsPage);
    });

    testWidgets('if there are local continuations, renders a ParchmentCard for each continuation', (WidgetTester tester) async {
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      expect(find.byType(ParchmentCard), findsNWidgets(1));
    });
  });

  testWidgets('back button takes the user to ROUTES_PARCHMENT_DETAIL', (WidgetTester tester) async {
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    await simulateBackButton(tester);

    expect(find.byType(ContinuationsPage), findsNothing);
    expect(find.byKey(PARCHMENT_DETAIL_KEY), findsOneWidget);
  });
}