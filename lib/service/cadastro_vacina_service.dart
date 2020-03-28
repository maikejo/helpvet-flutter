import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finey/model/cadastro_vacina.dart';
import 'auth.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError, UnknownError }

class CadastroVacinaService {

 /*static void cadastrarVacina(CadastroVacina cadastroVacina) async {
    CollectionReference _collectionReference;
    var map = Map<String, dynamic>();
    map = cadastroVacina.toJson();

    _collectionReference = Firestore.instance
        .collection("vacinas")
        .document(Auth.user.email)
        .collection("lista");

    String id = _collectionReference.document().documentID;

    _collectionReference.add(map).whenComplete(() {
      print("Inserido com sucesso");
    });

  }*/

  static void cadastrarVacina(CadastroVacina cadastroVacina, String idPet) async {
    var map = Map<String, dynamic>();
    map = cadastroVacina.toJson();

    CollectionReference _collectionReference = Firestore.instance.collection("vacinas").document(Auth.user.email).collection("lista").document(idPet).collection("lista");
    _collectionReference.add(map).whenComplete(() {
      print("Inserido com sucesso");
    });

  }

 static atualizaVacina(documentId) {
   Firestore.instance
       .collection('vacinas')
       .document(Auth.user.email).collection("lista").document(documentId)
       .updateData(documentId)
       .catchError((e) {
     print(e);
   });
 }

 static deletaVacina(documentId) {
   Firestore.instance
       .collection('vacinas')
       .document(documentId).collection("lista").document(documentId)
       .delete()
       .catchError((e) {
     print(e);
   });
 }

}
