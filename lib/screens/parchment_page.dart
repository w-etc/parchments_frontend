import 'package:flutter/material.dart';
import 'package:parchments_flutter/components/parchment_view.dart';
import 'package:parchments_flutter/models/parchment.dart';
import 'package:parchments_flutter/services/http_service.dart';

class ParchmentPage extends StatefulWidget {
  final Parchment parchment;

  const ParchmentPage({
    Key key,
    @required this.parchment,
  }): super(key: key);

  @override
  _ParchmentPageState createState() => _ParchmentPageState();
}

class _ParchmentPageState extends State<ParchmentPage> {
  Future<Parchment> futureParchment;

  @override
  void initState() {
    super.initState();
    futureParchment = HttpService.getParchment(widget.parchment.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Parchment>(
        future: futureParchment,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ParchmentView(parchment: snapshot.data,);
          }
          return Container();
        });
  }
}
