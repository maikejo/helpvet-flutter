import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finey/model/cadastro_exame.dart';
import 'auth.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError, UnknownError }

class CadastroExameService {

  static void cadastrarExame(CadastroExame cadastroExame, String idPet) async {
    var map = Map<String, dynamic>();
    map = cadastroExame.toJson();

    CollectionReference _collectionReference = Firestore.instance.collection("exames").document(Auth.user.email).collection("lista").document(idPet).collection("lista");
    _collectionReference.add(map).whenComplete(() {
      print("Inserido com sucesso");
    });

  }


 static atualizaExame(documentId) {
   Firestore.instance
       .collection('exames')
       .document(Auth.user.email).collection("lista").document(documentId)
       .updateData(documentId)
       .catchError((e) {
     print(e);
   });
 }

 static deletaExam3(documentId) {
   Firestore.instance
       .collection('exames')
       .document(documentId).collection("lista").document(documentId)
       .delete()
       .catchError((e) {
     print(e);
   });
 }

}
