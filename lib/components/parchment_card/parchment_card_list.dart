import 'package:flutter/material.dart';
import 'package:parchments_flutter/components/painters/diamond_painter.dart';
import 'package:parchments_flutter/components/parchment_card/parchment_card.dart';
import 'package:parchments_flutter/models/parchment.dart';

class ParchmentCardList extends StatelessWidget {
  final List<Parchment> parchments;
  ParchmentCardList({this.parchments});

  List<Widget> _separatedParchmentCards() {
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
    return Column(
      children: _separatedParchmentCards(),
    );
  }

}
