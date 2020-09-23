import 'package:parchments_flutter/models/validators/abstract_validator.dart';

class NoEmptyValidator extends Validator {

  @override
  String validate(value) {
    if (value.isEmpty) {
      return 'Please write something';
    }
    return null;
  }
}