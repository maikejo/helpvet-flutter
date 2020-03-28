import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finey/animation/fade_animation.dart';
import 'package:flutter_finey/screens/social_widgets/ui/insta_activity_screen.dart';
import 'package:flutter_finey/screens/social_widgets/ui/insta_add_screen.dart';
import 'package:flutter_finey/screens/social_widgets/ui/insta_feed_screen.dart';
import 'package:flutter_finey/screens/social_widgets/ui/insta_profile_screen.dart';
import 'package:flutter_finey/screens/social_widgets/ui/insta_search_screen.dart';

import 'chat_screen.dart';

class InstaHomeScreen extends StatefulWidget {
  @override
  _InstaHomeScreenState createState() => _InstaHomeScreenState();
}

PageController pageController;

class _InstaHomeScreenState extends State<InstaHomeScreen> {

  int _page = 0;

  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  @override
  void initState() {
    super.initState();
    pageController = new PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void _redirectInstaAddScreen(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InstaAddScreen(),
      ),
    );
  }

  void _redirectUploadImagem(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InstaAddScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFF162A49),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FadeAnimation(3,FloatingActionButton(
          heroTag: "btPost",
          backgroundColor: Colors.pinkAccent,
          child: const Icon(Icons.add_a_photo),
          onPressed: _redirectInstaAddScreen
      )
      ),

      body: PageView(
        children: [
           Container(
            color: Colors.white,
            child: InstaFeedScreen(),
          ),
           Container(color: Colors.white, child: InstaSearchScreen()),
           Container(
            color: Colors.white,
            //child: InstaAddScreen(),
             child: ChatScreen(),
          ),
           Container(
              color: Colors.white, child: InstaActivityScreen()),
           Container(
              color: Colors.white,
              child: InstaProfileScreen()),
        ],
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: onPageChanged,
      ),

      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Color(0xFF162A49),
        activeColor: Colors.orange,
        items: <BottomNavigationBarItem>[
           BottomNavigationBarItem(
              icon: Icon(Icons.pets, color: (_page == 0) ? Colors.white : Colors.grey),
              title: Container(height: 0.0),
              backgroundColor: Colors.white),
           BottomNavigationBarItem(
              icon: Icon(Icons.search, color: (_page == 1) ? Colors.white : Colors.grey),
              title: Container(height: 0.0),
              backgroundColor: Colors.white),
           BottomNavigationBarItem(
              icon: Icon(Icons.group, color: (_page == 2) ? Colors.white : Colors.grey),
              title: Container(height: 0.0),
              backgroundColor: Colors.white),
           BottomNavigationBarItem(
              icon: Icon(Icons.star, color: (_page == 3) ? Colors.white : Colors.grey),
              title: Container(height: 0.0),
              backgroundColor: Colors.white),
         /* new BottomNavigationBarItem(
              icon: new Icon(Icons.person, color: (_page == 4) ? Colors.black : Colors.grey),
              title: new Container(height: 0.0),
              backgroundColor: Colors.white),*/
        ],
        onTap: navigationTapped,
        currentIndex: _page,
      ),
    );
  }
}