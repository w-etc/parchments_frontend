import 'package:parchments_flutter/models/parchment.dart';

abstract class Sort {
  String displayText;
  String sortText;

  Sort(String displayText, String sortText) {
    this.displayText = displayText;
    this.sortText = sortText;
  }
}
