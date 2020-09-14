import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

// Gotten from https://stackoverflow.com/questions/59044829/flutter-integration-testing-how-to-go-back-to-previous-screen-when-no-back-butt
Future<void> simulateBackButton(WidgetTester tester) async {
  final dynamic widgetsAppState = tester.state(find.byType(WidgetsApp));
  await widgetsAppState.didPopRoute();
  await tester.pumpAndSettle();
}