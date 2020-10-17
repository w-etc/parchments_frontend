import 'package:flutter/material.dart';
import 'package:parchments_flutter/components/painters/angle_painter_down.dart';
import 'package:parchments_flutter/components/painters/angle_painter_up.dart';
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
    Navigator.pushNamed(context, ROUTES_PARCHMENT_DETAIL, arguments: widget.parchment);
  }

  void _showSynopsis() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Synopsis', style: TextStyle(fontFamily: CINZEL),),
        content: SingleChildScrollView(
            child: Text(widget.parchment.synopsis, style: TextStyle(fontFamily: NOTO_SERIF),),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30, top: 30),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _goToDetail,
        onLongPress: _showSynopsis,
        child: Container(
          child: Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: CustomPaint(
                  painter: AnglePainterUp(),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10,),
                child: Text(widget.parchment.title, style: TextStyle(fontSize: 26, fontFamily: CINZEL, fontWeight: FontWeight.bold,),),
              ),
              Container(
                padding: EdgeInsets.only(left: 25, right: 25, bottom: 10,),
                child: Text(widget.parchment.synopsis, style: TextStyle(fontSize: 14, fontFamily: NOTO_SERIF), textAlign: TextAlign.justify, maxLines: 6, overflow: TextOverflow.ellipsis,),
              ),
              Container(
                alignment: Alignment.bottomRight,
                child: CustomPaint(
                  painter: AnglePainterDown(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}