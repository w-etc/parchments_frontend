import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parchments_flutter/constants/fonts.dart';
import 'package:parchments_flutter/routes.dart';
import 'package:parchments_flutter/util/navigator_util.dart';

class ParchmentsNavigationBar extends StatelessWidget {

  Future<void> _onTap(BuildContext context, int index) async {
    switch(index) {
      case 0: {
        await takeAuthorizedUserTo(context, ROUTES_PROFILE, null, false);
      }
      break;

      case 1: {
        await takeAuthorizedUserTo(context, ROUTES_PARCHMENT_CREATE, null, false);
      }
      break;

      case 2: {
        Navigator.pushNamed(context, ROUTES_PARCHMENT_DETAIL_RANDOM);
      }
      break;

      default: { print("Invalid choice"); }
      break;
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
          icon: Image(image: AssetImage('assets/pen_circle_white.png'), width: 30,),
          title: Text('Write',),
        ),
        BottomNavigationBarItem(
          icon: Stack(
            alignment: Alignment.center,
            children: [
              Icon(Icons.lens, color: Colors.white, size: 30.0,),
              Text('?', style: TextStyle(fontFamily: CINZEL, fontWeight: FontWeight.bold, fontSize: 20.0),),
            ],
          ),
          title: Text('Random'),
        ),
      ],
    );
  }

}