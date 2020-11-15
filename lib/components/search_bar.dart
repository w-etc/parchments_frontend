import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parchments_flutter/constants/colors.dart';
import 'package:parchments_flutter/constants/fonts.dart';
import 'package:parchments_flutter/models/parchment.dart';
import 'package:parchments_flutter/models/search_result.dart';
import 'package:parchments_flutter/models/sorting/alphabetic_sort.dart';
import 'package:parchments_flutter/routes.dart';
import 'package:parchments_flutter/services/http_service.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final _searchController = TextEditingController();

  Future<void> _search() async {
    final parchments = await HttpService.searchParchmentsByTitle(_searchController.text, AlphabeticSort());
    if (parchments == null) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('There was an error with your search. Please try again', style: TextStyle(fontFamily: NOTO_SERIF),), backgroundColor: ERROR_FOCUSED,));
      return;
    }
    _redirectUserToResults(parchments);
  }

  void _redirectUserToResults(List<Parchment> parchments) {
    switch (parchments.length) {
      case 0: {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('We couldn\'t find anything with that title', style: TextStyle(fontFamily: NOTO_SERIF),), backgroundColor: ERROR_FOCUSED,));
      }
      break;

      case 1: {
        FocusManager.instance.primaryFocus.unfocus();
        Scaffold.of(context).hideCurrentSnackBar();
        Navigator.pushNamed(context, ROUTES_PARCHMENT_DETAIL, arguments: parchments[0]);
      }
      break;

      default: {
        FocusManager.instance.primaryFocus.unfocus();
        Scaffold.of(context).hideCurrentSnackBar();
        Navigator.pushNamed(context, ROUTES_SEARCH_RESULTS, arguments: SearchResult(query: _searchController.text, parchments: parchments));
      }
      break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 40.0),
      child: TextFormField(
        controller: _searchController,
        textInputAction: TextInputAction.search,
        onEditingComplete: _search,
        style: TextStyle(fontFamily: NOTO_SERIF),
        cursorColor: Colors.black,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          contentPadding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(25),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }
}
