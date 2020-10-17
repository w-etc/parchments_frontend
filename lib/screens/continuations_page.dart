import 'package:flutter/material.dart';
import 'package:parchments_flutter/components/menu_drawer.dart';
import 'package:parchments_flutter/components/parchment_card/parchment_card_list.dart';
import 'package:parchments_flutter/components/parchments_app_bar.dart';
import 'package:parchments_flutter/components/write_button.dart';
import 'package:parchments_flutter/constants/fonts.dart';
import 'package:parchments_flutter/models/parchment.dart';
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

  Future<void> _refresh() async {
    setState(() {
      futureParchments = HttpService.getContinuations(Parchment(id: widget.parchment.id, continuations: []));
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Parchment>>(
        future: futureParchments,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: ParchmentsAppBar(breadcrumbsActive: false,),
              drawer: MenuDrawer(),
              body: Container(
                alignment: Alignment.center,
                child:
                snapshot.data.length > 0
                  ? RefreshIndicator(
                    child: ListView(
                        padding: EdgeInsets.only(top: 50, left: 30, right: 30,),
                        children: [
                          ParchmentCardList(parchments: snapshot.data),
                        ],
                    ),
                    onRefresh: _refresh,
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
                            child: WriteButton(parchment: widget.parchment, replaceRoute: true),
                          ),
                        ),
                      ],
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