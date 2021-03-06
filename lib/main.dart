import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:parchments_flutter/models/parchment.dart';
import 'package:parchments_flutter/models/redirection.dart';
import 'package:parchments_flutter/models/search_result.dart';
import 'package:parchments_flutter/routes.dart';
import 'package:parchments_flutter/screens/home_page.dart';
import 'package:parchments_flutter/screens/auth_page/auth_page.dart';
import 'package:parchments_flutter/screens/continuations_page.dart';
import 'package:parchments_flutter/screens/create_parchment_page.dart';
import 'package:parchments_flutter/screens/parchment_page.dart';
import 'package:parchments_flutter/screens/profile_page.dart';
import 'package:parchments_flutter/screens/random_parchment_page.dart';
import 'package:parchments_flutter/screens/search_results_page.dart';

Future main() async {
  await DotEnv().load('.env');
  // debugPaintSizeEnabled = true;
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
            return MyCustomRoute(builder: (_) {
              return HomePage();
            });
          case ROUTES_SEARCH_RESULTS:
            return MyCustomRoute(builder: (_) {
              final SearchResult searchResult = settings.arguments;
              return SearchResultsPage(searchResult);
            });
          case ROUTES_PROFILE:
            return MyCustomRoute(builder: (_) {
              return ProfilePage();
            });
          case ROUTES_AUTH:
            return MyCustomRoute(builder: (_) {
              final Redirection redirection = settings.arguments;
              return AuthPage(redirection: redirection);
            });
          case ROUTES_PARCHMENT_DETAIL:
            final Parchment parchment = settings.arguments;
            return MyCustomRoute(builder: (_) {
              return ParchmentPage(parchment: parchment);
            });
          case ROUTES_PARCHMENT_DETAIL_RANDOM:
            return MyCustomRoute(builder: (_) {
              return RandomParchmentPage();
            });
          case ROUTES_PARCHMENT_CREATE:
            final Parchment parchment = settings.arguments;
            return MyCustomRoute(builder: (_) {
              return CreateParchmentPage(parentParchmentId: parchment?.id,);
            });
          case ROUTES_PARCHMENT_CONTINUATIONS:
            final Parchment parchment = settings.arguments;
            return MyCustomRoute(builder: (_) {
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
        highlightColor: Colors.black,
      ),
    );
  }
}

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({ WidgetBuilder builder, RouteSettings settings })
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return new FadeTransition(opacity: animation, child: child);
  }
}
