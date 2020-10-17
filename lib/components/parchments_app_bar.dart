import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ParchmentsAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize = Size.fromHeight(56.0);
  final bool breadcrumbsActive;

  ParchmentsAppBar({this.breadcrumbsActive});

  @override
  Widget build(BuildContext context) {
    Widget breadcrumbsAction = Builder(
      builder: (context) => IconButton(
        icon: Image(image: AssetImage('assets/breadcrumbs_black.png')),
        onPressed: () => Scaffold.of(context).openEndDrawer(),
        tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
      ),
    );

    return AppBar(
      backgroundColor: Colors.white,
      leading: null,
      iconTheme: IconThemeData(color: Colors.black),
      actions: breadcrumbsActive ? [breadcrumbsAction] : [],
    );
  }
}
