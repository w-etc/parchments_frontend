import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mockito/mockito.dart';
import 'package:parchments_flutter/components/read_continuations_button.dart';
import 'package:parchments_flutter/components/write_button.dart';
import 'package:parchments_flutter/models/parchment.dart';
import 'package:parchments_flutter/routes.dart';
import 'package:parchments_flutter/screens/parchment_page.dart';
import 'package:parchments_flutter/services/http_service.dart';
import '../mocks/mock_token_retriever.dart';
import '../utils.dart';


const LOGIN_KEY = Key('login_key');
const PARCHMENT_CREATE_KEY = Key('parchment_create_key');
const PARCHMENT_CONTINUATIONS_KEY = Key('parchment_continuations_key');

Widget getMaterialWidget(Widget child) {
  return MaterialApp(
    initialRoute: ROUTES_PARCHMENT_DETAIL,
    routes: {
      ROUTES_HOME: (context) => Scaffold(key: LOGIN_KEY,),
      ROUTES_PARCHMENT_DETAIL: (context) => child,
      ROUTES_PARCHMENT_CREATE: (context) => Scaffold(key: PARCHMENT_CREATE_KEY,),
      ROUTES_PARCHMENT_CONTINUATIONS: (context) => Scaffold(key: PARCHMENT_CONTINUATIONS_KEY,),
    },
  );
}

void main() {
  const parchmentId = 1;
  const parchmentTitle = 'pretty title';
  const parchmentContents = 'pretty contents';
  Request parchmentRequest;
  MaterialApp widget;
  Parchment parchment = Parchment(id: parchmentId);

  setUp(() async {
    HttpService.tokenRetriever = MockTokenRetriever();
    HttpService.client = MockClient((request) async {
      parchmentRequest = request;
      return Response(jsonEncode({'title': parchmentTitle, 'contents': parchmentContents}), 200);
    });

    ParchmentPage parchmentPage = ParchmentPage(parchment: parchment,);
    widget = getMaterialWidget(parchmentPage);
  });

  testWidgets('ParchmentPage initially requests a Parchment', (WidgetTester tester) async {
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    expect(parchmentRequest.toString(), contains(parchmentId.toString()));
  });

  testWidgets('ParchmentPage shows the requested Parchment\'s title and contents', (WidgetTester tester) async {
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    expect(find.text(parchmentTitle), findsOneWidget);
    expect(find.text(parchmentContents), findsOneWidget);
  });

  testWidgets('tapping WriteButton takes the user to ROUTES_PARCHMENT_CREATE', (WidgetTester tester) async {
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(WriteButton));
    await tester.pumpAndSettle();

    expect(find.byType(ParchmentPage), findsNothing);
    expect(find.byKey(PARCHMENT_CREATE_KEY), findsOneWidget);
  });

  testWidgets('tapping ReadContinuationsButton takes the user to ROUTES_PARCHMENT_CONTINUATIONS', (WidgetTester tester) async {
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ReadContinuationsButton));
    await tester.pumpAndSettle();

    expect(find.byType(ParchmentPage), findsNothing);
    expect(find.byKey(PARCHMENT_CONTINUATIONS_KEY), findsOneWidget);
  });

  testWidgets('if the requested parchment has no parentParchmentId, the back button takes the user to the login page', (WidgetTester tester) async {
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    await simulateBackButton(tester);

    expect(find.byType(ParchmentPage), findsNothing);
    expect(find.byKey(LOGIN_KEY), findsOneWidget);
  });

  testWidgets('if the requested parchment has parentParchmentId, the back button takes the user to the parchment continuations page', (WidgetTester tester) async {
    HttpService.client = MockClient((request) async {
      parchmentRequest = request;
      return Response(jsonEncode({'title': parchmentTitle, 'contents': parchmentContents, 'parentParchment': {'id': 3}}), 200);
    });

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    await simulateBackButton(tester);

    expect(find.byType(ParchmentPage), findsNothing);
    expect(find.byKey(PARCHMENT_CONTINUATIONS_KEY), findsOneWidget);
  });
}
