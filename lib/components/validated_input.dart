import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parchments_flutter/constants/colors.dart';
import 'package:parchments_flutter/constants/fonts.dart';

class ValidatedInput extends StatefulWidget {
  final inputController = TextEditingController();
  final String hint;
  final bool obscureText;
  ValidatedInput({this.hint, this.obscureText});

  @override
  _ValidatedInputState createState() => _ValidatedInputState();

  String text() {
    return inputController.text;
  }
}

class _ValidatedInputState extends State<ValidatedInput> {
  bool activeFocus = false;
  bool valid = true;

  void _togglePenColor(bool hasFocus,) {
    setState(() {
      activeFocus = hasFocus;
    });
  }

  Color _getPenColor() {
    if (activeFocus && valid) return Colors.black;
    if (!activeFocus && valid) return Colors.black54;
    if (activeFocus && !valid) return ERROR_FOCUSED;
    if (!activeFocus && !valid) return ERROR_UNFOCUSED;
  }

  String _validator(value) {
    if (value.isEmpty) {
      setState(() {
        valid = false;
      });
      return 'Please write something';
    }
    setState(() {
      valid = true;
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Focus(
              child: TextFormField(
                validator: _validator,
                style: TextStyle(fontSize: 18, fontFamily: CINZEL,),
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: TextStyle(fontSize: 18, fontFamily: CINZEL),
                  contentPadding: EdgeInsets.only(bottom: -15),
                  errorStyle: TextStyle(
                    fontFamily: NOTO_SERIF,
                    color: ERROR_FOCUSED,
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: ERROR_UNFOCUSED,
                    ),
                  ),
                  focusedErrorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 2.0,
                      color: ERROR_FOCUSED,
                    ),
                  ),
                ),
                controller: widget.inputController,
                obscureText: widget.obscureText,
              ),
              onFocusChange: _togglePenColor,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Image(image: AssetImage('assets/pen_black.png'), height: 40, color: _getPenColor(),),
          ),
        ],
      ),
    );
  }
}