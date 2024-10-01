import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groupchat/component_library/text_widgets/extra_medium_text.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:sizer/sizer.dart';

class PickMediaBottomsheet extends StatelessWidget{

  Function()? onMediaTap, onDocumentTap, onLocationTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220.sp,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0.sp),
          topRight: Radius.circular(20.0.sp),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10.0.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ExtraMediumText(
                  title: 'Pick Attachment'.tr(),
                  textColor: AppColors.lightBlack,
                ),
                IconButton(
                  icon: Icon(Icons.close, color: AppColors.lightBlack,),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
          const Divider(),
          _bottomSheetItem(
            context,
            icon: Icons.image,
            label: 'Media'.tr(),
            onTap: onMediaTap,
          ),
          _bottomSheetItem(
            context,
            icon: Icons.insert_drive_file,
            label: 'Document'.tr(),
            onTap: onDocumentTap,
          ),
          _bottomSheetItem(
            context,
            icon: Icons.location_on,
            label: 'Location'.tr(),
            onTap: onLocationTap,
          ),
        ],
      ),
    );
  }
  Widget _bottomSheetItem(
      BuildContext context, {
        required IconData icon,
        required String label,
        required Function()? onTap,
      }) {
    return ListTile(
      leading: Icon(icon, size: 30.sp, color: AppColors.lightBlack,),
      title: ExtraMediumText(title: label, textColor: AppColors.lightBlack,),
      onTap: onTap,
    );
  }

  PickMediaBottomsheet({super.key,
    this.onMediaTap,
    this.onDocumentTap,
    this.onLocationTap,
  });

}