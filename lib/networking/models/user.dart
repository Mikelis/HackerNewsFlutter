class User {
  String? about;
  int? created;
  String? id;
  int? karma;
  List<int>? submitted;

  User({this.about, this.created, this.id, this.karma, this.submitted});

  User.fromJson(Map<String, dynamic> json) {
    about = json['about'];
    created = json['created'];
    id = json['id'];
    karma = json['karma'];
    submitted = json['submitted'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['about'] = about;
    data['created'] = created;
    data['id'] = id;
    data['karma'] = karma;
    data['submitted'] = submitted;
    return data;
  }
}
