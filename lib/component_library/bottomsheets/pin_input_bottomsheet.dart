import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:groupchat/component_library/text_widgets/extra_large_medium_bold_text.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:groupchat/core/assets_names.dart';
import 'package:groupchat/core/utilities_class.dart';
import 'package:sizer/sizer.dart';

class PinInputBottomSheet extends StatefulWidget {
  final String? title;

  const PinInputBottomSheet({super.key, this.title});

  @override
  State<PinInputBottomSheet> createState() => _PinInputBottomSheetState();
}

class _PinInputBottomSheetState extends State<PinInputBottomSheet> {
  List<String> pin = ["", "", "", "", ""];

  void _addPinDigit(String digit) {
    for (int i = 0; i < pin.length; i++) {
      if (pin[i] == "") {
        setState(() {
          pin[i] = digit;
        });
        break;
      }
    }
  }

  void _deletePinDigit() {
    for (int i = pin.length - 1; i >= 0; i--) {
      if (pin[i] != "") {
        setState(() {
          pin[i] = "";
        });
        break;
      }
    }
  }

  void _submitPin() {
    if (pin.contains("")) {
      Utilities().showCustomToast(
          message: 'Please enter a complete 5-digit PIN'.tr(), isError: true);
    } else {
      Navigator.of(context).pop(pin.join());
    }
  }

  Widget _buildPinDigit(int index) {
    return Expanded(
      child: Container(
        height: 50.sp,
        margin: EdgeInsets.symmetric(horizontal: 4.sp),
        decoration: BoxDecoration(
          color: AppColors.backGroundLightWhite,
          border: Border.all(
              width: 0.4.sp, color: AppColors.extraLightFadedTextColor),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Center(
            child: ExtraLargeMediumBoldText(
          title: pin[index].isNotEmpty ? '•' : "",
          textColor: AppColors.lightBlack,
        )),
      ),
    );
  }

  Widget _buildNumberButton(String number) {
    return GestureDetector(
      onTap: () {
        if (pin.contains("")) {
          _addPinDigit(number);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.mainColor.withOpacity(0.7),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: ExtraLargeMediumBoldText(
            title: number,
            textColor: AppColors.lightBlack,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.sp),
          topRight: Radius.circular(24.sp),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sp),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.all(3.0.sp),
                  child: SvgPicture.asset(
                    Images.closeNormal,
                    height: 16.sp,
                    width: 16.sp,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.sp),
            child: ExtraLargeMediumBoldText(
              title: widget.title??"Enter 5-Digit PIN".tr(),
              textColor: AppColors.lightBlack,
            ),
          ),
          SizedBox(height: 20.sp),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPinDigit(0),
                _buildPinDigit(1),
                _buildPinDigit(2),
                _buildPinDigit(3),
                _buildPinDigit(4),
              ],
            ),
          ),
          SizedBox(height: 30.sp),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.sp),
            child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1.4,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildNumberButton("1"),
                _buildNumberButton("2"),
                _buildNumberButton("3"),
                _buildNumberButton("4"),
                _buildNumberButton("5"),
                _buildNumberButton("6"),
                _buildNumberButton("7"),
                _buildNumberButton("8"),
                _buildNumberButton("9"),
                GestureDetector(
                  onTap: _deletePinDigit,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child:
                          Icon(Icons.backspace, color: Colors.white, size: 25.sp),
                    ),
                  ),
                ),
                _buildNumberButton("0"),
                GestureDetector(
                  onTap: _submitPin,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.mainColor.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(Icons.check,
                          color: AppColors.lightBlack, size: 28.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.sp),
        ],
      ),
    );
  }
}
