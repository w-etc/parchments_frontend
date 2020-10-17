import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parchments_flutter/components/breadcrumb_tile.dart';
import 'package:parchments_flutter/components/painters/vertical_line_painter.dart';
import 'package:parchments_flutter/models/breadcrumb.dart';

class BreadcrumbsDrawer extends StatelessWidget {
  final List<Breadcrumb> breadcrumbs;
  BreadcrumbsDrawer({this.breadcrumbs});

  List<Widget> _breadcrumbTiles() {
    BreadcrumbTile firstTile = BreadcrumbTile(breadcrumb: breadcrumbs.first);
    List<Widget> breadcrumbTiles = [firstTile];
    List<Breadcrumb> allButFirst = breadcrumbs.sublist(1);
    allButFirst.forEach((breadcrumb) {
      breadcrumbTiles.add(Padding(
        padding: const EdgeInsets.only(left: 30),
        child: CustomPaint(
          painter: VerticalLinePainter(height: 50.0),
        ),
      ),);
      breadcrumbTiles.add(BreadcrumbTile(breadcrumb: breadcrumb,));
    });
    return breadcrumbTiles;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 32.0,
            child: DrawerHeader(
              child: Container(),
              decoration: BoxDecoration(
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(0.0),
              children: _breadcrumbTiles(),
            ),
          ),
        ],
      ),
    );
  }
}
