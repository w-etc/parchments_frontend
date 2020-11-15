import 'package:parchments_flutter/models/parchment.dart';

abstract class Sort {
  String displayText;

  Sort(String displayText) {
    this.displayText = displayText;
  }

  void sortParchments(List<Parchment> parchments);
}
