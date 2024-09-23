import 'dart:math';

import 'package:flutter/material.dart';
import 'package:groupchat/component_library/text_widgets/extra_medium_text.dart';
import 'package:groupchat/core/app_colors.dart';

class CircleLetterWidget extends StatelessWidget {
  final String letter;
  final Color textColor;

  const CircleLetterWidget({
    required this.letter,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: getRandomColor(),
      radius: 24.0,
      child: ExtraMediumText(
        title: letter,
        textColor: AppColors.white,
      ), // Adjust the radius to your desired size
    );
  }

  Color getRandomColor() {
    Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }
}