import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parchments_flutter/constants/fonts.dart';
import 'package:parchments_flutter/constants/shared_preferences.dart';
import 'package:parchments_flutter/constants/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CreateParchmentPage extends StatefulWidget {

  @override
  _CreateParchmentPageState createState() => _CreateParchmentPageState();
}

class _CreateParchmentPageState extends State<CreateParchmentPage> {
  final parchmentTitleController = TextEditingController();
  final parchmentBodyController = TextEditingController();

  Future<void> _save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final writerId = await prefs.getInt(WRITER_ID);
    print(writerId);
    final response = await http.post(
        '$BACKEND_URL/parchment',
        headers: {'Content-type': 'application/json'},
        body: jsonEncode({
          'parchment': {'title': parchmentTitleController.text, 'contents': parchmentBodyController.text,},
          'writerId': writerId,
          'previousParchmentId': 1,
        })
    );
    if (response.statusCode == 200) {
      print('Success!');
      Navigator.pushNamed(context, '/parchment');
    } else {
      print('Failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FlatButton(
              onPressed: _save,
              child: Text('Save', textAlign: TextAlign.end, style: TextStyle(fontFamily: CINZEL, color: Colors.white, fontSize: 20,),),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 30, left: 40, right: 40,),
            child: TextFormField(
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 26, fontFamily: 'Cinzel',),
              decoration: InputDecoration.collapsed(
                hintText: 'Title',
                hintStyle: TextStyle(fontSize: 26, fontFamily: 'Cinzel',),
              ),
              controller: parchmentTitleController,
            ),
          ),
          NotificationListener<OverscrollIndicatorNotification>(
            // ignore: missing_return
            onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowGlow();
            },
            child: Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 50, left: 20, right: 20,),
                child: TextField(
                  maxLines: null,
                  decoration: InputDecoration.collapsed(hintText: 'Once upon a time...', hintStyle: TextStyle(fontFamily: NOTO_SERIF,),),
                  style: TextStyle(fontFamily: NOTO_SERIF,),
                  controller: parchmentBodyController,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}