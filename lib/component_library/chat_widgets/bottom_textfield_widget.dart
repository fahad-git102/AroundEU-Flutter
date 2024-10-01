import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:sizer/sizer.dart';

class BottomTextfieldWidget extends StatelessWidget {
  TextEditingController? controller;
  Function()? onSendTap;
  Function()? onAttachmentTap;
  Function()? onCameraTap;
  bool? showSendButton;
  Function(String val)? onTextFieldChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    offset: const Offset(0, 1),
                    blurRadius: 2.0,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.emoji_emotions_outlined),
                    onPressed: () {
                      // Handle emoji button press
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onChanged: onTextFieldChanged,
                      decoration: InputDecoration(
                        hintText: 'Type a message...'.tr(),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.attach_file),
                    onPressed: onAttachmentTap,
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: onCameraTap,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 8.sp),
          // Send button or mic
          Container(
            height: 48.sp,
            width: 48.sp,
            decoration: BoxDecoration(
              color: AppColors.mainColor, // Main color for the button
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  offset: const Offset(0, 1),
                  blurRadius: 2.0,
                ),
              ],
            ),
            child: showSendButton == true
                ? IconButton(
              icon: Icon(
                Icons.send,
                color: AppColors.lightBlack,
              ),
              onPressed: onSendTap,
            ): IconButton(
              icon: Icon(
                Icons.send,
                color: AppColors.lightBlack,
              ),
              onPressed: onSendTap,
            )
          ),
        ],
      ),
    );
  }

  BottomTextfieldWidget({
    super.key,
    this.controller,
    this.onSendTap,
    this.showSendButton,
    this.onTextFieldChanged,
    this.onAttachmentTap,
    this.onCameraTap,
  });
}
