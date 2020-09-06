import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parchments_flutter/constants/fonts.dart';
import 'package:parchments_flutter/models/parchment.dart';
import 'package:parchments_flutter/routes.dart';
import 'package:parchments_flutter/services/http_service.dart';

class CreateParchmentPage extends StatefulWidget {

  @override
  _CreateParchmentPageState createState() => _CreateParchmentPageState();
}

class _CreateParchmentPageState extends State<CreateParchmentPage> {
  final parchmentTitleController = TextEditingController();
  final parchmentBodyController = TextEditingController();

  Future<void> _save() async {
    final int previousParchmentId = ModalRoute.of(context).settings.arguments;
    await HttpService.createParchment(previousParchmentId, _currentParchment());
    Navigator.pushReplacementNamed(context, ROUTES_PARCHMENT_DETAIL, arguments: previousParchmentId);
  }

  Parchment _currentParchment() {
    return Parchment(title: parchmentTitleController.text, contents: parchmentBodyController.text);
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
              style: TextStyle(fontSize: 26, fontFamily: CINZEL,),
              decoration: InputDecoration.collapsed(
                hintText: 'Title',
                hintStyle: TextStyle(fontSize: 26, fontFamily: CINZEL,),
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