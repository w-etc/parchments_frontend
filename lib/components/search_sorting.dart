import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parchments_flutter/constants/fonts.dart';
import 'package:parchments_flutter/models/sorting/alphabetic_sort.dart';
import 'package:parchments_flutter/models/sorting/most_voted_sort.dart';
import 'package:parchments_flutter/models/sorting/sort.dart';
import 'package:parchments_flutter/view_models/sorting_view_model.dart';

class SearchSorting extends StatefulWidget {
  final SortingViewModel viewModel;

  SearchSorting({this.viewModel});

  _SearchSortingState createState() => _SearchSortingState();
}

class _SearchSortingState extends State<SearchSorting> with AutomaticKeepAliveClientMixin {
  static final Sort mostVoted = MostVotedSort();
  static final Sort alphabetic = AlphabeticSort();
  Sort activeSort = alphabetic;

  @override
  bool get wantKeepAlive => true;

  void _select(Sort sort) {
    setState(() {
      activeSort = sort;
    });
    widget.viewModel.sortBy(sort);
  }

  TextDecoration _filterDecoration(Sort sort) {
    if (_isActiveSort(sort)) {
      return null;
    }
    return TextDecoration.lineThrough;
  }

  bool _isActiveSort(Sort sort) {
    return sort == activeSort;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 25),
          child: Divider(thickness: 1.5, color: Colors.black),
        ),
        Text('Sort by', style: TextStyle(fontFamily: CINZEL, fontSize: 28, fontWeight: FontWeight.bold),),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () => _select(mostVoted),
              child: Text(mostVoted.displayText, style: TextStyle(fontFamily: NOTO_SERIF, fontSize: 20, decoration: _filterDecoration(mostVoted))),
            ),
            GestureDetector(
              onTap: () => _select(alphabetic),
              child: Text(alphabetic.displayText, style: TextStyle(fontFamily: NOTO_SERIF, fontSize: 20, decoration: _filterDecoration(alphabetic))),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 25, bottom: 50),
          child: Divider(thickness: 1.5, color: Colors.black),
        ),
      ],
    );
  }
}
