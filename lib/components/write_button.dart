import 'package:flutter/cupertino.dart';
import 'package:parchments_flutter/models/parchment.dart';
import '../routes.dart';

class WriteButton extends StatelessWidget {
  final Parchment parchment;

  WriteButton({
    Key key,
    this.parchment
  }) : super(key: key);

  void _write(BuildContext context) {
    Navigator.pushNamed(context, ROUTES_PARCHMENT_CREATE, arguments: parchment);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _write(context),
      child: Image(image: AssetImage('assets/pen_white.png'), width: 60,),
    );
  }
}