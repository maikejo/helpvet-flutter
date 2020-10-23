import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String nome;
  String email;
  String imagemUrl;
   String senha;
   String tipo;
   Timestamp dtCriacao;
   int diasPlano;
   bool ativado;
   String cpf;
   String telefone;
   String crmv;

  User({this.nome,this.email,this.imagemUrl,this.senha,this.tipo,this.dtCriacao,
        this.diasPlano,this.ativado,this.cpf,this.telefone,this.crmv}
      );

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
      'telefone': telefone,
      'crmv': crmv
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
        crmv: doc['crmv']
    );
    return user;
  }

  factory User.fromDocument(DocumentSnapshot doc) {
    return User.fromJson(doc.data);
  }

  // Named constructor
  User.fromMap(Map<String, dynamic> mapData) {
    this.nome = mapData['nome'];
    this.email= mapData['email'];
    this.imagemUrl= mapData['imagemUrl'];
  /*  this.senha= mapData['senha'];
    this.tipo= mapData['tipo'];
    this.dtCriacao= mapData['dtCriacao'];
    this.diasPlano= mapData['diasPlano'];
    this.ativado= mapData['ativado'];
    this.cpf= mapData['cpf'];
    this.telefone= mapData['telefone'];*/
    //this.crmv= mapData['crmv'];
  }

}
