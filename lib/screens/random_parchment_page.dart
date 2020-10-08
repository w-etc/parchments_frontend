import 'package:flutter/material.dart';
import 'package:parchments_flutter/components/loading_overlay.dart';
import 'package:parchments_flutter/components/parchment_view.dart';
import 'package:parchments_flutter/models/parchment.dart';
import 'package:parchments_flutter/services/http_service.dart';

class RandomParchmentPage extends StatefulWidget {
  @override
  _RandomParchmentPageState createState() => _RandomParchmentPageState();
}

class _RandomParchmentPageState extends State<RandomParchmentPage> {
  Future<Parchment> futureParchment;
  String loadingText = 'Bringing a random Parchment';

  @override
  void initState() {
    super.initState();
    futureParchment = HttpService.getRandomCoreParchment();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = LoadingOverlay(text: loadingText);

    return FutureBuilder<Parchment>(
        future: futureParchment,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            child = ParchmentView(parchment: snapshot.data,);
          }
          return AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: child,
          );
        });
  }
}
