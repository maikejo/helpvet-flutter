class TranslateCloud {
  String description;
  double score;

  TranslateCloud({this.description, this.score});

  factory TranslateCloud.fromJson(Map<String, dynamic> json) {
    return TranslateCloud(
        description: json['description'],
        score: json['score']);
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["description"] = description;
    map["score"] = score;
    return map;
  }
}
