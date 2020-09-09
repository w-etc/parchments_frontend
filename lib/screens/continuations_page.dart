import 'package:flutter/material.dart';
import 'package:parchments_flutter/components/diamond_painter.dart';
import 'package:parchments_flutter/components/parchment_card.dart';
import 'package:parchments_flutter/constants/fonts.dart';
import 'package:parchments_flutter/models/parchment.dart';
import 'package:parchments_flutter/routes.dart';
import 'package:parchments_flutter/services/http_service.dart';

class ContinuationsPage extends StatefulWidget {
  final Parchment parchment;

  const ContinuationsPage({
    Key key,
    @required this.parchment,
  }): super(key: key);

  @override
  _ContinuationsPageState createState() => _ContinuationsPageState();
}

class _ContinuationsPageState extends State<ContinuationsPage> {
  Future<List<Parchment>> futureParchments;

  @override
  void initState() {
    super.initState();
    futureParchments = HttpService.getContinuations(widget.parchment);
  }

  List<Widget> separatedParchmentCards(List<Parchment> parchments) {
    Parchment firstParchment = parchments.first;
    List<Widget> separatedCards = [ParchmentCard(parchment: firstParchment,)];
    List<Parchment> allButFirst = parchments.sublist(1);
    allButFirst.forEach((parchment) {
      separatedCards.add(Container(
        alignment: Alignment.center,
        child: CustomPaint(
          painter: DiamondPainter(length: 10),
        )
      ));
      separatedCards.add(ParchmentCard(parchment: parchment));
    });
    return separatedCards;
  }

  Future<bool> _onBack() async {
    Navigator.pushNamed(context, ROUTES_PARCHMENT_DETAIL, arguments: widget.parchment);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Parchment>>(
        future: futureParchments,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return WillPopScope(
              onWillPop: _onBack,
              child: Scaffold(
                  body: Container(
                      child:
                      snapshot.data.length > 0
                          ? ListView(
                          padding: EdgeInsets.only(top: 50,left: 30, right: 30,),
                          children: separatedParchmentCards(snapshot.data)
                      )
                          : Container(
                        padding: EdgeInsets.only(top: 150, left: 30, right: 30,),
                        child: Text('Nothing follows...', style: TextStyle(fontFamily: NOTO_SERIF, fontSize: 18),),
                      )
                  )
              ),
            );
          } else {
            return Text('${snapshot.error}');
          }
        }
    );
  }
}