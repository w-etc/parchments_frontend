import 'package:flutter/cupertino.dart';
import 'package:parchments_flutter/models/parchment.dart';
import 'package:parchments_flutter/util/navigator_util.dart';
import '../routes.dart';

class WriteButton extends StatelessWidget {
  final Parchment parchment;
  bool replaceRoute = false;

  WriteButton({
    Key key,
    this.parchment,
    this.replaceRoute,
  }) : super(key: key);

  Future<void> _write(BuildContext context) async {
    await takeAuthorizedUserTo(context, ROUTES_PARCHMENT_CREATE, parchment, replaceRoute);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => await _write(context),
      child: Image(image: AssetImage('assets/pen_circle_black.png'), width: 60,),
    );
  }
}