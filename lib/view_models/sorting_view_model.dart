import 'package:parchments_flutter/models/parchment.dart';
import 'package:parchments_flutter/models/sorting/sort.dart';

class SortingViewModel {
  List<Parchment> parchments;
  Function stateCallback;

  SortingViewModel(List<Parchment> parchments, Function stateCallback) {
    this.parchments = parchments;
    this.stateCallback = stateCallback;
  }

  void sortBy(Sort sort) {
    stateCallback(() {
      sort.sortParchments(parchments);
    });
  }
}