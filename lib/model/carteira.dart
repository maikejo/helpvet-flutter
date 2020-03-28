class Carteira {
  String btc;
  String brl;

  Carteira({this.btc, this.brl});

  factory Carteira.fromJson(Map<String, dynamic> json) {
    return Carteira(btc: json['btc'], brl: json['brl']);
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["btc"] = btc;
    map["brl"] = brl;
    return map;
  }
}
