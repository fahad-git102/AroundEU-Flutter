import 'package:flutter/material.dart';
import 'package:groupchat/component_library/text_widgets/medium_bold_text.dart';

class TeachersHomeScreen extends StatefulWidget{
  static const route = "TeachersHomeScreen";
  @override
  State<StatefulWidget> createState() => _TeachersHomeScreenState();

}

class _TeachersHomeScreenState extends State<TeachersHomeScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Container(
        child: Center(child: MediumBoldText(title: "Teacher",),),
      )),
    );
  }

}