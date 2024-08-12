import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:groupchat/component_library/app_bars/custom_app_bar.dart';
import 'package:groupchat/core/size_config.dart';
import 'package:sizer/sizer.dart';

import '../../component_library/text_widgets/extra_medium_text.dart';
import '../../core/app_colors.dart';
import '../../core/assets_names.dart';

class MyDocumentsScreen extends StatelessWidget {
  static const route = 'MyDocumentsScreen';
  List<String>? documentsList;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    if (documentsList == null) {
      documentsList = [];
      documentsList?.add('Privacy Policy'.tr());
      documentsList?.add('Terms of service'.tr());
      documentsList?.add('Study materials'.tr());
    }
    return Scaffold(
      body: SafeArea(
          child: Container(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Images.mainBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            CustomAppBar(
              title: 'My Documents'.tr(),
            ),
            SizedBox(
              height: 10.0.sp,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: documentsList?.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                return Container(
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
                      borderRadius: BorderRadius.all(Radius.circular(4.sp))),
                  child: Padding(
                    padding: EdgeInsets.all(10.0.sp),
                    child: ExtraMediumText(
                      textColor: AppColors.lightBlack,
                      title: documentsList?[index],
                    ),
                  ),
                );
              }),
            )
          ],
        ),
      )),
    );
  }
}
