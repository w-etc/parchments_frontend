import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parchments_flutter/components/parchments_drawer_header.dart';
import 'package:parchments_flutter/components/question_mark_icon.dart';
import 'package:parchments_flutter/constants/fonts.dart';
import 'package:parchments_flutter/routes.dart';

class MenuDrawer extends StatelessWidget {

  void _goTo(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          ParchmentsDrawerHeader(),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 50),
            child: Image(image: AssetImage('icon.ico'), width: 50,),
          ),
          ListTile(
            title: Text('Home', style: TextStyle(fontFamily: CINZEL),),
            leading: Icon(Icons.home),
            onTap: () => _goTo(context, ROUTES_HOME),
          ),
          ListTile(
            title: Text('Random Parchment', style: TextStyle(fontFamily: CINZEL),),
            leading: QuestionMarkIcon(),
            onTap: () => _goTo(context, ROUTES_PARCHMENT_DETAIL_RANDOM),
          ),
        ],
      ),
    );
  }
}
