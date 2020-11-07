import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parchments_flutter/components/parchment_tile.dart';
import 'package:parchments_flutter/constants/fonts.dart';
import 'package:parchments_flutter/models/breadcrumb.dart';
import 'package:parchments_flutter/models/parchment.dart';
import 'package:parchments_flutter/routes.dart';
import 'package:parchments_flutter/services/http_service.dart';
import 'package:parchments_flutter/services/storage_provider.dart';

class ProfilePage extends StatefulWidget {

  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ScrollController _scrollController = ScrollController();
  Future<String> _futureUsername;
  Future<List<Parchment>> _futureParchments;

  @override
  void initState() {
    super.initState();
    _futureUsername = StorageProvider().getUsername();
    _futureParchments = HttpService.getWriterParchments();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _signOut() async {
    await StorageProvider().clearToken();
    Navigator.pushNamed(context, ROUTES_HOME);
  }

  List<ParchmentTile> _parchmentTiles(List<Parchment> parchments) {
    return parchments.map((parchment) => ParchmentTile(id: parchment.id, title: parchment.title)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FutureBuilder(
              future: _futureUsername,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                        padding: EdgeInsets.only(top: 50, left: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.account_circle, size: 48,),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(snapshot.data, style: TextStyle(fontFamily: NOTO_SERIF, fontSize: 24.0,),)
                            ),
                          ],
                        )
                    ),
                  );
                }
                return Container();
              }
            ),
            // Maybe in the future
            // Padding(
            //   padding: const EdgeInsets.only(left: 50, right: 50, bottom: 200),
            //   child: Row(
            //     children: [
            //       Column(
            //         children: [
            //           Image(image: AssetImage('assets/pen_circle_white.png'), width: 50,),
            //           Text('My Parchments', style: TextStyle(fontFamily: CINZEL, fontSize: 14),)
            //         ]
            //       ),
            //     ],
            //   ),
            // ),
            FutureBuilder(
              future: _futureParchments,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      height: 400,
                      child: MediaQuery.removePadding(
                        removeTop: true,
                        context: context,
                        child: Scrollbar(
                          isAlwaysShown: true,
                          controller: _scrollController,
                          child: NotificationListener<OverscrollIndicatorNotification>(
                            onNotification: (OverscrollIndicatorNotification overscroll) {
                              overscroll.disallowGlow();
                              return;
                            },
                            child: MediaQuery.removePadding(
                              removeTop: true,
                              context: context,
                                child: ListView(
                                  controller: _scrollController,
                                  children: _parchmentTiles(snapshot.data),
                                ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              }
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: FlatButton(
                onPressed: _signOut,
                child: Text('Sign out', style: TextStyle(fontFamily: CINZEL, fontSize: 24.0),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
