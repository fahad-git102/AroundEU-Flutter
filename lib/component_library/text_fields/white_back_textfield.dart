import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groupchat/component_library/text_fields/simple_text_field.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_colors.dart';

class WhiteBackTextField extends StatelessWidget{

  final String? hintText;
  final TextEditingController? controller;
  final int? maxLines;
  final Function(String?)? onChanged;
  final bool? allowNumersOnly;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  WhiteBackTextField({super.key, this.hintText, this.controller, this.maxLines, this.allowNumersOnly, this.inputFormatters, this.validator, this.onChanged});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7.0.sp, horizontal: 10.0.sp),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.lightFadedTextColor, width: 0.4.sp),
          borderRadius: BorderRadius.all(
              Radius.circular(4.sp))),
      child: SimpleTextField(
        controller: controller,
        minLines: maxLines,
        noBorder: true,
        onChanged: onChanged,
        validator: validator,
        inputFormatters: inputFormatters,
        allowNumbersOnly: allowNumersOnly,
        hintText: hintText,
      ),
    );
  }

}