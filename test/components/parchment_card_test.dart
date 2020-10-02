import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parchments_flutter/components/parchment_card/parchment_card.dart';
import 'package:parchments_flutter/models/parchment.dart';
import 'package:parchments_flutter/routes.dart';

const PARCHMENT_DETAIL_KEY = Key('parchment_detail_key');

Widget getMaterialWidget(Widget child) {
  return MaterialApp(
    home: child,
    routes: {
      ROUTES_PARCHMENT_DETAIL: (context) => Scaffold(key: PARCHMENT_DETAIL_KEY,)
    },
  );
}

void main() {
  String parchmentTitle = 'Title';
  String parchmentContents = 'Contents';
  Parchment parchment = Parchment(title: parchmentTitle, contents: parchmentContents);

  testWidgets('ParchmentCard displays a Parchment\'s title and contents', (WidgetTester tester) async {
    MaterialApp widget = getMaterialWidget(ParchmentCard(parchment: parchment,));
    await tester.pumpWidget(widget);

    expect(find.text(parchmentTitle), findsOneWidget);
    expect(find.text(parchmentContents), findsOneWidget);
  });

  testWidgets('ParchmentCard pushes ROUTES_PARCHMENT_DETAIL when tapped', (WidgetTester tester) async {
    MaterialApp widget = getMaterialWidget(ParchmentCard(parchment: parchment,));
    await tester.pumpWidget(widget);

    await tester.tap(find.byType(GestureDetector));
    await tester.pumpAndSettle();

    expect(find.byType(ParchmentCard), findsNothing);
    expect(find.byKey(PARCHMENT_DETAIL_KEY), findsOneWidget);
  });
}
