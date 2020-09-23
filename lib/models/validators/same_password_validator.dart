import 'package:parchments_flutter/components/validated_input.dart';
import 'package:parchments_flutter/models/validators/abstract_validator.dart';

class SamePasswordValidator extends Validator {
  final ValidatedInput inputToCompare;
  SamePasswordValidator({this.inputToCompare});

  @override
  String validate(value) {
    if (value.isEmpty) {
      return 'Please write something';
    }
    if (value != inputToCompare.text()) {
      return 'The password doesn\'t match';
    }
    return null;
  }
}