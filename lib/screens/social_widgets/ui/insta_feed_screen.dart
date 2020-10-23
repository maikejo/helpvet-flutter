import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finey/screens/social_widgets/models/like.dart';
import 'package:flutter_finey/screens/social_widgets/models/user.dart';
import 'package:flutter_finey/screens/social_widgets/resources/repository.dart';
import 'package:flutter_finey/screens/social_widgets/ui/chat_screen.dart';
import 'package:flutter_finey/screens/social_widgets/ui/comments_screen.dart';
import 'package:flutter_finey/screens/social_widgets/ui/insta_friend_profile_screen.dart';
import 'package:flutter_finey/screens/social_widgets/ui/likes_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'insta_add_screen.dart';

class InstaFeedScreen extends StatefulWidget {
  @override
  _InstaFeedScreenState createState() => _InstaFeedScreenState();
}

class _InstaFeedScreenState extends State<InstaFeedScreen> {
  var _repository = Repository();
  User currentUser, user, followingUser;
  IconData icon;
  Color color;
  List<User> usersList = List<User>();
  Future<List<DocumentSnapshot>> _future;
  bool _isLiked = false;
  List<String> followingUIDs = List<String>();

  @override
  void initState() {
    super.initState();
    fetchFeed();
  }

  void fetchFeed() async {
    FirebaseUser currentUser = await _repository.getCurrentUser();

    User user = await _repository.fetchUserDetailsById(currentUser.email);
    setState(() {
      this.currentUser = user;
    });

    followingUIDs = await _repository.fetchFollowingUids(currentUser);

    for (var i = 0; i < followingUIDs.length; i++) {
      print("DSDASDASD : ${followingUIDs[i]}");
      // _future = _repository.retrievePostByUID(followingUIDs[i]);
      this.user = await _repository.fetchUserDetailsById(followingUIDs[i]);
      print("user : ${this.user.email}");
      usersList.add(this.user);
      print("USERSLIST : ${usersList.length}");

      for (var i = 0; i < usersList.length; i++) {
        setState(() {
          followingUser = usersList[i];
          print("FOLLOWING USER : ${followingUser.uid}");
        });
      }
    }
    _future = _repository.fetchFeed(currentUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF162A49),
        centerTitle: true,
        elevation: 2.0,
        //leading: Icon(Icons.camera_alt, color: Colors.pink),
        title: Text("HelpVet - Social"),
        //SizedBox(height: 35.0, child: Image.asset("images/helpvet_logo.png")),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              color: Colors.pink,
              icon: Icon(Icons.camera_alt),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => InstaAddScreen())));
              },
            ),
          ),
        ],
      ),
      body: currentUser != null
          ? Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: postImagesWidget(),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget postImagesWidget() {
    return FutureBuilder(
      future: _future,
      builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasData) {
          print("FFFF : ${followingUser.email}");
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
                //shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: ((context, index) => listItem(
                      list: snapshot.data,
                      index: index,
                      user: followingUser,
                      currentUser: currentUser,
                    )));
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }

  Widget listItem({List<DocumentSnapshot> list, User user, User currentUser, int index}) {
    print("dadadadad : ${user.email}");

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(bottom: 0.0),
          height: MediaQuery.of(context).size.height / 15.5,
          child: Stack(
            children: <Widget>[
              Positioned(
            right: 0,
            left: 0,
            child: Container(
            color: Colors.indigo.withOpacity(.5),
            child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                icon: Icon(Icons.share, color: Colors.white),
                onPressed: () {
                Navigator.pop(context);
                },
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: ((context) => InstaFriendProfileScreen(
                                    name: list[index].data['postOwnerName'],
                                  ))));
                        },
                        child: new Container(
                          height: 40.0,
                          width: 40.0,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new NetworkImage(
                                    list[index].data['postOwnerPhotoUrl'])),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          InstaFriendProfileScreen(
                                            name: list[index].data['postOwnerName'],
                                          ))));
                            },
                            child: Padding(
                              padding: EdgeInsets.only(top: 15.0),
                              child: Text(
                                list[index].data['postOwnerName'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold
                                    ,color: Colors.white
                                    ,fontSize: 18.0),
                              ),
                            )

                          ),
                          list[index].data['location'] != null
                              ? Text(
                                  list[index].data['location'],
                                  style: TextStyle(color: Colors.grey),
                          )
                              : Container(),
                        ],
                      )
                    ],
                  ),
                  /*new IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: null,
              )*/
                ),
                IconButton(
                icon: Icon(
                Icons.star_border,
                color: Colors.white,
                ),
                onPressed: () {},
                ),
              ],
            ),
            ),
            ),
            ],
          ),
        ),
        /*Positioned(
          right: 0,
          left: 0,
          child: Container(
            color: Colors.black.withOpacity(.4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text(
                  "Netflixy",
                  style: Theme.of(context)
                      .textTheme
                      .title
                      .apply(color: Colors.white),
                ),
                IconButton(
                  icon: Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),*/
        /* CachedNetworkImage(
          imageUrl: list[index].data['imgUrl'],
          placeholder: ((context, s) => Center(
                child: CircularProgressIndicator(),
              )),
          width: 125.0,
          height: 250.0,
          fit: BoxFit.cover,
        ),*/
        Container(
          padding: EdgeInsets.only(bottom: 3.0),
          height: MediaQuery.of(context).size.height / 2.5,
          child: Stack(
          children: <Widget>[
            Positioned(
              bottom: 25,
              left: 0,
              right: 0,
              top: 0,
              child: ClipPath(
              child: Image.network(
                list[index].data['imgUrl'],
                fit: BoxFit.cover,
              ),
              ),
            ),
           /*Positioned(
            right: 0,
            left: 0,
            child: Container(
            color: Colors.black.withOpacity(.4),
            child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                Navigator.pop(context);
                },
                ),
                Text(
                "Netflixy",
                style: Theme.of(context)
                    .textTheme
                    .title
                    .apply(color: Colors.white),
                ),
                IconButton(
                icon: Icon(
                Icons.favorite_border,
                color: Colors.white,
                ),
                onPressed: () {},
                ),
              ],
            ),
            ),
            ),*/
            Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: () {
                if (!_isLiked) {
                  setState(() {
                    _isLiked = true;
                  });
                  // saveLikeValue(_isLiked);
                  postLike(list[index].reference, currentUser);
                } else {
                  setState(() {
                    _isLiked = false;
                  });
                  //saveLikeValue(_isLiked);
                  postUnlike(list[index].reference, currentUser);
                }
              },
            child: Container(
              decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                color: Colors.black45,
                blurRadius: 3.0,
                offset: Offset(0, 1)),
              ],
              ),
              padding: EdgeInsets.all(15.0),
              child: Icon(
              Icons.favorite,
              color: Colors.red,
              ),
              ),
            ),
            ),
            Positioned(
            bottom: 0,
            left: 260,
            right: 5,
            child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => CommentsScreen(
                            documentReference: list[index].reference,
                            user: currentUser,
                          ))));
                },
               child: Container(
                 decoration: BoxDecoration(
                   shape: BoxShape.circle,
                   color: Colors.white,
                   boxShadow: [
                     BoxShadow(
                         color: Colors.black45,
                         blurRadius: 3.0,
                         offset: Offset(0, 1)),
                   ],
                 ),
                 padding: EdgeInsets.all(13.0),
                 child: Icon(
                   FontAwesomeIcons.comment,
                   color: Colors.red,
                 ),
               ),
              ),


              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black45,
                        blurRadius: 3.0,
                        offset: Offset(0, 1)),
                  ],
                ),
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.share,
                  color: Colors.red,
                ),
              ),
            ],
            ),
            )
          ],
          ),
        ),
        /*Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                      child: _isLiked
                          ? Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : Icon(
                              FontAwesomeIcons.heart,
                              color: null,
                            ),
                      onTap: () {
                        if (!_isLiked) {
                          setState(() {
                            _isLiked = true;
                          });
                          // saveLikeValue(_isLiked);
                          postLike(list[index].reference, currentUser);
                        } else {
                          setState(() {
                            _isLiked = false;
                          });
                          //saveLikeValue(_isLiked);
                          postUnlike(list[index].reference, currentUser);
                        }
                      }),
                   SizedBox(
                    width: 16.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => CommentsScreen(
                                    documentReference: list[index].reference,
                                    user: currentUser,
                                  ))));
                    },
                    child: new Icon(
                      FontAwesomeIcons.comment,
                    ),
                  ),
                   SizedBox(
                    width: 16.0,
                  ),
                   Icon(FontAwesomeIcons.paperPlane),
                ],
              ),
              //new Icon(FontAwesomeIcons.bookmark)
            ],
          ),
        ),*/
        SizedBox(height: 20.0),
        FutureBuilder(
          future: _repository.fetchPostLikes(list[index].reference),
          builder:
              ((context, AsyncSnapshot<List<DocumentSnapshot>> likesSnapshot) {
            if (likesSnapshot.hasData) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => LikesScreen(
                                user: currentUser,
                                documentReference: list[index].reference,
                              ))));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 9.0),
                  child: likesSnapshot.data.length > 1
                      ? Text(
                          "Curtida por ${likesSnapshot.data[0].data['ownerName']} e ${(likesSnapshot.data.length - 1).toString()} outros",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      : Text(likesSnapshot.data.length == 1
                          ? "Curtida por ${likesSnapshot.data[0].data['ownerName']}"
                          : "0 outros"),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
        ),
        Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 9.0, vertical: 8.0),
            child: list[index].data['caption'] != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Wrap(
                        children: <Widget>[
                          /*Text(list[index].data['postOwnerName'],
                              style: TextStyle(fontWeight: FontWeight.bold)),*/
                         /* Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(list[index].data['caption']),
                          ),*/
                          Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: commentWidget(list[index].reference)
                          )
                        ],
                      ),

                    ],
                  )
                : commentWidget(list[index].reference)),
        SizedBox(height: 10.0),
        /*Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text("1 Day Ago", style: TextStyle(color: Colors.grey)),
        )*/
      ],
    );
  }

  Widget commentWidget(DocumentReference reference) {
    return FutureBuilder(
      future: _repository.fetchPostComments(reference),
      builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            child: Text(
              'Ver todos os ${snapshot.data.length} comentário...',
              style: TextStyle(color: Colors.pink),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => CommentsScreen(
                            documentReference: reference,
                            user: currentUser,
                          ))));
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }),
    );
  }

  void postLike(DocumentReference reference, User currentUser) {
    var _like = Like(
        ownerName: currentUser.displayName,
        ownerPhotoUrl: currentUser.photoUrl,
        ownerUid: currentUser.uid,
        timeStamp: FieldValue.serverTimestamp());
    reference
        .collection('likes')
        .document(currentUser.uid)
        .setData(_like.toMap(_like))
        .then((value) {
      print("Post Liked");
    });
  }

  void postUnlike(DocumentReference reference, User currentUser) {
    reference
        .collection("likes")
        .document(currentUser.uid)
        .delete()
        .then((value) {
      print("Post Unliked");
    });
  }
}

