import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parchments_flutter/components/question_mark_icon.dart';
import 'package:parchments_flutter/constants/colors.dart';
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

      default: {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Oops! The button doesn\'t work. Please try again', style: TextStyle(fontFamily: NOTO_SERIF),), backgroundColor: ERROR_FOCUSED,));
      }
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
          icon: QuestionMarkIcon(),
          title: Text('Random'),
        ),
      ],
    );
  }

}