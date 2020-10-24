import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parchments_flutter/components/parchment_tile.dart';
import 'package:parchments_flutter/components/painters/vertical_line_painter.dart';
import 'package:parchments_flutter/components/parchments_drawer_header.dart';
import 'package:parchments_flutter/models/breadcrumb.dart';

class BreadcrumbsDrawer extends StatelessWidget {
  final List<Breadcrumb> breadcrumbs;
  BreadcrumbsDrawer({this.breadcrumbs});

  List<Widget> _tiles() {
    ParchmentTile firstTile = ParchmentTile(id: breadcrumbs.first.id, title: breadcrumbs.first.title);
    List<Widget> tiles = [firstTile];
    List<Breadcrumb> allButFirst = breadcrumbs.sublist(1);
    allButFirst.forEach((breadcrumb) {
      tiles.add(Padding(
        padding: const EdgeInsets.only(left: 30),
        child: CustomPaint(
          painter: VerticalLinePainter(height: 90.0),
        ),
      ),);
      tiles.add(ParchmentTile(id: breadcrumb.id, title: breadcrumb.title));
    });
    return tiles;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          ParchmentsDrawerHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(0.0),
              children: _tiles(),
            ),
          ),
        ],
      ),
    );
  }
}
