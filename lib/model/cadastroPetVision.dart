class CadastroPetVision {
  final int userId;
  final int id;
  final String description;
  final String body;

  CadastroPetVision({this.userId, this.id, this.description, this.body});

  factory CadastroPetVision.fromJson(Map<String, dynamic> json) {
    return CadastroPetVision(
      userId: json['userId'],
      id: json['id'],
      description: json['description'],
      body: json['body'],
    );
  }
}