import 'package:flutter/material.dart';
import 'package:parchments_flutter/components/parchment_card/parchment_card_list.dart';
import 'package:parchments_flutter/components/write_button.dart';
import 'package:parchments_flutter/constants/fonts.dart';
import 'package:parchments_flutter/models/parchment.dart';
import 'package:parchments_flutter/routes.dart';
import 'package:parchments_flutter/services/http_service.dart';

class ContinuationsPage extends StatefulWidget {
  final Parchment parchment;

  const ContinuationsPage({
    Key key,
    @required this.parchment,
  }): super(key: key);

  @override
  _ContinuationsPageState createState() => _ContinuationsPageState();
}

class _ContinuationsPageState extends State<ContinuationsPage> with TickerProviderStateMixin {
  Future<List<Parchment>> futureParchments;
  AnimationController _controller;
  Animation _firstAnimation;
  Animation _secondAnimation;
  Animation _thirdAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _firstAnimation = Tween(
        begin: 0.0,
        end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Interval(0.2, 0.6)));
    _secondAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Interval(0.6, 1.0)));
    _thirdAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Interval(0.6, 1.0)));
    _controller.forward();
    futureParchments = HttpService.getContinuations(widget.parchment);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<bool> _onBack() async {
    Navigator.pushNamed(context, ROUTES_PARCHMENT_DETAIL, arguments: widget.parchment);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Parchment>>(
        future: futureParchments,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return WillPopScope(
              onWillPop: _onBack,
              child: Scaffold(
                body: Container(
                  alignment: Alignment.center,
                  child:
                  snapshot.data.length > 0
                    ? ListView(
                        padding: EdgeInsets.only(top: 50,left: 30, right: 30,),
                        children: separatedParchmentCards(snapshot.data)
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FadeTransition(
                            opacity: _firstAnimation,
                            child: Container(
                              child: Text('Nothing follows...', style: TextStyle(fontSize: 28, fontFamily: CINZEL,),),
                            ),
                          ),
                          FadeTransition(
                            opacity: _secondAnimation,
                            child: Container(
                              padding: EdgeInsets.only(top: 50, bottom: 50,),
                              child: Text('Be the first', style: TextStyle(fontSize: 28, fontFamily: CINZEL,),),
                            ),
                          ),
                          FadeTransition(
                            opacity: _thirdAnimation,
                            child: Container(
                              child: WriteButton(parchment: widget.parchment,),
                            ),
                          ),
                        ],
                    ),
                ),
              ),
            );
          } else {
            return Container();
          }
        }
    );
  }
}