import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finey/config/routes.dart';
import 'package:flutter_finey/model/documentacao.dart';
import 'package:flutter_finey/model/user.dart';
import 'package:flutter/services.dart';
import 'package:flutter_finey/model/userVet.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError, UnknownError }

class Auth {
  static FirebaseUser user;
  static AuthResult result;

  static Future<String> signIn(String email, String password) async {
    result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    user = result.user;
    return user.email;
  }

  /* static Future<String> signInWithFacebok(String accessToken) async {
    user = await FirebaseAuth.instance
        .signInWithFacebook(accessToken: accessToken);
    return user.uid;
  }*/

  static Future<String> signUp(String email, String password) async {
    result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    user = result.user;
    return user.uid;
  }

  static Future<void> signOut() async {
    return FirebaseAuth.instance.signOut();
  }

  static Future<FirebaseUser> getCurrentFirebaseUser() async {
    user = await FirebaseAuth.instance.currentUser();
    return user;
  }

  static void addUser(User user) async {
    checkUserExist(user.email).then((value) {
      if (!value) {
        print("user ${user.nome} ${user.email} added");
        Firestore.instance
            .document("usuarios/${user.email}")
            .setData(user.toJson());
      } else {
        print("nome ${user.nome} ${user.email} exists");
      }
    });
  }

  static void addUserVet(UserVet user) async {
    checkUserExist(user.email).then((value) {
      if (!value) {
        print("user ${user.nome} ${user.email} added");
        Firestore.instance
            .document("usuarios/${user.email}")
            .setData(user.toJson());
      } else {
        print("nome ${user.nome} ${user.email} exists");
      }
    });
  }

  static void addDocumentacao(Documentacao documentacao) async {
    Firestore.instance
        .document("documentacao/${user.email}")
        .setData(documentacao.toJson());
  }

  static Future<bool> checkUserExist(String userID) async {
    bool exists = false;
    try {
      await Firestore.instance.document("users/$userID").get().then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }

  static Stream<User> getUser(String email) {
    return Firestore.instance
        .collection("usuarios")
        .where("email", isEqualTo: email)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.documents.map((doc) {
        return User.fromDocument(doc);
      }).first;
    });
  }

  static Future<User> getDadosUser(String email) async {
    DocumentSnapshot snapshot = await Firestore.instance.collection('usuarios').document(email).get();

    if (snapshot.data != null) {
      var nome = snapshot['nome'];
      var email = snapshot['email'];
      var imagemUrl = snapshot['imagemUrl'];
      var tipo = snapshot['tipo'];
      var dtCriacao = snapshot['dtCriacao'];
      var diasPlano = snapshot['diasPlano'];
      var ativado = snapshot['ativado'];
      var cpf = snapshot['cpf'];
      var telefone = snapshot['telefone'];

      User user = new User(
          nome: nome,
          email: email,
          imagemUrl: imagemUrl,
          tipo: tipo,
          dtCriacao: dtCriacao,
          diasPlano: diasPlano,
          ativado: ativado,
          cpf: cpf,
          telefone: telefone
      );
      return user;
    } else {
      return null;
    }
  }

  static Future<String> getNome(String id) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('usuarios').document(id).get();
    var channelName = snapshot['nome'];
    if (channelName is String) {
      return channelName;
    } else {}
  }

  static Future<String> geTipo(String id) async {
    DocumentSnapshot snapshot =
    await Firestore.instance.collection('usuarios').document(id).get();
    var tipo = snapshot['tipo'];
    if (tipo is String) {
      return tipo;
    } else {}
  }

  static Future<Documentacao> getDocumentacao(String id) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('documentacao').document(id).get();

    var _urlDocIdentificacao = snapshot['urlDocIdentificacao'];
    var _urlDocSelf = snapshot['urlDocSelf'];
    var _urlDocResidencia = snapshot['urlDocResidencia'];

    Documentacao documentacao = new Documentacao(
        urlDocIdentificacao: _urlDocIdentificacao,
        urlDocResidencia: _urlDocSelf,
        urlDocSelf: _urlDocResidencia);

    return documentacao;
  }

  static atualizaPlano(diasPlano, dtCriacao) {
    Firestore.instance
        .collection('usuarios')
        .document(Auth.user.email)
        .updateData({ 'diasPlano' : diasPlano, 'dtCriacao' : dtCriacao})
        .catchError((e) {
      print(e);
    });
  }

  static String getExceptionText(Exception e) {
    if (e is PlatformException) {
      switch (e.message) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          return 'User with this e-mail not found.';
          break;
        case 'The password is invalid or the user does not have a password.':
          return 'Invalid password.';
          break;
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          return 'No internet connection.';
          break;
        case 'The email address is already in use by another account.':
          return 'Email address is already taken.';
          break;
        default:
          return 'Unknown error occured.';
      }
    } else {
      return 'Unknown error occured.';
    }
  }
}
