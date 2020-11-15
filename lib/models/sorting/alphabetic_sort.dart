import 'package:parchments_flutter/models/parchment.dart';
import 'package:parchments_flutter/models/sorting/sort.dart';

class AlphabeticSort extends Sort {
  AlphabeticSort() : super('Alphabetic');

  @override
  void sortParchments(List<Parchment> parchments) {
    parchments.sort((a, b) => a.title.compareTo(b.title));
  }
}
