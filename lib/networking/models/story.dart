class Story {
  String? by;
  int? id;
  int? score;
  String? text;
  int? time;
  String? title;
  String? type;
  String? url;

  Story(
      {this.by,
        this.id,
        this.score,
        this.text,
        this.time,
        this.title,
        this.type,
        this.url});

  Story.fromJson(Map<String, dynamic> json) {
    by = json['by'];
    id = json['id'];
    score = json['score'];
    text = json['text'];
    time = json['time'];
    title = json['title'];
    type = json['type'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['by'] = by;
    data['id'] = id;
    data['score'] = score;
    data['text'] = text;
    data['time'] = time;
    data['title'] = title;
    data['type'] = type;
    data['url'] = url;
    return data;
  }
}
