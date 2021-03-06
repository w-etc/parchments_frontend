import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parchments_flutter/constants/colors.dart';
import 'package:parchments_flutter/constants/fonts.dart';
import 'package:parchments_flutter/models/exceptions/authentication_error.dart';
import 'package:parchments_flutter/models/parchment.dart';
import 'package:parchments_flutter/routes.dart';
import 'package:parchments_flutter/services/http_service.dart';
import 'package:parchments_flutter/services/storage_provider.dart';
import 'package:parchments_flutter/util/navigator_util.dart';

const TITLE_INPUT_KEY = Key('create_parchment_page_title_input');
const SYNOPSIS_INPUT_KEY = Key('create_parchment_page_synopsis_input');
const CONTENTS_INPUT_KEY = Key('create_parchment_page_contents_input');

class CreateParchmentPage extends StatefulWidget {
  int parentParchmentId;

  CreateParchmentPage({
    Key key,
    @required this.parentParchmentId,
  }): super(key: key);


  @override
  _CreateParchmentPageState createState() => _CreateParchmentPageState();
}

class _CreateParchmentPageState extends State<CreateParchmentPage> {
  bool _writingSynopsis = true;
  final _pageController = PageController(initialPage: 0);

  final parchmentTitleController = TextEditingController();
  final parchmentSynopsisController = TextEditingController();
  final parchmentBodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    StorageProvider().getParchmentInProgress()
    .then((Parchment parchment) {
      if (parchment != null) {
        widget.parentParchmentId = parchment.parentParchmentId;
        parchmentTitleController.text = parchment.title;
        parchmentSynopsisController.text = parchment.synopsis;
        parchmentBodyController.text = parchment.contents;
        StorageProvider().clearParchmentInProgress();
      }
    });
  }

  Future<void> _submit(BuildContext context) async {
    if (_writingSynopsis) {
      _pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeInOutQuart);
      return;
    }
    if (_emptyFieldRemains()) {
      Scaffold.of(context).showSnackBar(SnackBar(key: Key('create_parchment_empty_fields_snackbar'), content: Text('You left some fields empty', style: TextStyle(fontFamily: NOTO_SERIF),), backgroundColor: ERROR_FOCUSED,));
      return;
    }
    Scaffold.of(context).hideCurrentSnackBar();
    try {
      Parchment createdParchment = await HttpService.createParchment(context, _currentParchment());
      Navigator.pushReplacementNamed(context, ROUTES_PARCHMENT_DETAIL, arguments: createdParchment);
    } on AuthenticationError catch (e) {
      await _saveParchmentData();
      await takeUserToRefreshToken(context, ROUTES_PARCHMENT_CREATE, null);
    } on HttpException catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.message, style: TextStyle(fontFamily: NOTO_SERIF),), backgroundColor: ERROR_FOCUSED,));
    }
  }

  bool _emptyFieldRemains() {
    return parchmentTitleController.text.isEmpty
        || parchmentSynopsisController.text.isEmpty
        || parchmentBodyController.text.isEmpty;
  }

  bool _allFieldsEmpty() {
    return parchmentTitleController.text.isEmpty
        && parchmentSynopsisController.text.isEmpty
        && parchmentBodyController.text.isEmpty;
  }

  Future<void> _saveParchmentData() async {
    await StorageProvider().setParchmentInProgress(_currentParchment());
  }

  Future<bool> _confirmBack() async {
    if (_allFieldsEmpty()) {
      return true;
    }
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text('Discard this Parchment?', style: TextStyle(fontFamily: CINZEL),),
          actions: <Widget>[
            FlatButton(
              child: Text('No', style: TextStyle(fontFamily: NOTO_SERIF),),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: Text('Yes', style: TextStyle(fontFamily: NOTO_SERIF)),
              onPressed: () async {
                await StorageProvider().clearParchmentInProgress();
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      }
    );
  }

  Parchment _currentParchment() {
    return Parchment(parentParchmentId: _parentParchmentId(), title: parchmentTitleController.text, synopsis: parchmentSynopsisController.text, contents: parchmentBodyController.text);
  }

  int _parentParchmentId() {
    return widget.parentParchmentId ?? null;
  }

  void _onPageChanged(int page) {
    setState(() {
      _writingSynopsis = page == 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _confirmBack,
      child: Scaffold(
        appBar: AppBar(
          title: Builder(
            builder: (BuildContext buildContext) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FlatButton(
                    key: Key('create_parchments_submit_button'),
                    onPressed: () => _submit(buildContext),
                    child: Text(_writingSynopsis ? 'Next' : 'Save', textAlign: TextAlign.end, style: TextStyle(fontFamily: CINZEL, color: Colors.white, fontSize: 20,),),
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
                maxLength: 50,
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
            Expanded(
              child: PageView(
                onPageChanged: _onPageChanged,
                controller: _pageController,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 50, left: 20, right: 20,),
                    child: TextField(
                      key: SYNOPSIS_INPUT_KEY,
                      maxLines: null,
                      decoration: InputDecoration.collapsed(hintText: 'Synopsis', hintStyle: TextStyle(fontFamily: NOTO_SERIF,),),
                      style: TextStyle(fontFamily: NOTO_SERIF,),
                      controller: parchmentSynopsisController,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 50, left: 20, right: 20,),
                    child: TextField(
                      key: CONTENTS_INPUT_KEY,
                      maxLines: null,
                      decoration: InputDecoration.collapsed(hintText: 'Once upon a time...', hintStyle: TextStyle(fontFamily: NOTO_SERIF,),),
                      style: TextStyle(fontFamily: NOTO_SERIF,),
                      controller: parchmentBodyController,
                    ),
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