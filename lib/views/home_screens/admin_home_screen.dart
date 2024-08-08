import 'package:flutter/material.dart';

import '../../component_library/text_widgets/medium_bold_text.dart';

class AdminHomeScreen extends StatefulWidget{
  static const route = 'AdminHomeScreen';
  @override
  State<StatefulWidget> createState() => _AdminHomeScreenState();

}

class _AdminHomeScreenState extends State<AdminHomeScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Container(
        child: Center(child: MediumBoldText(title: "Admin",),),
      )),
    );
  }

}