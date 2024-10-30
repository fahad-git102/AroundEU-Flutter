import 'dart:io';
import 'package:flutter/material.dart';
import 'package:groupchat/component_library/text_widgets/extra_medium_text.dart';
import 'package:groupchat/core/static_keys.dart';
import 'package:groupchat/views/chat_screens/chat_screen.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_colors.dart';
import '../text_widgets/small_light_text.dart';

import 'package:open_filex/open_filex.dart';

class ClassMediaBottomSheet extends StatelessWidget {
  final List<FileWithType>? pickedFiles;
  final Function()? onSendTap;

  ClassMediaBottomSheet({super.key, this.pickedFiles, this.onSendTap});

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setModalState) {
        return Padding(
          padding: EdgeInsets.all(8.0.sp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10.sp),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: pickedFiles?.length ?? 0,
                  itemBuilder: (context, index) {
                    File? file = pickedFiles?[index].file;
                    MessageType? fileType = pickedFiles?[index].fileType;

                    return ListTile(
                      leading: GestureDetector(
                        onTap: () {
                          if (file != null) {
                            OpenFilex.open(file.path);
                          }
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(7.sp)),
                          child: fileType == MessageType.image
                              ? Image.file(file!, width: 50, height: 50, fit: BoxFit.cover)
                              : fileType == MessageType.document
                              ? Icon(Icons.file_copy_outlined, size: 50, color: AppColors.mainColorDark)
                              : Icon(Icons.video_library, size: 50, color: AppColors.mainColorDark),
                        ),
                      ),
                      title: Text(file!.path.split('/').last),
                      subtitle: Text(fileType?.name ?? ''),
                      trailing: IconButton(
                        icon: const Icon(Icons.clear, color: Colors.red),
                        onPressed: () {
                          setModalState(() {
                            pickedFiles?.removeAt(index);
                            if (pickedFiles?.isEmpty == true) {
                              Navigator.pop(context);
                            }
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.sp),
                child: const Divider(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 13.sp),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SmallLightText(title: '${pickedFiles?.length ?? 0} files'),
                    Container(
                      height: 36.sp,
                      width: 36.sp,
                      decoration: BoxDecoration(
                          color: AppColors.mainColor,
                          border: Border.all(color: AppColors.extraLightFadedTextColor, width: 0.2.sp),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.lightFadedTextColor,
                              offset: const Offset(0, 1),
                              blurRadius: 2.0,
                            ),
                          ]
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                        onPressed: onSendTap,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
