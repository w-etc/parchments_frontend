import 'package:flutter/material.dart';
import 'package:parchments_flutter/components/parchment_card/parchment_card_list.dart';
import 'package:parchments_flutter/components/parchments_navigation_bar.dart';
import 'package:parchments_flutter/components/search_bar.dart';
import 'package:parchments_flutter/models/parchment.dart';
import 'package:parchments_flutter/services/http_service.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Parchment>> coreParchments;

  @override
  void initState() {
    super.initState();
    coreParchments = HttpService.getCoreParchments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ParchmentsNavigationBar(),
      body: ListView(
        padding: EdgeInsets.only(left: 10, right: 10,),
        children: [
          SearchBar(),
          FutureBuilder<List<Parchment>>(
            future: coreParchments,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                    children: separatedParchmentCards(snapshot.data)
                );
              }
              return Container();
            },
          )
        ],
      ),
    );
  }
}