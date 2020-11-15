import 'package:parchments_flutter/models/parchment.dart';

class SearchResult {
  final String query;
  final List<Parchment> parchments;

  SearchResult({this.query, this.parchments});
}