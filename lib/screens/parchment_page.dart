import 'package:flutter/material.dart';
import 'package:parchments_flutter/components/diamond_painter.dart';
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

  @override
  void initState() {
    super.initState();
    futureParchment = HttpService.getParchment(widget.parchment.id);
  }

  void _write(Parchment parchment) {
    Navigator.pushNamed(context, ROUTES_PARCHMENT_CREATE, arguments: parchment);
  }
  
  void _readContinuations(Parchment parchment) {
    Navigator.pushNamed(context, ROUTES_PARCHMENT_CONTINUATIONS, arguments: parchment);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: FutureBuilder<Parchment>(
          future: futureParchment,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
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
                            GestureDetector(
                              onTap: () =>_readContinuations(snapshot.data),
                              child: Image(image: AssetImage('assets/glasses_white.png'), width: 60,),
                            ),
                            GestureDetector(
                              onTap: () => _write(snapshot.data),
                              child: Image(image: AssetImage('assets/pen_white.png'), width: 60,),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Text('${snapshot.error}');
            }
          },
        ),
      ),
    );
  }
}