import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parchments_flutter/constants/fonts.dart';
import 'package:parchments_flutter/models/parchment.dart';
import 'package:parchments_flutter/services/http_service.dart';
import 'package:parchments_flutter/services/storage_provider.dart';

class ParchmentVotes extends StatefulWidget {
  final Parchment parchment;

  ParchmentVotes({this.parchment});

  _ParchmentVotesState createState() => _ParchmentVotesState();
}

class _ParchmentVotesState extends State<ParchmentVotes> {

  Future<void> _toggleVote() async {
    if (!(await _canVote())) {
      return;
    }
    final result = await HttpService.toggleVote(widget.parchment);
    if (result) {
      setState(() {
        widget.parchment.readerVoted = !widget.parchment.readerVoted;
        if (widget.parchment.readerVoted) {
          widget.parchment.voteCount++;
        } else {
          widget.parchment.voteCount--;
        }
      });
    }
  }

  Future<bool> _canVote() {
    return StorageProvider().userIsAuthenticated();
  }

  Widget _thumbIcon(bool userCanVote) {
    if (!userCanVote) {
      return Stack(
        children: [
          Icon(Icons.thumb_up, color: Colors.grey,),
        ],
      );
    }
    return widget.parchment.readerVoted ? Icon(Icons.thumb_up) : Icon(Icons.thumb_up_outlined);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleVote,
      child: Padding(
        padding: const EdgeInsets.only(top: 20, right: 20),
        child: FutureBuilder<bool>(
          future: _canVote(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _thumbIcon(snapshot.data),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(widget.parchment.voteCount.toString(), style: TextStyle(fontFamily: CINZEL),),
                  ),
                ],
              );
            }
            return Container();
          }
        ),
      ),
    );
  }
}
