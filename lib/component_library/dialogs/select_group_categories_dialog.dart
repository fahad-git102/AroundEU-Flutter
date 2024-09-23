import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groupchat/component_library/buttons/button.dart';
import 'package:groupchat/component_library/text_widgets/extra_large_medium_bold_text.dart';
import 'package:groupchat/component_library/text_widgets/extra_medium_text.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:sizer/sizer.dart';

class SelectGroupCategoriesDialog extends StatefulWidget {
  final List<String>? categories;
  final List<bool>? isSelected;

  @override
  State<StatefulWidget> createState() => _SelectGroupCategoriesDialogState();

  const SelectGroupCategoriesDialog({this.categories, this.isSelected});
}

class _SelectGroupCategoriesDialogState
    extends State<SelectGroupCategoriesDialog> {

  List<String>? selectedCategories=[];

  void toggleSelection(int index) {
    setState(() {
      widget.isSelected?[index] = !widget.isSelected![index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        padding: EdgeInsets.all(13.sp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 10.sp,
            ),
            Row(
              children: [
                ExtraLargeMediumBoldText(
                  title: 'Select categories'.tr(),
                  fontSize: 17.sp,
                  textColor: AppColors.lightBlack,
                ),
                const Spacer(),
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 5.sp, top: 5.sp, bottom: 5.sp),
                    child: Icon(
                      Icons.close,
                      size: 17.sp,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.sp),
              child: Divider(
                height: 0.5.sp,
                color: AppColors.extraLightFadedTextColor,
              ),
            ),
            Flexible(
                child: ListView.builder(
                    itemCount: widget.categories?.length,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return CheckboxListTile(
                        title: ExtraMediumText(
                          title: widget.categories![index],
                          textColor: AppColors.lightBlack,
                        ),
                        activeColor: AppColors.mainColor,
                        value: widget.isSelected?[index],
                        onChanged: (bool? value) {
                          toggleSelection(index);
                        },
                      );
                    })),
            SizedBox(
              height: 10.sp,
            ),
            Button(text: 'Done'.tr(), tapAction: () {
              if(widget.isSelected!=null){
                for(int i = 0; i<widget.isSelected!.length; i++){
                  if(widget.isSelected?[i]==true){
                    selectedCategories?.add(widget.categories![i]);
                  }
                }
              }
              Navigator.pop(context, selectedCategories);
            })
          ],
        ),
      ),
    );
  }
}
