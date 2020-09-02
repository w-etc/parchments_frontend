import 'dart:ui';

import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final String title = 'Login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final writerNameController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  Future<void> _login(String writer) async {
    Navigator.pushNamed(context, "/parchment");
  }

  _scrollToBottom() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(seconds: 3), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    return Scaffold(
      body: Container(
        child: ListView(
          controller: _scrollController,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 100, bottom: 300,),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Lorem Ipsum'),
                  Divider(thickness: 1.8, color: Colors.transparent, height: 25,),
                  Text('Vivamus ornare luctus metus vitae blandit. Maecenas pretium dolor vestibulum pharetra scelerisque. Vestibulum aliquam, odio congue cursus tempus, purus nulla vehicula orci, non pretium nisl nisi et ante. Pellentesque suscipit rutrum congue. Donec non dapibus libero. Suspendisse convallis risus et risus consequat iaculis. Nunc finibus neque orci, nec vehicula lacus laoreet at. Vestibulum scelerisque sagittis elit. Ut vestibulum lectus et tortor venenatis, et varius erat suscipit. In eros enim, pulvinar sit amet tempor vel, cursus eget diam.'),
                  Divider(thickness: 1.8, color: Colors.transparent, height: 25,),
                  Text('Vestibulum tincidunt purus eget ante sollicitudin finibus. Morbi quis aliquam odio, vitae pharetra velit. Suspendisse potenti. Nullam eget neque tincidunt, maximus quam sed, lacinia diam. Vestibulum faucibus diam egestas dignissim accumsan. Sed egestas eros sed porttitor mattis. Praesent et justo tellus. Cras interdum mauris mi, eu viverra lorem bibendum non. Cras aliquet mi id tempus dictum. Sed porta dui suscipit consequat ullamcorper. In commodo dignissim urna et facilisis. Nam a pretium sapien.'),
                  Divider(thickness: 1.8, color: Colors.transparent, height: 25,),
                  Text('Nulla quis nunc risus. Aliquam convallis velit ac ante aliquet sollicitudin. Quisque ultrices vitae lectus non cursus. Aenean auctor tempus diam, nec cursus felis congue in. Quisque vel imperdiet elit. Cras blandit bibendum purus, eu cursus turpis pellentesque a. Aliquam ac est sagittis, fringilla felis ut, sodales diam. Donec augue velit, egestas id congue eu, egestas eu dolor. Sed non mi pellentesque, pulvinar mauris vel, porta urna. Donec nisl tellus, consectetur at tellus molestie, suscipit venenatis ex. Suspendisse dignissim orci in risus pharetra, cursus vestibulum arcu maximus. Vivamus ut fermentum turpis, non vestibulum lorem.'),
                  Divider(thickness: 1.8, color: Colors.transparent, height: 25,),
                  Text('Donec eu rhoncus velit. In quis mattis lorem. Donec molestie sapien at eros porta tincidunt. Suspendisse sit amet malesuada metus. Quisque euismod auctor orci, eu sagittis sapien bibendum et. Praesent non interdum enim, sed iaculis nulla. Curabitur vel pharetra neque, vel tempor risus. Mauris nec tempor velit, et euismod ex.'),
                  Divider(thickness: 1.8, color: Colors.transparent, height: 25,),
                  Text('Aenean purus risus, congue ac erat sit amet, cursus gravida enim. Suspendisse potenti. Nunc semper diam imperdiet scelerisque porta. Cras tempor, eros vel sodales ullamcorper, arcu leo volutpat felis, quis mollis magna dui nec urna. Aliquam nisi tortor, laoreet sit amet iaculis a, rutrum dignissim odio. Nam sit amet nisi aliquet, accumsan felis quis, vehicula augue. Nulla facilisi. Maecenas sed dui bibendum, molestie risus nec, pellentesque libero. Maecenas lacinia tellus et libero pretium, eget cursus odio rutrum. Cras feugiat, tellus non fringilla bibendum, ex massa venenatis justo, nec euismod ligula orci consectetur lacus. Nam sit amet nisl eget urna molestie tincidunt quis eu arcu. In in tincidunt diam. Nunc porta lacus eleifend, bibendum massa eget, finibus diam. Integer in turpis dapibus, viverra velit condimentum, sagittis urna. Maecenas sagittis ut quam a bibendum.'),
                  Divider(thickness: 1.8, color: Colors.transparent, height: 250,),
                  Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          style: TextStyle(fontSize: 18, fontFamily: 'Cinzel'),
                          decoration: const InputDecoration(
                            hintText: 'Your name',
                            hintStyle: TextStyle(fontSize: 18, fontFamily: 'Cinzel'),
                            contentPadding: EdgeInsets.only(bottom: -15),
                          ),
                          controller: writerNameController,
                        ),
                      ),
                      Image(image: AssetImage('assets/feather_left.png'), width: 50,),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 50.0),
                    child: FlatButton(
                      onPressed: () => _login(writerNameController.text),
                      child: Text('Sign', style: TextStyle(fontSize: 36, fontFamily: 'Cinzel')),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
