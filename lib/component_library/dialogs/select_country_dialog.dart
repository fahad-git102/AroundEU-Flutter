import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupchat/component_library/text_widgets/extra_large_medium_bold_text.dart';
import 'package:groupchat/component_library/text_widgets/extra_medium_text.dart';
import 'package:groupchat/component_library/text_widgets/small_light_text.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:sizer/sizer.dart';

import '../../data/country_model.dart';
import '../../providers/app_user_provider.dart';

class SelectCountryDialog extends StatefulWidget {

  final Function()? onCloseTap;
  final Function(CountryModel? countryModel)? onItemSelect;
  final String? title;
  final String? subTitle;
  final bool? showCancel;

  @override
  State<StatefulWidget> createState() => _SelectCountryDialogState();

  const SelectCountryDialog({
    this.onCloseTap,
    this.onItemSelect,
    this.title, this.subTitle, this.showCancel=true,
  });
}

class _SelectCountryDialogState extends State<SelectCountryDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Consumer(
        builder: (ctx, ref, child) {
          var appUserPro = ref.watch(appUserProvider);
          appUserPro.listenToCountries();
          return Container(
            padding: EdgeInsets.only(top: widget.showCancel== false ? 13.0.sp:5.0.sp, bottom: 13.0.sp, left: 13.0.sp, right: 13.0.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.showCancel==true?Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: widget.onCloseTap,
                    child: Padding(
                      padding: EdgeInsets.all(4.0.sp),
                      child: Icon(Icons.close, color: AppColors.fadedTextColor, size: 20.0.sp,),
                    ),
                  ),
                ): Container(),
                ExtraLargeMediumBoldText(
                  title: widget.title??'Select Country'.tr(),
                  textColor: AppColors.lightBlack,
                ),
                widget.subTitle!=null?SizedBox(height: 3.sp,):Container(),
                widget.subTitle!=null?SmallLightText(
                  title: widget.subTitle,
                  textColor: AppColors.fadedTextColor2,
                ):Container(),
                SizedBox(
                  height: 6.0.sp,
                ),
                Divider(
                  height: 0.5.sp,
                  color: AppColors.fadedTextColor2,
                ),
                SizedBox(
                  height: 10.0.sp,
                ),
                ListView.separated(
                  itemCount: appUserPro.countriesList?.length ?? 0,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: (){
                        widget.onItemSelect!(appUserPro.countriesList?[index]);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.0.sp),
                        child: Center(
                          child: ExtraMediumText(
                            title: appUserPro.countriesList?[index].countryName,
                            textColor: AppColors.lightBlack,
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      height: 0.3.sp,
                      color: AppColors.extraLightFadedTextColor,
                    );
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
