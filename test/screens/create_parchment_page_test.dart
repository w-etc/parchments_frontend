import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:parchments_flutter/models/parchment.dart';
import 'package:parchments_flutter/routes.dart';
import 'package:parchments_flutter/screens/create_parchment_page.dart';
import 'package:parchments_flutter/services/http_service.dart';
import 'package:parchments_flutter/services/storage_provider.dart';

import '../mocks/mock_secure_storage.dart';
import '../utils.dart';

const PARCHMENT_DETAIL_KEY = Key('parchment_detail_key');

Widget getMaterialWidget(Widget child) {
  return MaterialApp(
    initialRoute: ROUTES_PARCHMENT_CREATE,
    routes: {
      ROUTES_PARCHMENT_DETAIL: (context) => Scaffold(key: PARCHMENT_DETAIL_KEY,),
      ROUTES_PARCHMENT_CREATE: (context) => child,
    },
  );
}

void main() {

  Request parchmentRequest;
  Parchment parchment = Parchment();
  MaterialApp widget;

  const parchmentTitle = 'Pretty title';
  const parchmentSynopsis = 'Pretty synopsis';
  const parchmentContents = 'Pretty contents';

  setUp(() {
    StorageProvider.storage = MockSecureStorage();
    HttpService.client = MockClient((request) async {
      parchmentRequest = request;
      return Response(jsonEncode({}), 200);
    });

    CreateParchmentPage parchmentPage = CreateParchmentPage(parentParchmentId: parchment?.id,);
    widget = getMaterialWidget(parchmentPage);
  });

  testWidgets('sends the inputted title, synopsis and contents in an http request', (WidgetTester tester) async {
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(TITLE_INPUT_KEY), parchmentTitle);
    await tester.enterText(find.byKey(SYNOPSIS_INPUT_KEY), parchmentSynopsis);
    await tester.tap(find.byKey(Key('create_parchments_submit_button')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(CONTENTS_INPUT_KEY), parchmentContents);
    await tester.tap(find.byKey(Key('create_parchments_submit_button')));

    await tester.pumpAndSettle();

    Map body = jsonDecode(parchmentRequest.body);
    expect(body['parchment']['title'], parchmentTitle);
    expect(body['parchment']['contents'], parchmentContents);
  });

  testWidgets('takes the user to ROUTES_PARCHMENT_DETAIL', (WidgetTester tester) async {
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(TITLE_INPUT_KEY), parchmentTitle);
    await tester.enterText(find.byKey(SYNOPSIS_INPUT_KEY), parchmentSynopsis);

    // One tap for Next, the other tap for Save
    await tester.tap(find.byKey(Key('create_parchments_submit_button')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(CONTENTS_INPUT_KEY), parchmentContents);

    await tester.tap(find.byKey(Key('create_parchments_submit_button')));
    await tester.pumpAndSettle();

    expect(find.byType(CreateParchmentPage), findsNothing);
    expect(find.byKey(PARCHMENT_DETAIL_KEY), findsOneWidget);
  });

  testWidgets('going back after a Save does not take the user back to CreateParchment', (WidgetTester tester) async {
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(TITLE_INPUT_KEY), parchmentTitle);
    await tester.enterText(find.byKey(SYNOPSIS_INPUT_KEY), parchmentSynopsis);

    // One tap for Next, the other tap for Save
    await tester.tap(find.byKey(Key('create_parchments_submit_button')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(CONTENTS_INPUT_KEY), parchmentContents);

    await tester.tap(find.byKey(Key('create_parchments_submit_button')));
    await tester.pumpAndSettle();

    await simulateBackButton(tester);

    expect(find.byType(CreateParchmentPage), findsNothing);
  });

  group('Validations', () {
    testWidgets('submitting without a title raises a snackbar', (WidgetTester tester) async {
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(SYNOPSIS_INPUT_KEY), parchmentSynopsis);
      await tester.tap(find.byKey(Key('create_parchments_submit_button')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(CONTENTS_INPUT_KEY), parchmentContents);
      await tester.tap(find.byKey(Key('create_parchments_submit_button')));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('create_parchment_empty_fields_snackbar')), findsOneWidget);
    });

    testWidgets('submitting without a synopsis raises a snackbar', (WidgetTester tester) async {
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(TITLE_INPUT_KEY), parchmentTitle);
      await tester.tap(find.byKey(Key('create_parchments_submit_button')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(CONTENTS_INPUT_KEY), parchmentContents);
      await tester.tap(find.byKey(Key('create_parchments_submit_button')));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('create_parchment_empty_fields_snackbar')), findsOneWidget);
    });

    testWidgets('submitting without contents raises a snackbar', (WidgetTester tester) async {
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(TITLE_INPUT_KEY), parchmentTitle);
      await tester.enterText(find.byKey(SYNOPSIS_INPUT_KEY), parchmentSynopsis);
      await tester.tap(find.byKey(Key('create_parchments_submit_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('create_parchments_submit_button')));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('create_parchment_empty_fields_snackbar')), findsOneWidget);
    });
  });
}