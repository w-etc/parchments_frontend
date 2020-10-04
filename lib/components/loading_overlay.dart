import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parchments_flutter/constants/fonts.dart';

class LoadingOverlay extends StatefulWidget {
  final String text;

  LoadingOverlay({this.text});

  _LoadingOverlayState createState() => _LoadingOverlayState();
}

class _LoadingOverlayState extends State<LoadingOverlay> with SingleTickerProviderStateMixin {
  AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(duration: Duration(seconds: 1), vsync: this)..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  Future<bool> _onBack() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBack,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 30.0),
                child: RotationTransition(
                  turns: _rotationController,
                  child: Image(image: AssetImage('assets/glasses_white.png'), width: 60,),
                ),
              ),
              Text(widget.text, style: TextStyle(fontFamily: CINZEL, fontSize: 20.0),)
            ],
          ),
        ),
      ),
    );
  }
}
