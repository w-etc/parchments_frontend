import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parchments_flutter/constants/fonts.dart';
import 'package:parchments_flutter/routes.dart';
import 'package:parchments_flutter/services/storage_provider.dart';

class ProfilePage extends StatefulWidget {

  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<String> futureUsername;

  @override
  void initState() {
    super.initState();
    futureUsername = StorageProvider().getUsername();
  }

  Future<void> _signOut() async {
    await StorageProvider().setToken(null);
    Navigator.pushNamed(context, ROUTES_HOME);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 250),
          child: Column(
            children: [
              FutureBuilder(
                future: futureUsername,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text('You signed as ${snapshot.data}', style: TextStyle(fontFamily: NOTO_SERIF, fontSize: 24.0,),);
                  }
                  return Text('');
                }
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: FlatButton(
                  onPressed: _signOut,
                  child: Text('Sign out', style: TextStyle(fontFamily: CINZEL, fontSize: 36.0),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
