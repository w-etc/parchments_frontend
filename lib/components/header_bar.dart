import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parchments_flutter/constants/fonts.dart';

class HeaderBar extends StatelessWidget with PreferredSizeWidget {
  final double appBarHeight = 75.0;
  @override
  get preferredSize => Size.fromHeight(appBarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                IconButton(
                  iconSize: 40.0,
                  icon: Icon(Icons.account_circle, color: Colors.white,),
                  color: Colors.white,
                ),
                Text('You', style: TextStyle(fontFamily: CINZEL,),),
              ],
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.black54,
              blurRadius: 15.0,
              offset: Offset(0.0, 0.75))
        ],
        color: Colors.black,
      ),
    );
  }
}