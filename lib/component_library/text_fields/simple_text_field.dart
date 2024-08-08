import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_colors.dart';

class SimpleTextField extends StatelessWidget {
  final bool? obscureText;
  final bool? allowNumbersOnly;
  final Widget? suffixIcon;
  final Function()? onTap;
  final TextInputType? keyboardType;
  final int? maxLines, minLines;
  final bool? enabled;
  final String? hintText;
  final bool? noBorder;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final Function(String?)? onChanged;
  final TextEditingController? controller;

  const SimpleTextField(
      {super.key,
      this.obscureText,
      this.allowNumbersOnly,
      this.suffixIcon,
        this.hintText,
        this.noBorder = false,
      this.onTap,
      this.keyboardType,
      this.enabled,
      this.inputFormatters,
      this.focusNode,
      this.validator,
      this.controller,
      this.maxLines,
      this.minLines, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      minLines: minLines,
      focusNode: focusNode,
      validator: validator,
      controller: controller,
      onTap: onTap,
      enabled: enabled ?? true,
      obscureText: obscureText ?? false,
      keyboardType: keyboardType,
      onChanged: onChanged,
      inputFormatters: inputFormatters ??
          <TextInputFormatter>[
            allowNumbersOnly == true
                ? FilteringTextInputFormatter.digitsOnly
                : FilteringTextInputFormatter.singleLineFormatter
          ],
      decoration: InputDecoration(
        hintText: hintText??'',
        isDense: true,
        border: noBorder??false ? InputBorder.none : OutlineInputBorder(
          borderRadius: BorderRadius.circular(13.0.sp),
          borderSide:
              BorderSide(color: AppColors.fadedTextColor2, width: 1.0),
        ),
        enabledBorder: noBorder??false ? InputBorder.none : OutlineInputBorder(
          borderRadius: BorderRadius.circular(13.0.sp),
          borderSide:
              BorderSide(color: AppColors.fadedTextColor2, width: 1.0),
        ),
      ),
    );
  }
}
