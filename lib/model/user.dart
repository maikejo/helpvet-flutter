import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String nome;
  String email;
  final String imagemUrl;
  final String senha;
  final String tipo;
  final Timestamp dtCriacao;
  final int diasPlano;
  final bool ativado;
  final String cpf;
  final String telefone;

  User({this.nome, this.email, this.imagemUrl, this.senha , this.tipo, this.dtCriacao, this.diasPlano, this.ativado,this.cpf,this.telefone});

  Map<String, Object> toJson() {
    return {
      'nome': nome,
      'email': email == null ? '' : email,
      'imagemUrl': imagemUrl,
      'senha': senha,
      'tipo': tipo,
      'dtCriacao' : dtCriacao,
      'diasPlano' : diasPlano,
      'ativado' : ativado,
      'cpf': cpf,
      'telefone': telefone
    };
  }

  factory User.fromJson(Map<String, Object> doc) {
    User user = new User(
        nome: doc['nome'],
        email: doc['email'],
        imagemUrl: doc['imagemUrl'],
        senha: doc['senha'],
        tipo: doc['tipo'],
        dtCriacao: doc['dtCriacao'],
        diasPlano: doc['diasPlano'],
        ativado: doc['ativado'],
        cpf: doc['cpf'],
        telefone: doc['telefone'],
    );
    return user;
  }

  factory User.fromDocument(DocumentSnapshot doc) {
    return User.fromJson(doc.data);
  }
}
