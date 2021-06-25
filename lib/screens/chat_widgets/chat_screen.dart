import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_finey/model/chat.dart';
import 'package:flutter_finey/model/user.dart';
import 'package:flutter_finey/screens/chat_widgets/call_screens/provider/user_provider.dart';
import 'package:flutter_finey/service/auth.dart';
import 'package:flutter_finey/util/call_utilities.dart';
import 'package:flutter_finey/util/dialog.dart';
import 'package:flutter_finey/util/permissions.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'call_screens/pickup/pickup_layout.dart';
import 'full_screen_image.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatScreen extends StatefulWidget {
  String name;
  String photoUrl;
  String receiverUid;
  String peerId;
  String peerAvatar;
  ChatScreen({this.name, this.photoUrl, this.receiverUid,this.peerId,this.peerAvatar});

  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Chat _message;
  var _formKey = GlobalKey<FormState>();
  var map = Map<String, dynamic>();
  CollectionReference _collectionReference;
  DocumentReference _receiverDocumentReference;
  DocumentReference _senderDocumentReference;
  DocumentReference _documentReference;
  DocumentSnapshot documentSnapshot;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _senderuid;
  var listItem;
  String receiverPhotoUrl, senderPhotoUrl, receiverName, senderName;
  StreamSubscription<DocumentSnapshot> subscription;
  File imageFile;
  StorageReference _storageReference;
  TextEditingController _messageController;
  final ScrollController listScrollController = new ScrollController();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  final String serverToken = 'AAAA_Z6kcx0:APA91bFBB7obavZseCgN3jRuhM0EnCWh4MyLYjyhNbs22HGlUncXZu3a_C-3xgVPTloJ8u9tSbp3hnWYwsZfURJoKshBGMHRwnbqa8MRQPilsj3z1UbA6Vc0LtJ5pi3XZzggcc-Yr9R7';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  UserProvider userProvider;

  User sender;
  User receiver;
  String _currentUserId;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    //readLocal();

    Auth.getCurrentFirebaseUser().then((user) {
      _currentUserId = user.email;

      setState(() {
        sender = User(
          email: 'veterinario@vet.com',
          nome: 'Vet',
          imagemUrl: 'https://firebasestorage.googleapis.com/v0/b/animal-home-care.appspot.com/o/maikejo%40gmail.com%2Fposts%2F1585517481889?alt=media&token=5e049c67-9463-4ea5-87bb-72722075c408',
        );

        receiver = User(
            email: 'maikejo@gmail.com',
            nome: 'Teste',
            imagemUrl: 'https://firebasestorage.googleapis.com/v0/b/animal-home-care.appspot.com/o/administrador%40adm.com%2Favatar%2Favatar?alt=media&token=b459a478-bb2c-4e18-9a5d-5938054fac46'
        );

      });
    });

    _messageController = TextEditingController();
    getUID().then((user) {
      setState(() {
        _senderuid = user.email;
        print("sender uid : $_senderuid");
        getSenderPhotoUrl(_senderuid).then((snapshot) {
          setState(() {
            senderPhotoUrl = snapshot['imagemUrl'];
            senderName = snapshot['nome'];
          });
        });
        getReceiverPhotoUrl(widget.receiverUid).then((snapshot) {
          setState(() {
            receiverPhotoUrl = snapshot['imagemUrl'];
            receiverName = snapshot['nome'];
          });
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
  }

  Future<void> initPlatformState() async {
    await [Permission.camera, Permission.microphone, Permission.storage]
        .request();
  }

  readLocal() async {
    Firestore.instance.collection('usuarios').document(Auth.user.email).updateData({'chattingWith': widget.receiverUid});

    setState(() {});
  }

  void addMessageToDb(Chat chat) async {
    print("Message : ${chat.mensagem}");
    map = chat.toMap();

    print("Map : ${map}");
    _collectionReference = Firestore.instance
        .collection("chat")
        .document(chat.senderUid)
        .collection(widget.receiverUid);

    _collectionReference.add(map).whenComplete(() {
      print("Messages added to db");
    });

    _collectionReference = Firestore.instance
        .collection("chat")
        .document(widget.receiverUid)
        .collection(chat.senderUid);

    _collectionReference.add(map).whenComplete(() {
      print("Messages added to db");
    });

    _messageController.text = "";
  }

  @override
  Widget build(BuildContext context) {

    return PickupLayout(
      scaffold: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: Colors.pinkAccent,
            title: Text(widget.name),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: IconButton(
                  icon: Icon(
                    Icons.video_call,
                  ),
                  onPressed: () async =>
                  await Permissions.cameraAndMicrophonePermissionsGranted()
                      ? CallUtils.dial(
                    from: sender,
                    to: receiver,
                    context: context,
                  )
                      : {},
                ),
              ),
            ],
          ),

          body: Form(
            key: _formKey,
            child: _senderuid == null
                ? Container(
              child: CircularProgressIndicator(),
            )
                : Column(
              children: <Widget>[
                //buildListLayout(),
                ChatMessagesListWidget(),
                Divider(
                  height: 20.0,
                  color: Colors.black,
                ),
                ChatInputWidget(),
                SizedBox(
                  height: 10.0,
                )
              ],
            ),
          ),
      ),
    );

  }

  Widget ChatInputWidget() {
    return Container(
      height: 55.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
              splashColor: Colors.white,
              icon: Icon(
                Icons.camera_alt,
                color: Colors.black,
              ),
              onPressed: () {
                pickImage();
              },
            ),
          ),
          Flexible(
            child: TextFormField(
              //textInputAction: TextInputAction.newline,
              //keyboardType: TextInputType.multiline,
             // maxLines: 20,
              validator: (String input) {
                if (input.isEmpty) {
                  return "Por favor insira a menssagem";
                }
              },
              controller: _messageController,
              decoration: new InputDecoration.collapsed(
                  hintText: "Escreva a menssagem...",
              ),
              onFieldSubmitted: (value) {
                _messageController.text = value;
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
              splashColor: Colors.white,
              icon: Icon(
                Icons.send,
                color: Colors.black,
              ),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  sendMessage();
                  FocusScope.of(context).requestFocus(new FocusNode());
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Future<String> pickImage() async {
    var selectedImage =
        await ImagePicker.pickImage(source: ImageSource.gallery,imageQuality: 80, maxHeight:  500 , maxWidth: 500);
    setState(() {
      imageFile = selectedImage;
    });
    _storageReference = FirebaseStorage.instance.ref().child(Auth.user.email + "/chat/imagens/" + '${DateTime.now().millisecondsSinceEpoch}');
    StorageUploadTask storageUploadTask = _storageReference.putFile(imageFile);
    var url = await (await storageUploadTask.onComplete).ref.getDownloadURL();

    print("URL: $url");

    Dialogs.showLoadingDialog(context, _keyLoader);
    uploadImageToDb(url);
    return url;
  }

  void uploadImageToDb(String downloadUrl) {
    _message = Chat.withoutMessage(
        receiverUid: widget.receiverUid,
        senderUid: _senderuid,
        photoUrl: downloadUrl,
        data: FieldValue.serverTimestamp(),
        tipo: 'imagem');
    var map = Map<String, dynamic>();
    map['senderUid'] = _message.senderUid;
    map['receiverUid'] = _message.receiverUid;
    map['data'] = _message.data;
    map['photoUrl'] = _message.photoUrl;

    print("Map : ${map}");
    _collectionReference = Firestore.instance
        .collection("chat")
        .document(_message.senderUid)
        .collection(widget.receiverUid);

    _collectionReference.add(map).whenComplete(() {
      print("Messages added to db");
    });

    _collectionReference = Firestore.instance
        .collection("chat")
        .document(widget.receiverUid)
        .collection(_message.senderUid);

    _collectionReference.add(map).whenComplete(() {
      print("Messages added to db");

      Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();

      listScrollController.animateTo(listScrollController.position.maxScrollExtent,duration: const Duration(microseconds: 10),curve: Curves.easeOut);
    });


  }

  void sendMessage() async {
    print("Inside send message");
    var text = _messageController.text;
    print(text);
    _message = Chat(
        receiverUid: widget.receiverUid,
        senderUid: _senderuid,
        mensagem: text,
        data: FieldValue.serverTimestamp(),
        tipo: 'texto');
    print(
        "receiverUid: ${widget.receiverUid} , senderUid : ${_senderuid} , mensagem: ${text}");
    print(
        "data: ${DateTime.now().millisecond}, tipo: ${text != null ? 'texto' : 'imagem'}");
    addMessageToDb(_message);

    //sendAndRetrieveMessage();

    listScrollController.animateTo(listScrollController.position.maxScrollExtent,duration: const Duration(microseconds: 10),curve: Curves.easeOut);

  }

  Future<FirebaseUser> getUID() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<DocumentSnapshot> getSenderPhotoUrl(String uid) {
    var senderDocumentSnapshot =
        Firestore.instance.collection('usuarios').document(uid).get();
    return senderDocumentSnapshot;
  }

  Future<DocumentSnapshot> getReceiverPhotoUrl(String uid) {
    var receiverDocumentSnapshot =
        Firestore.instance.collection('usuarios').document(uid).get();
    return receiverDocumentSnapshot;
  }

  Widget ChatMessagesListWidget() {
    print("SENDERUID : $_senderuid");
    return Flexible(
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('chat')
            .document(_senderuid)
            .collection(widget.receiverUid)
            .orderBy('data', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            listItem = snapshot.data.documents;
            return ListView.builder(
              reverse: false,
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) =>
                  chatMessageItem(snapshot.data.documents[index]),
              itemCount: snapshot.data.documents.length,
              controller: listScrollController,
            );
          }
        },
      ),
    );
  }

  Widget chatMessageItem(DocumentSnapshot documentSnapshot) {
    return buildChatLayout(documentSnapshot);
  }

  Widget buildChatLayout(DocumentSnapshot snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[

        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: snapshot['senderUid'] == _senderuid?
            MainAxisAlignment.end : MainAxisAlignment.start,
            children: <Widget>[
              snapshot['senderUid'] == _senderuid
                  ? CircleAvatar(
                      backgroundImage: senderPhotoUrl == null
                          ? AssetImage('images/ic_blank_image.png')
                          : CachedNetworkImageProvider(senderPhotoUrl),
                      radius: 20.0,
                    )
                  : CircleAvatar(
                      backgroundImage: receiverPhotoUrl == null
                          ? AssetImage('images/ic_blank_image.png')
                          : CachedNetworkImageProvider(receiverPhotoUrl),
                      radius: 20.0,
                    ),
              SizedBox(
                width: 10.0,
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  snapshot['senderUid'] == _senderuid
                      ? new Text(
                          senderName == null ? "" : senderName,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        )
                      : new Text(
                          receiverName == null ? "" : receiverName,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                  snapshot['tipo'] == 'texto'
                    ?  Container(
                          constraints: BoxConstraints(maxWidth: 200),
                          child: Text(
                          snapshot['mensagem'],
                          style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.black87,
                          fontSize: 14.0),
                          )
                        )
                    : InkWell(
                        onTap: (() {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => FullScreenImage(photoUrl: snapshot['photoUrl'],)));
                        }),
                        child: Hero(
                          tag: snapshot['photoUrl'],
                          child: FadeInImage(
                            image: CachedNetworkImageProvider(snapshot['photoUrl']),
                            placeholder: AssetImage('images/ic_blank_image.png'),
                            width: 200.0,
                            height: 200.0,
                          ),
                        ),
                      ),

                  Text(
                    DateFormat("dd/MM/yy hh:mm").format(DateTime.now()),
                    //DateFormat('dd/MM/yy kk:mm').format(DateTime.parse(snapshot.data['data'].toString())),
                    style: TextStyle(color: Colors.black12, fontSize: 12.0, fontStyle: FontStyle.italic),
                  ),


                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
