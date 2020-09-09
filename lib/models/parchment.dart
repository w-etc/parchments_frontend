class Parchment {
  final int parentParchmentId;
  final int id;
  final String title;
  final String contents;
  final List<Parchment> continuations;

  Parchment({this.parentParchmentId, this.id, this.title, this.contents, this.continuations});

  factory Parchment.fromJson(Map<String, dynamic> json) {
    final continuations = json['continuations'] as List;
    return Parchment(
      parentParchmentId: json['parentParchment'] != null ? json['parentParchment']['id'] : null,
      id: json['id'],
      title: json['title'],
      contents: json['contents'],
      continuations: continuations?.map((innerParchment) => Parchment.fromJson(innerParchment))?.toList(),
    );
  }
}
