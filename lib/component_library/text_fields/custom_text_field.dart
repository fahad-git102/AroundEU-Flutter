import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_colors.dart';

class CustomTextField extends StatelessWidget{

  final String? labelText;
  final String? hintText;
  final bool? obscureText;
  final bool? allowNumbersOnly;
  final Widget? suffixIcon;
  final double? borderRadius;
  final Color? fillColor;
  final int? maxLength;
  final Function()? onTap;
  final Color? textColor;
  final Function(String?)? onChanged;
  final TextInputType? keyboardType;
  final bool? enabled;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final TextEditingController? _controller;
  final bool? roundBorder ;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      controller: _controller,
      onTap: onTap,
      style: TextStyle(color: textColor??AppColors.lightBlack),
      enabled: enabled??true,
      maxLength: maxLength,
      obscureText: obscureText??false,
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator,
      inputFormatters: inputFormatters??<TextInputFormatter>[
        allowNumbersOnly == true
            ? FilteringTextInputFormatter.digitsOnly
            : FilteringTextInputFormatter.singleLineFormatter
      ],
      decoration: InputDecoration(
        hintText: hintText??"",
        labelText: labelText??"Full Name",
        suffixIcon: suffixIcon,
        fillColor: fillColor,
        labelStyle: TextStyle(color: AppColors.fadedTextColor2),
        border: roundBorder??false ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius??13.0.sp),
          borderSide:
          BorderSide(color: AppColors.fadedTextColor2, width: 1.0),
        ) : UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.fadedTextColor2),
        ),
        enabledBorder: roundBorder??false ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius??13.0.sp),
          borderSide:
          BorderSide(color: AppColors.fadedTextColor2, width: 1.0),
        ) : UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.fadedTextColor2),
    ),

      ),
    );
  }

  const CustomTextField({
    this.labelText,
    required TextEditingController? controller, this.roundBorder = false, this.obscureText, this.hintText, this.suffixIcon, this.onTap, this.enabled, this.focusNode, this.keyboardType, this.validator, this.allowNumbersOnly, this.inputFormatters, this.borderRadius, this.onChanged, this.textColor, this.maxLength, this.fillColor,
  }) : _controller = controller;
}