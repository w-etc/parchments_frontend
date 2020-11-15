import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parchments_flutter/components/parchment_card/parchment_card_list.dart';
import 'package:parchments_flutter/components/search_sorting.dart';
import 'package:parchments_flutter/models/parchment.dart';
import 'package:parchments_flutter/view_models/sorting_view_model.dart';


class SearchResultsPage extends StatefulWidget {
  List<Parchment> parchments;

  SearchResultsPage(List<Parchment> parchments) {
    this.parchments = parchments;
  }

  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  SortingViewModel _sortingViewModel;

  @override
  void initState() {
    super.initState();
    _sortingViewModel = SortingViewModel(widget.parchments, setState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
          padding: EdgeInsets.only(top: 50, left: 30, right: 30,),
          children: [
            SearchSorting(viewModel: _sortingViewModel),
            ParchmentCardList(parchments: _sortingViewModel.parchments,)
          ]
      ),
    );
  }
}
