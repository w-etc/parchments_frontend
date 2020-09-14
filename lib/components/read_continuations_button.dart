import 'package:flutter/widgets.dart';
import 'package:parchments_flutter/models/parchment.dart';
import '../routes.dart';

class ReadContinuationsButton extends StatelessWidget {
  final Parchment parchment;

  ReadContinuationsButton({
    Key key,
    this.parchment
  }) : super(key: key);

  void _readContinuations(BuildContext context) {
    Navigator.pushNamed(context, ROUTES_PARCHMENT_CONTINUATIONS, arguments: parchment);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>_readContinuations(context),
      child: Image(image: AssetImage('assets/glasses_white.png'), width: 60,),
    );
  }
}