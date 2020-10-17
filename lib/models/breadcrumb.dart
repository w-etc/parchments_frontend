class Breadcrumb {
  final int id;
  final String title;

  Breadcrumb({this.id, this.title});

  factory Breadcrumb.fromJson(Map<String, dynamic> json) {
    return Breadcrumb(id: json['id'], title: json['title']);
  }
}
