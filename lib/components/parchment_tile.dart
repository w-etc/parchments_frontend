import 'package:flutter/cupertino.dart';
import 'package:parchments_flutter/components/painters/diamond_painter.dart';
import 'package:parchments_flutter/constants/fonts.dart';
import 'package:parchments_flutter/models/parchment.dart';
import 'package:parchments_flutter/routes.dart';

class ParchmentTile extends StatelessWidget {
  final int id;
  final String title;
  ParchmentTile({this.id, this.title});

  void _onTap(BuildContext context) {
    Navigator.pushNamed(context, ROUTES_PARCHMENT_DETAIL, arguments: Parchment(id: id));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _onTap(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: CustomPaint(
                painter: DiamondPainter(length: 30.0),
              ),
            ),
            Flexible(child: Text(title, style: TextStyle(fontSize: 18.0, fontFamily: CINZEL),)),
          ],
        ),
      ),
    );
  }
}
