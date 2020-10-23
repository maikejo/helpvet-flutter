import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_finey/screens/social_widgets/models/comment.dart';
import 'package:flutter_finey/screens/social_widgets/models/like.dart';
import 'package:flutter_finey/screens/social_widgets/models/message.dart';
import 'package:flutter_finey/screens/social_widgets/models/post.dart';
import 'package:flutter_finey/screens/social_widgets/models/user.dart';


class FirebaseProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  User user;
  Post post;
  Like like;
  Message _message;
  Comment comment;
  //final GoogleSignIn _googleSignIn = GoogleSignIn();
  StorageReference _storageReference;

  Future<void> addDataToDb(FirebaseUser currentUser) async {
    print("Inside addDataToDb Method");

    _firestore
        .collection("display_names")
        .document(currentUser.displayName)
        .setData({'displayName': currentUser.displayName});

    user = User(
        uid: currentUser.uid,
        email: currentUser.email,
        displayName: currentUser.displayName,
        photoUrl: currentUser.photoUrl,
        followers: '0',
        following: '0',
        bio: '',
        posts: '0',
        phone: '');

    //  Map<String, String> mapdata = Map<String, dynamic>();

    //  mapdata = user.toMap(user);

    return _firestore
        .collection("usuarios")
        .document(currentUser.uid)
        .setData(user.toMap(user));
  }

  Future<bool> authenticateUser(FirebaseUser user) async {
    print("Inside authenticateUser");
    final QuerySnapshot result = await _firestore
        .collection("usuarios")
        .where("email", isEqualTo: user.email)
        .getDocuments();

    final List<DocumentSnapshot> docs = result.documents;

    if (docs.length == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    print("EMAIL ID : ${currentUser.email}");
    return currentUser;
  }

 /* Future<void> signOut() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    return await _auth.signOut();
  }*/

 /* Future<FirebaseUser> signIn() async {
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication =
        await _signInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: _signInAuthentication.accessToken,
      idToken: _signInAuthentication.idToken,
    );

    final FirebaseUser user = await _auth.signInWithCredential(credential);
    return user;
  }*/

  Future<String> uploadImageToStorage(File imageFile,String email) async {
    _storageReference = FirebaseStorage.instance
        .ref().child(email + "/posts/" + '${DateTime.now().millisecondsSinceEpoch}');
    StorageUploadTask storageUploadTask = _storageReference.putFile(imageFile);
    var url = await (await storageUploadTask.onComplete).ref.getDownloadURL();
    return url;
  }

  Future<void> addPostToDb(
      User currentUser, String imgUrl, String caption, String location) {
    CollectionReference _collectionRef = _firestore
        .collection("usuarios")
        .document(currentUser.email)
        .collection("posts");

    post = Post(
        currentUserUid: currentUser.email,
        imgUrl: imgUrl,
        caption: caption,
        location: location,
        postOwnerName: currentUser.displayName,
        postOwnerPhotoUrl: currentUser.photoUrl,
        time: FieldValue.serverTimestamp());

    return _collectionRef.add(post.toMap(post));
  }

  Future<User> retrieveUserDetails(FirebaseUser user) async {
    DocumentSnapshot _documentSnapshot =
        await _firestore.collection("usuarios").document(user.email).get();
    return User.fromMap(_documentSnapshot.data);
  }

  Future<List<DocumentSnapshot>> retrieveUserPosts(String userId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection("usuarios")
        .document(userId)
        .collection("posts")
        .getDocuments();
    return querySnapshot.documents;
  }

  Future<List<DocumentSnapshot>> fetchPostCommentDetails(
      DocumentReference reference) async {
    QuerySnapshot snapshot =
        await reference.collection("comments").getDocuments();
    return snapshot.documents;
  }

  Future<List<DocumentSnapshot>> fetchPostLikeDetails(
      DocumentReference reference) async {
    print("REFERENCE : ${reference.path}");
    QuerySnapshot snapshot = await reference.collection("likes").getDocuments();
    return snapshot.documents;
  }

  Future<bool> checkIfUserLikedOrNot(
      String userId, DocumentReference reference) async {
    DocumentSnapshot snapshot =
        await reference.collection("likes").document(userId).get();
    print('DOC ID : ${snapshot.reference.path}');
    return snapshot.exists;
  }

  Future<List<DocumentSnapshot>> retrievePosts(FirebaseUser user) async {
    List<DocumentSnapshot> list = List<DocumentSnapshot>();
    List<DocumentSnapshot> updatedList = List<DocumentSnapshot>();
    QuerySnapshot querySnapshot;
    QuerySnapshot snapshot =
        await _firestore.collection("usuarios").getDocuments();
    for (int i = 0; i < snapshot.documents.length; i++) {
      if (snapshot.documents[i].documentID != user.email) {
        list.add(snapshot.documents[i]);
      }
    }
    for (var i = 0; i < list.length; i++) {
      querySnapshot =
          await list[i].reference.collection("posts").getDocuments();
      for (var i = 0; i < querySnapshot.documents.length; i++) {
        updatedList.add(querySnapshot.documents[i]);
      }
    }
    // fetchSearchPosts(updatedList);
    print("UPDATED LIST LENGTH : ${updatedList.length}");
    return updatedList;
  }

  Future<List<String>> fetchAllUserNames(FirebaseUser user) async {
    List<String> userNameList = List<String>();
    QuerySnapshot querySnapshot =
        await _firestore.collection("usuarios").getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != user.email) {
        userNameList.add(querySnapshot.documents[i].data['nome']);
      }
    }
    print("USERNAMES LIST : ${userNameList.length}");
    return userNameList;
  }

  Future<String> fetchUidBySearchedName(String name) async {
    String uid;
    List<DocumentSnapshot> uidList = List<DocumentSnapshot>();

    QuerySnapshot querySnapshot =
        await _firestore.collection("usuarios").getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      uidList.add(querySnapshot.documents[i]);
    }

    print("UID LIST : ${uidList.length}");

    for (var i = 0; i < uidList.length; i++) {
      if (uidList[i].data['nome'] == name) {
        uid = uidList[i].documentID;
      }
    }
    print("UID DOC ID: ${uid}");
    return uid;
  }

  Future<User> fetchUserDetailsById(String uid) async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection("usuarios").document(uid).get();
    return User.fromMap(documentSnapshot.data);
  }

  Future<void> followUser(
      {String currentUserId, String followingUserId}) async {
    var followingMap = Map<String, String>();
    followingMap['uid'] = followingUserId;
    await _firestore
        .collection("usuarios")
        .document(currentUserId)
        .collection("seguidores")
        .document(followingUserId)
        .setData(followingMap);

    var followersMap = Map<String, String>();
    followersMap['uid'] = currentUserId;

    return _firestore
        .collection("usuarios")
        .document(followingUserId)
        .collection("followers")
        .document(currentUserId)
        .setData(followersMap);
  }

  Future<void> unFollowUser(
      {String currentUserId, String followingUserId}) async {
    await _firestore
        .collection("usuarios")
        .document(currentUserId)
        .collection("seguidores")
        .document(followingUserId)
        .delete();

    return _firestore
        .collection("usuarios")
        .document(followingUserId)
        .collection("followers")
        .document(currentUserId)
        .delete();
  }

  Future<bool> checkIsFollowing(String name, String currentUserId) async {
    bool isFollowing = false;
    String uid = await fetchUidBySearchedName(name);
    QuerySnapshot querySnapshot = await _firestore
        .collection("usuarios")
        .document(user.email)
        .collection("seguidores")
        .getDocuments();

    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID == uid) {
        isFollowing = true;
      }
    }
    return isFollowing;
  }

  Future<List<DocumentSnapshot>> fetchStats({String uid, String label}) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection("usuarios")
        .document(user.email)
        .collection(label)
        .getDocuments();
    return querySnapshot.documents;
  }

  Future<void> updatePhoto(String photoUrl, String uid) async {
    Map<String, dynamic> map = Map();
    map['photoUrl'] = photoUrl;
    return _firestore.collection("usuarios").document(uid).updateData(map);
  }

  Future<void> updateDetails(
      String uid, String name, String bio, String email, String phone) async {
    Map<String, dynamic> map = Map();
    map['nome'] = name;
    map['bio'] = bio;
    map['email'] = email;
    map['phone'] = phone;
    return _firestore.collection("usuarios").document(email).updateData(map);
  }

  Future<List<String>> fetchUserNames(FirebaseUser user) async {
    DocumentReference documentReference =
        _firestore.collection("messages").document(user.uid);
    List<String> userNameList = List<String>();
    List<String> chatUsersList = List<String>();
    QuerySnapshot querySnapshot =
        await _firestore.collection("usuarios").getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != user.uid) {
        print("USERNAMES : ${querySnapshot.documents[i].documentID}");
        userNameList.add(querySnapshot.documents[i].documentID);
        //querySnapshot.documents[i].reference.collection("collectionPath");
        //userNameList.add(querySnapshot.documents[i].data['displayName']);
      }
    }

    for (var i = 0; i < userNameList.length; i++) {
      if (documentReference.collection(userNameList[i]) != null) {
        if (documentReference.collection(userNameList[i]).getDocuments() !=
            null) {
          print("CHAT USERS : ${userNameList[i]}");
          chatUsersList.add(userNameList[i]);
        }
      }
    }

    print("CHAT USERS LIST : ${chatUsersList.length}");

    return chatUsersList;

    // print("USERNAMES LIST : ${userNameList.length}");
    // return userNameList;
  }

  Future<List<User>> fetchAllUsers(FirebaseUser user) async {
    List<User> userList = List<User>();
    QuerySnapshot querySnapshot =
        await _firestore.collection("usuarios").where('tipo', isEqualTo: 'CLI').getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != user.email) {
        userList.add(User.fromMap(querySnapshot.documents[i].data));
        //userList.add(querySnapshot.documents[i].data[User.fromMap(mapData)]);
      }
    }
    print("USERSLIST : ${userList.length}");
    return userList;
  }

  void uploadImageMsgToDb(String url, String receiverUid, String senderuid) {
    _message = Message.withoutMessage(
        receiverUid: receiverUid,
        senderUid: senderuid,
        photoUrl: url,
        timestamp: FieldValue.serverTimestamp(),
        type: 'image');
    var map = Map<String, dynamic>();
    map['senderUid'] = _message.senderUid;
    map['receiverUid'] = _message.receiverUid;
    map['type'] = _message.type;
    map['timestamp'] = _message.timestamp;
    map['photoUrl'] = _message.photoUrl;

    print("Map : ${map}");
    _firestore
        .collection("messages")
        .document(_message.senderUid)
        .collection(receiverUid)
        .add(map)
        .whenComplete(() {
      print("Messages added to db");
    });

    _firestore
        .collection("messages")
        .document(receiverUid)
        .collection(_message.senderUid)
        .add(map)
        .whenComplete(() {
      print("Messages added to db");
    });
  }

  Future<void> addMessageToDb(Message message, String receiverUid) async {
    print("Message : ${message.message}");
    var map = message.toMap();

    print("Map : $map");
    await _firestore
        .collection("messages")
        .document(message.senderUid)
        .collection(receiverUid)
        .add(map);

    return _firestore
        .collection("messages")
        .document(receiverUid)
        .collection(message.senderUid)
        .add(map);
  }

  Future<List<DocumentSnapshot>> fetchFeed(FirebaseUser user) async {
    List<String> followingUIDs = List<String>();
    List<DocumentSnapshot> list =List<DocumentSnapshot>();

    QuerySnapshot querySnapshot = await _firestore
        .collection("usuarios")
        .document(user.email)
        .collection("seguidores")
        .getDocuments();

    for (var i = 0; i < querySnapshot.documents.length; i++) {
      followingUIDs.add(querySnapshot.documents[i].documentID);
    }

    print("FOLLOWING UIDS : ${followingUIDs.length}");

    for (var i = 0; i < followingUIDs.length; i++) {
      print("SDDSSD : ${followingUIDs[i]}");

    //retrievePostByUID(followingUIDs[i]);
     // fetchUserDetailsById(followingUIDs[i]);

      QuerySnapshot postSnapshot = await _firestore
          .collection("usuarios")
          .document(followingUIDs[i])
          .collection("posts").orderBy('time', descending: true)
          .getDocuments();
         // postSnapshot.documents;
      for (var i = 0; i < postSnapshot.documents.length; i++) {
        print("dad : ${postSnapshot.documents[i].documentID}");
        list.add(postSnapshot.documents[i]);
        print("ads : ${list.length}");
      } 
    }
   
    return list;
  }

   Future<List<String>> fetchFollowingUids(FirebaseUser user) async{
    List<String> followingUIDs = List<String>();
  
    QuerySnapshot querySnapshot = await _firestore
        .collection("usuarios")
        .document(user.email)
        .collection("seguidores")
        .getDocuments();

    for (var i = 0; i < querySnapshot.documents.length; i++) {
      followingUIDs.add(querySnapshot.documents[i].documentID);
    }

    for (var i = 0; i < followingUIDs.length; i++) {
      print("DDDD : ${followingUIDs[i]}");
    }
    return followingUIDs;
  }
}
