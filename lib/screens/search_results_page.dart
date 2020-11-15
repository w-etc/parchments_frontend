import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parchments_flutter/components/parchment_card/parchment_card_list.dart';
import 'package:parchments_flutter/components/parchment_sorting.dart';
import 'package:parchments_flutter/models/parchment.dart';
import 'package:parchments_flutter/models/search_result.dart';
import 'package:parchments_flutter/models/sorting/sort.dart';
import 'package:parchments_flutter/services/http_service.dart';


class SearchResultsPage extends StatefulWidget {
  String query;
  List<Parchment> parchments;

  SearchResultsPage(SearchResult searchResult) {
    this.parchments = searchResult.parchments;
    this.query = searchResult.query;
  }

  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {

  Future<void> sortParchments(Sort sort) async {
    final parchments = await HttpService.searchParchmentsByTitle(widget.query, sort);
    setState(() {
      widget.parchments = parchments;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
          padding: EdgeInsets.only(top: 50, left: 30, right: 30,),
          children: [
            ParchmentSorting(callback: sortParchments),
            ParchmentCardList(parchments: widget.parchments,)
          ]
      ),
    );
  }
}
