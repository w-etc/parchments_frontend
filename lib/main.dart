import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:parchments_flutter/models/parchment.dart';
import 'package:parchments_flutter/routes.dart';
import 'package:parchments_flutter/screens/continuations_page.dart';
import 'package:parchments_flutter/screens/create_parchment_page.dart';
import 'package:parchments_flutter/screens/login_page.dart';
import 'package:parchments_flutter/screens/parchment_page.dart';

Future main() async {
  await DotEnv().load('.env');
  //debugPaintSizeEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parchments',
      initialRoute: '/',
      // ignore: missing_return
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case ROUTES_HOME:
            return MaterialPageRoute(builder: (_) {
              return LoginPage();
            });
          case ROUTES_PARCHMENT_DETAIL:
            final Parchment parchment = settings.arguments;
            return MaterialPageRoute(builder: (_) {
              return ParchmentPage(parchment: parchment);
            });
          case ROUTES_PARCHMENT_CREATE:
            final Parchment parchment = settings.arguments;
            return MaterialPageRoute(builder: (_) {
              return CreateParchmentPage(parentParchment: parchment,);
            });
          case ROUTES_PARCHMENT_CONTINUATIONS:
            final Parchment parchment = settings.arguments;
            return MaterialPageRoute(builder: (_) {
              return ContinuationsPage(parchment: parchment,);
            });
        }
      },
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Colors.black,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}