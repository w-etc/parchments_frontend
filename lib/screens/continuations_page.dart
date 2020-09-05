import 'package:flutter/material.dart';
import 'package:parchments_flutter/components/parchment_card.dart';
import 'package:parchments_flutter/models/parchment.dart';

class ContinuationsPage extends StatefulWidget {
  @override
  _ContinuationsPageState createState() => _ContinuationsPageState();
}

class _ContinuationsPageState extends State<ContinuationsPage> {

  @override
  Widget build(BuildContext context) {
    final List<Parchment> parchments = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 30, right: 30,),
        child: ListView(
          children: parchments.map((parchment) => ParchmentCard(parchment: parchment,)).toList(),
        ),
      )
    );
  }
}