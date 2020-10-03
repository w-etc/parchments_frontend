import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:parchments_flutter/components/validated_input.dart';
import 'package:parchments_flutter/routes.dart';
import 'package:parchments_flutter/screens/auth_page/auth_page.dart';
import 'package:parchments_flutter/services/http_service.dart';

import '../mocks/mock_token_retriever.dart';

const HOME_KEY = Key('home_key');

Widget getMaterialWidget(Widget child) {
  return MaterialApp(
    initialRoute: ROUTES_AUTH,
    routes: {
      ROUTES_AUTH: (context) => child,
      ROUTES_HOME: (context) => Scaffold(key: HOME_KEY,),
    },
  );
}

void main() {
  MaterialApp widget;
  String yourNameHintText = 'Your name';
  String passwordHintText = 'Password';
  String confirmPasswordHintText = 'Confirm your password';

  String signButtonText = 'Sign';
  String registerButtonText = 'Register';
  String nextButtonText = 'Next';
  String doneButtonText = 'Done';

  String pleaseWriteSomething = 'Please write something';
  String passwordDoesntMatch = 'The password doesn\'t match';

  String takenNameSnackbarText = 'That name is taken';
  String invalidSnackbarText = 'Invalid username or password';
  String errorSnackbarText = 'Something went wrong. Can you try again?';

  setUp(() async {
    HttpService.tokenRetriever = MockTokenRetriever();
    widget = getMaterialWidget(AuthPage());
  });

  group('Login Page', () {

    testWidgets('not typing anything will trigger two warning texts', (WidgetTester tester) async {
      await tester.pumpWidget(widget);
      await tester.tap(find.widgetWithText(FlatButton, signButtonText));
      await tester.pumpAndSettle();

      expect(find.text(pleaseWriteSomething), findsNWidgets(2));
    });

    testWidgets('not typing a username will trigger a warning text', (WidgetTester tester) async {
      await tester.pumpWidget(widget);
      await tester.enterText(find.widgetWithText(TextFormField, yourNameHintText), 'Wrong username');
      await tester.tap(find.widgetWithText(FlatButton, signButtonText));
      await tester.pumpAndSettle();

      expect(find.text(pleaseWriteSomething), findsOneWidget);
    });


    testWidgets('typing a wrong username will trigger a Snackbar with a specific message', (WidgetTester tester) async {
      HttpService.client = MockClient((request) async {
        return Response(jsonEncode({}), 401);
      });

      await tester.pumpWidget(widget);
      await tester.enterText(find.widgetWithText(TextFormField, yourNameHintText), 'Wrong username');
      await tester.enterText(find.widgetWithText(TextFormField, passwordHintText), 'Password');
      await tester.tap(find.widgetWithText(FlatButton, signButtonText));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(SnackBar, invalidSnackbarText), findsOneWidget);
    });

    testWidgets('a backend error will trigger a Snackbar with a specific message', (WidgetTester tester) async {
      HttpService.client = MockClient((request) async {
        return Response(jsonEncode({}), 500);
      });

      await tester.pumpWidget(widget);
      await tester.enterText(find.widgetWithText(TextFormField, yourNameHintText), 'Username');
      await tester.enterText(find.widgetWithText(TextFormField, passwordHintText), 'Password');
      await tester.tap(find.widgetWithText(FlatButton, signButtonText));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(SnackBar, errorSnackbarText), findsOneWidget);
    });

    testWidgets('a successful login will take the user to ROUTES_HOME', (WidgetTester tester) async {
      HttpService.client = MockClient((request) async {
        return Response(jsonEncode({}), 200);
      });

      await tester.pumpWidget(widget);
      await tester.enterText(find.widgetWithText(TextFormField, yourNameHintText), 'Username');
      await tester.enterText(find.widgetWithText(TextFormField, passwordHintText), 'Password');
      await tester.tap(find.widgetWithText(FlatButton, signButtonText));
      await tester.pumpAndSettle();

      expect(find.byType(AuthPage), findsNothing);
      expect(find.byKey(HOME_KEY), findsOneWidget);
    });
  });

  group('Register Page', () {
    String aPassword = 'a_password';
    String differentPassword = 'different_password';

    Future<void> goToRegisterPage(WidgetTester tester) async {
      await tester.pumpWidget(widget);
      await tester.tap(find.widgetWithText(FlatButton, registerButtonText));
      await tester.pumpAndSettle();
    }

    Future<void> enterAName(WidgetTester tester, bool valid) async {
      HttpService.client = MockClient((request) async {
        return Response(jsonEncode(valid), 200);
      });

      await goToRegisterPage(tester);
      await tester.enterText(find.widgetWithText(TextFormField, yourNameHintText), 'Username');
      await tester.tap(find.widgetWithText(FlatButton, nextButtonText));
      await tester.pumpAndSettle();
    }

    Future<void> enterAPassword(WidgetTester tester, String password) async {
      await tester.enterText(find.widgetWithText(TextFormField, passwordHintText), password);
      await tester.tap(find.widgetWithText(FlatButton, nextButtonText));
      await tester.pumpAndSettle();
    }

    testWidgets('tapping Register will take the user to the first registration step', (WidgetTester tester) async {
      await goToRegisterPage(tester);

      expect(find.widgetWithText(ValidatedInput, yourNameHintText), findsOneWidget);
      expect(find.widgetWithText(FlatButton, nextButtonText), findsOneWidget);
    });

    testWidgets('not entering a name will trigger a warning text', (WidgetTester tester) async {
      await goToRegisterPage(tester);
      await tester.tap(find.widgetWithText(FlatButton, nextButtonText));
      await tester.pumpAndSettle();

      expect(find.text(pleaseWriteSomething), findsOneWidget);
    });

    testWidgets('entering a taken name will trigger a Snackbar with a specific message', (WidgetTester tester) async {
      await enterAName(tester, false);

      expect(find.widgetWithText(SnackBar, takenNameSnackbarText), findsOneWidget);
    });

    testWidgets('entering a valid name will advance the user to the password screen', (WidgetTester tester) async {
      await enterAName(tester, true);

      expect(find.widgetWithText(ValidatedInput, passwordHintText), findsOneWidget);
      expect(find.widgetWithText(FlatButton, nextButtonText), findsOneWidget);
    });

    testWidgets('not typing a password will trigger a warning text', (WidgetTester tester) async {
      await enterAName(tester, true);
      await enterAPassword(tester, '');

      expect(find.text(pleaseWriteSomething), findsOneWidget);
    });

    testWidgets('typing a password will take the user to the confirmation screen', (WidgetTester tester) async {
      await enterAName(tester, true);
      await enterAPassword(tester, aPassword);

      expect(find.widgetWithText(ValidatedInput, confirmPasswordHintText), findsOneWidget);
      expect(find.widgetWithText(FlatButton, doneButtonText), findsOneWidget);
    });

    testWidgets('not typing a password confirmation will trigger a warning text', (WidgetTester tester) async {
      await enterAName(tester, true);
      await enterAPassword(tester, aPassword);

      await tester.tap(find.widgetWithText(FlatButton, doneButtonText));
      await tester.pumpAndSettle();

      expect(find.text(pleaseWriteSomething), findsOneWidget);
    });

    testWidgets('not typing the same password as before will trigger another warning text', (WidgetTester tester) async {
      await enterAName(tester, true);
      await enterAPassword(tester, aPassword);

      await tester.enterText(find.widgetWithText(TextFormField, confirmPasswordHintText), differentPassword);
      await tester.tap(find.widgetWithText(FlatButton, doneButtonText));
      await tester.pumpAndSettle();

      expect(find.text(passwordDoesntMatch), findsOneWidget);
    });

    testWidgets('typing the same password as before will complete registration', (WidgetTester tester) async {
      await enterAName(tester, true);
      await enterAPassword(tester, aPassword);
      HttpService.client = MockClient((request) async {
        return Response(jsonEncode({}), 200);
      });

      await tester.enterText(find.widgetWithText(TextFormField, confirmPasswordHintText), aPassword);
      await tester.tap(find.widgetWithText(FlatButton, doneButtonText));
      await tester.pumpAndSettle();

      expect(find.byType(AuthPage), findsNothing);
      expect(find.byKey(HOME_KEY), findsOneWidget);
    });
  });
}