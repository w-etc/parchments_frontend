import 'package:parchments_flutter/models/breadcrumb.dart';

class Parchment {
  final int parentParchmentId;
  final int id;
  final String title;
  final String synopsis;
  final String contents;
  final List<Parchment> continuations;
  List<Breadcrumb> breadcrumbs;
  bool readerVoted;
  int voteCount;

  Parchment({this.parentParchmentId, this.id, this.title, this.synopsis, this.contents, this.continuations, this.breadcrumbs, this.readerVoted, this.voteCount});

  factory Parchment.fromJson(Map<String, dynamic> json) {
    final parchment = json;
    final continuations = parchment['continuations'] as List;
    return Parchment(
      parentParchmentId: parchment['parentParchment'] != null ? parchment['parentParchment']['id'] : null,
      id: parchment['id'],
      title: parchment['title'],
      synopsis: parchment['synopsis'],
      contents: parchment['contents'],
      continuations: continuations?.map((innerParchment) => Parchment.fromJson(innerParchment))?.toList(),
      readerVoted: parchment['readerVoted'],
      voteCount: parchment['voteCount'],
    );
  }
}