// class ListItem extends StatefulWidget {
//   final List<DocumentSnapshot> list;
//   final User user;
//   final User currentUser;
//   final int index;

//   ListItem({this.list, this.user, this.index, this.currentUser});

//   @override
//   _ListItemState createState() => _ListItemState();
// }

// class _ListItemState extends State<ListItem> {
//   var _repository = Repository();
//   bool _isLiked = false;
//   Future<List<DocumentSnapshot>> _future;

//   @override
//   Widget build(BuildContext context) {
//     print("USERRR : ${widget.user.uid}");
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: <Widget>[
//         Padding(
//           padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 8.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               Row(
//                 children: <Widget>[
//                   new Container(
//                     height: 40.0,
//                     width: 40.0,
//                     decoration: new BoxDecoration(
//                       shape: BoxShape.circle,
//                       image: new DecorationImage(
//                           fit: BoxFit.fill,
//                           image: new NetworkImage(widget.user.photoUrl)),
//                     ),
//                   ),
//                   new SizedBox(
//                     width: 10.0,
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       new Text(
//                         widget.user.displayName,
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       widget.list[widget.index].data['location'] != null
//                           ? new Text(
//                               widget.list[widget.index].data['location'],
//                               style: TextStyle(color: Colors.grey),
//                             )
//                           : Container(),
//                     ],
//                   )
//                 ],
//               ),
//               new IconButton(
//                 icon: Icon(Icons.more_vert),
//                 onPressed: null,
//               )
//             ],
//           ),
//         ),
//         CachedNetworkImage(
//           imageUrl: widget.list[widget.index].data['imgUrl'],
//           placeholder: ((context, s) => Center(
//                 child: CircularProgressIndicator(),
//               )),
//           width: 125.0,
//           height: 250.0,
//           fit: BoxFit.cover,
//         ),
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               new Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   GestureDetector(
//                       child: _isLiked
//                           ? Icon(
//                               Icons.favorite,
//                               color: Colors.red,
//                             )
//                           : Icon(
//                               FontAwesomeIcons.heart,
//                               color: null,
//                             ),
//                       onTap: () {
//                         if (!_isLiked) {
//                           setState(() {
//                             _isLiked = true;
//                           });
//                           // saveLikeValue(_isLiked);
//                           postLike(widget.list[widget.index].reference);
//                         } else {
//                           setState(() {
//                             _isLiked = false;
//                           });
//                           //saveLikeValue(_isLiked);
//                           postUnlike(widget.list[widget.index].reference);
//                         }

//                         // _repository.checkIfUserLikedOrNot(_user.uid, snapshot.data[index].reference).then((isLiked) {
//                         //   print("reef : ${snapshot.data[index].reference.path}");
//                         //   if (!isLiked) {
//                         //     setState(() {
//                         //       icon = Icons.favorite;
//                         //       color = Colors.red;
//                         //     });
//                         //     postLike(snapshot.data[index].reference);
//                         //   } else {

//                         //     setState(() {
//                         //       icon =FontAwesomeIcons.heart;
//                         //       color = null;
//                         //     });
//                         //     postUnlike(snapshot.data[index].reference);
//                         //   }
//                         // });
//                         // updateValues(
//                         //     snapshot.data[index].reference);
//                       }),
//                   new SizedBox(
//                     width: 16.0,
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: ((context) => CommentsScreen(
//                                     documentReference:
//                                         widget.list[widget.index].reference,
//                                     user: widget.currentUser,
//                                   ))));
//                     },
//                     child: new Icon(
//                       FontAwesomeIcons.comment,
//                     ),
//                   ),
//                   new SizedBox(
//                     width: 16.0,
//                   ),
//                   new Icon(FontAwesomeIcons.paperPlane),
//                 ],
//               ),
//               new Icon(FontAwesomeIcons.bookmark)
//             ],
//           ),
//         ),
//         FutureBuilder(
//           future:
//               _repository.fetchPostLikes(widget.list[widget.index].reference),
//           builder:
//               ((context, AsyncSnapshot<List<DocumentSnapshot>> likesSnapshot) {
//             if (likesSnapshot.hasData) {
//               return GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: ((context) => LikesScreen(
//                                 user: widget.currentUser,
//                                 documentReference:
//                                     widget.list[widget.index].reference,
//                               ))));
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: likesSnapshot.data.length > 1
//                       ? Text(
//                           "Liked by ${likesSnapshot.data[0].data['ownerName']} and ${(likesSnapshot.data.length - 1).toString()} others",
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         )
//                       : Text(likesSnapshot.data.length == 1
//                           ? "Liked by ${likesSnapshot.data[0].data['ownerName']}"
//                           : "0 Likes"),
//                 ),
//               );
//             } else {
//               return Center(child: CircularProgressIndicator());
//             }
//           }),
//         ),
//         Padding(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//             child: widget.list[widget.index].data['caption'] != null
//                 ? Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Wrap(
//                         children: <Widget>[
//                           Text(widget.user.displayName,
//                               style: TextStyle(fontWeight: FontWeight.bold)),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 8.0),
//                             child:
//                                 Text(widget.list[widget.index].data['caption']),
//                           )
//                         ],
//                       ),
//                       Padding(
//                           padding: const EdgeInsets.only(top: 4.0),
//                           child: commentWidget(
//                               widget.list[widget.index].reference))
//                     ],
//                   )
//                 : commentWidget(widget.list[widget.index].reference)),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//           child: Text("1 Day Ago", style: TextStyle(color: Colors.grey)),
//         )
//       ],
//     );
//   }

//   Widget commentWidget(DocumentReference reference) {
//     return FutureBuilder(
//       future: _repository.fetchPostComments(reference),
//       builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
//         if (snapshot.hasData) {
//           return GestureDetector(
//             child: Text(
//               'View all ${snapshot.data.length} comments',
//               style: TextStyle(color: Colors.grey),
//             ),
//             onTap: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: ((context) => CommentsScreen(
//                             documentReference: reference,
//                             user: widget.currentUser,
//                           ))));
//             },
//           );
//         } else {
//           return Center(child: CircularProgressIndicator());
//         }
//       }),
//     );
//   }

//   void postLike(DocumentReference reference) {
//     var _like = Like(
//         ownerName: widget.currentUser.displayName,
//         ownerPhotoUrl: widget.currentUser.photoUrl,
//         ownerUid: widget.currentUser.uid,
//         timeStamp: FieldValue.serverTimestamp());
//     reference
//         .collection('likes')
//         .document(widget.currentUser.uid)
//         .setData(_like.toMap(_like))
//         .then((value) {
//       print("Post Liked");
//     });
//   }

//   void postUnlike(DocumentReference reference) {
//     reference
//         .collection("likes")
//         .document(widget.currentUser.uid)
//         .delete()
//         .then((value) {
//       print("Post Unliked");
//     });
//   }
// }
