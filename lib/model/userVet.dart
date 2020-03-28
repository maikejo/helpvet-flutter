import 'package:cloud_firestore/cloud_firestore.dart';

class UserVet {
  final String nome;
  String email;
  final String imagemUrl;
  final String senha;
  final String tipo;
  final Timestamp dtCriacao;
  final int diasPlano;
  final bool ativado;
  final String cpfCnpj;
  final String registroMedico;
  final String cnpjClinica;


  UserVet({this.nome, this.email, this.imagemUrl, this.senha , this.tipo, this.dtCriacao, this.diasPlano, this.ativado, this.cpfCnpj, this.registroMedico,this.cnpjClinica});

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
      'cpfCnpj' : cpfCnpj,
      'registroMedico' : registroMedico,
      'cnpjClinica': cnpjClinica
    };
  }

  factory UserVet.fromJson(Map<String, Object> doc) {
    UserVet user = new UserVet(
        nome: doc['nome'],
        email: doc['email'],
        imagemUrl: doc['imagemUrl'],
        senha: doc['senha'],
        tipo: doc['tipo'],
        dtCriacao: doc['dtCriacao'],
        diasPlano: doc['diasPlano'],
        ativado: doc['ativado'],
        cpfCnpj: doc['cpfCnpj'],
        registroMedico: doc['registroMedico'],
        cnpjClinica: doc['cnpjClinica']

    );
    return user;
  }

  factory UserVet.fromDocument(DocumentSnapshot doc) {
    return UserVet.fromJson(doc.data);
  }
}
