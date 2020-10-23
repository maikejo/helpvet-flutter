import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_finey/model/call.dart';
import 'package:flutter_finey/model/user.dart';
import 'package:flutter_finey/screens/chat_widgets/call_screens/call_methods.dart';
import 'package:flutter_finey/screens/chat_widgets/call_screens/call_screen.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static dial({User from, User to, context}) async {
    Call call = Call(
      callerId: from.email,
      callerName: from.nome,
      callerPic: from.imagemUrl,
      receiverId: to.email,
      receiverName: to.nome,
      receiverPic: to.imagemUrl,
      channelId: Random().nextInt(1000).toString(),
    );

    bool callMade = await callMethods.makeCall(call: call);

    call.hasDialled = true;

    if (callMade) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallScreen(call: call),
          ));
    }
  }
}
