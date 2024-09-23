import 'package:flutter/material.dart';
import 'package:groupchat/core/app_colors.dart';

class BottomTextfieldWidget extends StatelessWidget {

  TextEditingController? controller;
  Function()? onSendTap;
  Function()? onAttachmentTap;
  Function()? onMediaTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // TextField for typing messages
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.lightFadedTextColor,
                    offset: const Offset(0, 1),
                    blurRadius: 2.0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.emoji_emotions_outlined),
                    onPressed: () {
                      // Handle emoji button press
                    },
                  ),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.attach_file),
                    onPressed: () {
                      // Handle attachment button press
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () {
                      // Handle camera button press
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Send button
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.green,
            child: IconButton(
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
              onPressed: () {
                // Handle send message
              },
            ),
          ),
        ],
      ),
    );
  }

  BottomTextfieldWidget({
    super.key,
    this.controller,
    this.onSendTap,
    this.onAttachmentTap,
    this.onMediaTap,
  });
}

