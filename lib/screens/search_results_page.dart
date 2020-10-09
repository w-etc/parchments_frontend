import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parchments_flutter/components/parchment_card/parchment_card_list.dart';
import 'package:parchments_flutter/models/parchment.dart';

class SearchResultsPage extends StatelessWidget {
  final List<Parchment> parchments;
  SearchResultsPage({this.parchments});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
          children: [
            ParchmentCardList(parchments: parchments,)
          ]
      ),
    );
  }
}
