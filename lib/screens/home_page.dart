import 'package:flutter/material.dart';
import 'package:parchments_flutter/components/header_bar.dart';
import 'package:parchments_flutter/components/parchments_navigation_bar.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderBar(),
      bottomNavigationBar: ParchmentsNavigationBar(),
    );
  }
}