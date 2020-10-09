import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parchments_flutter/components/painters/diamond_painter.dart';
import 'package:parchments_flutter/components/read_continuations_button.dart';
import 'package:parchments_flutter/components/write_button.dart';
import 'package:parchments_flutter/constants/fonts.dart';
import 'package:parchments_flutter/models/parchment.dart';
import '../routes.dart';

class ParchmentView extends StatelessWidget {
  final Parchment parchment;

  ParchmentView({this.parchment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    child: Text(parchment.title, style: TextStyle(fontSize: 26, fontFamily: CINZEL, fontWeight: FontWeight.bold,),),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 100, top: 15,),
                    child: Text(parchment.contents, style: TextStyle(fontSize: 16, fontFamily: NOTO_SERIF, color: Colors.black,), textAlign: TextAlign.justify,),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 20,),
                    child: Text('What comes next?', style: TextStyle(fontSize: 28, fontFamily: CINZEL, color: Colors.black)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ReadContinuationsButton(parchment: parchment,),
                      WriteButton(parchment: parchment, replaceRoute: false,),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
