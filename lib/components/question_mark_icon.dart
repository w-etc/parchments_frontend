import 'package:flutter/material.dart';
import 'package:parchments_flutter/constants/fonts.dart';

class QuestionMarkIcon extends StatelessWidget {
  const QuestionMarkIcon({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(Icons.lens, color: Colors.white, size: 30.0,),
        Text('?', style: TextStyle(fontFamily: CINZEL, fontWeight: FontWeight.bold, fontSize: 20.0),),
      ],
    );
  }
}
