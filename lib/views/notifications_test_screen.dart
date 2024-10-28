import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groupchat/component_library/text_widgets/small_light_text.dart';

class NotificationsTestScreen extends StatefulWidget{
  static const route = 'NotificationsTestScreen';
  @override
  State<StatefulWidget> createState() => _NotificationsState();

}
class _NotificationsState extends State<NotificationsTestScreen>{
  @override
  Widget build(BuildContext context) {

    final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    return Scaffold(
      body: SafeArea(child: Container(
        child: Center(
          child: Column(
            children: [
              SmallLightText(
                title: '${message.notification!.title}',
              ),
              SmallLightText(
                title: '${message.notification!.body}',
              ),
              SmallLightText(
                title: '${message.data}',
              ),
            ],
          ),
        ),
      )),
    );
  }

}