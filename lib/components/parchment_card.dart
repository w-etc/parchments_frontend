import 'package:flutter/material.dart';
import 'package:parchments_flutter/constants/fonts.dart';
import 'package:parchments_flutter/models/parchment.dart';
import 'package:parchments_flutter/routes.dart';

class ParchmentCard extends StatefulWidget {
  final Parchment parchment;
  ParchmentCard({this.parchment});

  @override
  _ParchmentCardState createState() => _ParchmentCardState();
}

class _ParchmentCardState extends State<ParchmentCard> {

  Future<void> _goToDetail() async {
    Navigator.pushNamed(context, ROUTES_PARCHMENT_DETAIL, arguments: widget.parchment.id);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: _goToDetail,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(border: Border.all(color: Colors.black,)),
          child: Column(
            children: [
              Text(widget.parchment.title, style: TextStyle(fontSize: 26, fontFamily: CINZEL,),),
              Text(widget.parchment.contents, style: TextStyle(fontSize: 16, fontFamily: NOTO_SERIF), textAlign: TextAlign.justify,),
            ],
          ),
        ),
      ),
    );
  }
}