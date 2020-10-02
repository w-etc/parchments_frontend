import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parchments_flutter/constants/fonts.dart';
import 'package:parchments_flutter/routes.dart';

class ParchmentsNavigationBar extends StatelessWidget {

  void _onTap(BuildContext context, int index) {
    if (index == 1) {
      Navigator.pushNamed(context, ROUTES_PARCHMENT_CREATE);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      backgroundColor: Colors.black,
      onTap: (index) => _onTap(context, index),
      items: [
        BottomNavigationBarItem(
          backgroundColor: Colors.white,
          icon: Icon(Icons.account_circle, color: Colors.white, size: 30.0,),
          title: Text('Account',),
        ),
        BottomNavigationBarItem(
          backgroundColor: Colors.white,
          icon: Icon(Icons.add_circle, color: Colors.white, size: 30.0,),
          title: Text('Write',),
        ),
        BottomNavigationBarItem(
          icon: Stack(
            alignment: Alignment.center,
            children: [
              Icon(Icons.lens, color: Colors.white, size: 30.0,),
              Text('?', style: TextStyle(fontFamily: CINZEL, fontWeight: FontWeight.bold),),
            ],
          ),
          title: Text('Random'),
        ),
      ],
    );
  }

}