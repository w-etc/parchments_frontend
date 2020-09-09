import 'package:flutter/material.dart';
import 'package:parchments_flutter/components/diamond_painter.dart';
import 'package:parchments_flutter/components/parchment_card.dart';
import 'package:parchments_flutter/constants/fonts.dart';
import 'package:parchments_flutter/models/parchment.dart';

class ContinuationsPage extends StatefulWidget {
  final List<Parchment> continuations;

  const ContinuationsPage({
    Key key,
    @required this.continuations,
  }): super(key: key);

  @override
  _ContinuationsPageState createState() => _ContinuationsPageState();
}

class _ContinuationsPageState extends State<ContinuationsPage> {

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child:
          widget.continuations != null
            ? ListView(
              padding: EdgeInsets.only(top: 50,left: 30, right: 30,),
              children: separatedParchmentCards(widget.continuations)
            )
            : Container(
                padding: EdgeInsets.only(top: 150, left: 30, right: 30,),
                child: Text('Nothing follows...', style: TextStyle(fontFamily: NOTO_SERIF, fontSize: 18),)
            ,)
      )
    );
  }
}