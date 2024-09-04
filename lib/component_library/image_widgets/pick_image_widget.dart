import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groupchat/component_library/text_widgets/small_light_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_colors.dart';
import '../../core/assets_names.dart';

class PickImageWidget extends StatefulWidget {
  XFile? pickedFile;
  Function()? onTap;
  String? imageAvailableUrl;

  @override
  State<StatefulWidget> createState() => _PickImageState();

  PickImageWidget({
    this.pickedFile,
    this.imageAvailableUrl,
    this.onTap,
  });
}

class _PickImageState extends State<PickImageWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        width: 140.sp,
        height: 110.sp,
        padding: EdgeInsets.all(5.0.sp),
        decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black87.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(2, 3), // Shadow position
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(8.sp))),
        child: Align(
          alignment: Alignment.center,
          child: widget.pickedFile != null
              ? SizedBox(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.file(
                  File(widget.pickedFile!.path),
                  height: 110.0.sp,
                  width: 140.0.sp,
                  fit: BoxFit.cover,
                ),
              )) : widget.imageAvailableUrl != null
              ? CachedNetworkImage(
                  imageUrl: widget.imageAvailableUrl ?? '',
                  height: 110.sp,
                  width: 140.sp,
                )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Stack(
                        children: [
                          Image.asset(
                            height: 110.sp,
                            width: 140.sp,
                            Images.noImagePlaceHolder,
                            fit: BoxFit.cover,
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 5.0.sp),
                              child: SmallLightText(
                                title: "Choose image".tr(),
                                textColor: AppColors.lightFadedTextColor,
                                fontWeight: FontWeight.w200,
                                fontSize: 10.sp,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}
