import 'package:flutter/material.dart';
import 'package:parchments_flutter/components/loading_overlay.dart';
import 'package:parchments_flutter/components/painters/diamond_painter.dart';
import 'package:parchments_flutter/components/read_continuations_button.dart';
import 'package:parchments_flutter/components/write_button.dart';
import 'package:parchments_flutter/constants/fonts.dart';
import 'package:parchments_flutter/models/parchment.dart';
import 'package:parchments_flutter/routes.dart';
import 'package:parchments_flutter/services/http_service.dart';

class ParchmentPage extends StatefulWidget {
  final Parchment parchment;

  const ParchmentPage({
    Key key,
    @required this.parchment,
  }): super(key: key);

  @override
  _ParchmentPageState createState() => _ParchmentPageState();
}

class _ParchmentPageState extends State<ParchmentPage> {
  Future<Parchment> futureParchment;
  bool _isRandomParchment;
  String loadingText;

  @override
  void initState() {
    super.initState();
    _isRandomParchment = widget.parchment == null;
    if (_isRandomParchment) {
      loadingText = 'Bringing a random Parchment';
      futureParchment = HttpService.getRandomCoreParchment();
    } else {
      loadingText = 'Looking for the Parchment';
      futureParchment = HttpService.getParchment(widget.parchment.id);
    }
  }

  Future<bool> _onBack(Parchment parchment) async {
    if (parchment.parentParchmentId != null) {
      Navigator.pushNamed(context, ROUTES_PARCHMENT_CONTINUATIONS, arguments: Parchment(id: parchment.parentParchmentId, continuations: []));
    } else {
      Navigator.pushNamed(context, ROUTES_HOME);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Widget child = LoadingOverlay(text: loadingText);

    return FutureBuilder<Parchment>(
        future: futureParchment,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            child = WillPopScope(
              onWillPop: () => _onBack(snapshot.data),
              child: Scaffold(
                body: Center(
                  child: ListView(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 50,),
                        child: Column(
                          children: [
                            Container(
                                alignment: Alignment.center,
                                child: CustomPaint(
                                  painter: DiamondPainter(length: 20),
                                )
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 40),
                              child: Text(snapshot.data.title, style: TextStyle(fontSize: 26, fontFamily: CINZEL, fontWeight: FontWeight.bold,),),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 100, top: 15,),
                              child: Text(snapshot.data.contents, style: TextStyle(fontSize: 16, fontFamily: NOTO_SERIF, color: Colors.black,), textAlign: TextAlign.justify,),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 20,),
                              child: Text('What comes next?', style: TextStyle(fontSize: 28, fontFamily: CINZEL, color: Colors.black)),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ReadContinuationsButton(parchment: snapshot.data,),
                                WriteButton(parchment: snapshot.data,),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: child,
          );
        });
  }
}