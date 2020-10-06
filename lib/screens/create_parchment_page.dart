import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parchments_flutter/constants/fonts.dart';
import 'package:parchments_flutter/models/parchment.dart';
import 'package:parchments_flutter/routes.dart';
import 'package:parchments_flutter/services/http_service.dart';

const TITLE_INPUT_KEY = Key('create_parchment_page_title_input');
const CONTENTS_INPUT_KEY = Key('create_parchment_page_contents_input');

class CreateParchmentPage extends StatefulWidget {
  final Parchment parentParchment;

  const CreateParchmentPage({
    Key key,
    @required this.parentParchment,
  }): super(key: key);


  @override
  _CreateParchmentPageState createState() => _CreateParchmentPageState();
}

class _CreateParchmentPageState extends State<CreateParchmentPage> {
  final parchmentTitleController = TextEditingController();
  final parchmentBodyController = TextEditingController();

  Future<void> _save(BuildContext context) async {
    Parchment createdParchment = await HttpService.createParchment(context, _currentParchment());
    if (createdParchment != null) {
      Navigator.pushReplacementNamed(context, ROUTES_PARCHMENT_DETAIL, arguments: createdParchment);
    }
  }

  Parchment _currentParchment() {
    return Parchment(parentParchmentId: _parentParchmentId(), title: parchmentTitleController.text, contents: parchmentBodyController.text);
  }

  int _parentParchmentId() {
    return widget.parentParchment != null ? widget.parentParchment.id : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Builder(
          builder: (BuildContext buildContext) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlatButton(
                  onPressed: () => _save(buildContext),
                  child: Text('Save', textAlign: TextAlign.end, style: TextStyle(fontFamily: CINZEL, color: Colors.white, fontSize: 20,),),
                )
              ],
            );
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 30, left: 40, right: 40,),
            child: TextField(
              key: TITLE_INPUT_KEY,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 26, fontFamily: CINZEL, fontWeight: FontWeight.bold,),
              decoration: InputDecoration.collapsed(
                hintText: 'Title',
                hintStyle: TextStyle(fontSize: 26, fontFamily: CINZEL, fontWeight: FontWeight.normal,),
              ),
              maxLines: null,
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
                  key: CONTENTS_INPUT_KEY,
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