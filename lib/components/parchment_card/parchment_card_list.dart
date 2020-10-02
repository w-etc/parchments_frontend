import 'package:flutter/material.dart';
import 'package:parchments_flutter/components/painters/diamond_painter.dart';
import 'package:parchments_flutter/components/parchment_card/parchment_card.dart';
import 'package:parchments_flutter/models/parchment.dart';

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