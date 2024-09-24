import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:groupchat/component_library/chat_widgets/bottom_textfield_widget.dart';
import 'package:groupchat/component_library/chat_widgets/receiver_message_widget.dart';
import 'package:groupchat/component_library/chat_widgets/sender_message_widget.dart';
import 'package:sizer/sizer.dart';

import '../../component_library/app_bars/custom_app_bar.dart';
import '../../core/assets_names.dart';
import '../../core/size_config.dart';

class ChatScreen extends StatefulWidget {
  static const route = 'ChatScreen';
  @override
  State<StatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  var list = [
    {'text': 'Hello there, this is a message 1', 'sender': true},
    {'text': 'Hello there, this is a message 2', 'sender': false},
    {'text': 'Hello there, this is a message 3', 'sender': false},
    {'text': 'Hello there, this is a message 4', 'sender': true},
    {'text': 'Hello there, this is a message 5', 'sender': false},
    {'text': 'Hello there, this is a message 6', 'sender': true},
    {'text': 'Hello there, this is a message 7', 'sender': false},
    {'text': 'Hello there, this is a message 8', 'sender': true},
    {'text': 'Hello there, this is a message 9', 'sender': false},
    {'text': 'Hello there, this is a message 10', 'sender': true},
    {'text': 'Hello there, this is a message 11', 'sender': false},
    {'text': 'Hello there, this is a message 12', 'sender': true},
    {'text': 'Hello there, this is a message 13', 'sender': true},
    {'text': 'Hello there, this is a message 14', 'sender': false},
    {'text': 'Hello there, this is a message 15', 'sender': true},
    {'text': 'Hello there, this is a message 16', 'sender': true},
    {'text': 'Hello there, this is a message 17', 'sender': false},
    {'text': 'Hello there, this is a message 18', 'sender': false},
    {'text': 'Hello there, this is a message 19', 'sender': true},
    {'text': 'Hello there, this is a message 20', 'sender': false},
    {'text': 'Hello there, this is a message 21', 'sender': true},
    {'text': 'Hello there, this is a message 22', 'sender': false},
    {'text': 'Hello there, this is a message 23', 'sender': true},
    {'text': 'Hello there, this is a message 24', 'sender': false},
    {'text': 'Hello there, this is a message 25', 'sender': true},
    {'text': 'Hello there, this is a message 26', 'sender': false},
    {'text': 'Hello there, this is a message 27', 'sender': false},
    {'text': 'Hello there, this is a message 28', 'sender': true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Images.mainBackground),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              // AppBar at the top
              CustomAppBar(
                title: 'Chat'.tr(),
              ),
              // Chat message list
              Expanded(
                child: ListView.builder(
                  itemCount: list.length,
                  padding: EdgeInsets.symmetric(horizontal: 13.sp),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return list[index]['sender'] == true
                        ? SenderMessageWidget(
                      text: list[index]['text'].toString(),
                    )
                        : ReceiverMessageWidget(
                      text: list[index]['text'].toString(),
                    );
                  },
                ),
              ),
              // Bottom input field with dynamic padding based on keyboard visibility
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom, // Adjusts padding when the keyboard is shown
                ),
                child: BottomTextfieldWidget(), // Your custom input widget
              ),
            ],
          ),
        ),
      ),
    );
  }
}

