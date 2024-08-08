import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_colors.dart';
import '../text_widgets/extra_large_medium_bold_text.dart';

class PickImageDialog extends StatelessWidget {

  final Function()? onCameraTap;
  final Function()? onGalleryTap;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Container(
        padding: EdgeInsets.all(20.0.sp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ExtraLargeMediumBoldText(
              title: 'Select Action'.tr(),
              textColor: AppColors.lightBlack,
            ),
            SizedBox(
              height: 20.0.sp,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: onCameraTap,
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: AppColors.lightBlack,
                    size: 40.0.sp,
                  ),
                ),
                SizedBox(width: 50.0.sp,),
                InkWell(
                  onTap: onGalleryTap,
                  child: Icon(
                    Icons.photo_size_select_actual_outlined,
                    color: AppColors.lightBlack,
                    size: 40.0.sp,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  const PickImageDialog({
    required this.onCameraTap,
    required this.onGalleryTap,
  });
}
