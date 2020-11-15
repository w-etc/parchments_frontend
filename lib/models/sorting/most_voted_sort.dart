import 'package:parchments_flutter/models/parchment.dart';
import 'package:parchments_flutter/models/sorting/sort.dart';

class MostVotedSort extends Sort {
  MostVotedSort() : super('Most voted');

  @override
  void sortParchments(List<Parchment> parchments) {
    parchments.sort((a, b) => b.voteCount.compareTo(a.voteCount));
  }
}
