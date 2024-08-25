import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:groupchat/component_library/text_widgets/extra_medium_text.dart';
import 'package:groupchat/component_library/text_widgets/small_light_text.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:groupchat/data/company_model.dart';
import 'package:sizer/sizer.dart';

import '../../core/size_config.dart';

class CompaniesListWidget extends StatelessWidget {
  String? title, address, companySize;
  bool? isAdmin;
  Function(int val)? onOptionSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      padding: EdgeInsets.all(10.0.sp),
      margin: EdgeInsets.only(bottom: 9.0.sp),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black87.withOpacity(0.25),
              blurRadius: 4,
              offset: const Offset(1, 1), // Shadow position
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(8.sp))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ExtraMediumText(
                  fontWeight: FontWeight.w300,
                  title: title,
                  textColor: AppColors.blue,
                ),
                SizedBox(
                  height: 2.0.sp,
                ),
                ExtraMediumText(
                  textColor: AppColors.lightBlack,
                  title: address,
                  decrease: 2,
                )
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SmallLightText(
                textColor: AppColors.fadedTextColor2,
                title: companySize,
              ),
              isAdmin == true
                  ? PopupMenuButton<int>(
                      // onSelected: (int value) {
                      //   if (value == 0) {
                      //     print("Edit tapped");
                      //   } else if (value == 1) {
                      //     // Handle delete action
                      //     print("Delete tapped");
                      //   }
                      // },
                      onSelected: onOptionSelected,
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<int>>[
                        PopupMenuItem<int>(
                          value: 0,
                          child: ListTile(
                            leading: const Icon(Icons.edit),
                            title: SmallLightText(title: 'Edit'.tr()),
                          ),
                        ),
                         PopupMenuItem<int>(
                          value: 1,
                          child: ListTile(
                            leading: const Icon(Icons.delete),
                            title: SmallLightText(title: 'Delete'.tr()),
                          ),
                        ),
                      ],
                      icon: const Icon(Icons.more_vert),
                    )
                  : Container(),
            ],
          )
        ],
      ),
    );
  }

  CompaniesListWidget(
      {this.title,
      this.address,
      this.companySize,
      this.isAdmin = false,
      this.onOptionSelected});
}
