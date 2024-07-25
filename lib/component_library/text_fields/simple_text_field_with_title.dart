import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:groupchat/component_library/text_fields/simple_text_field.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_colors.dart';
import '../text_widgets/small_light_text.dart';

class SimpleTextFieldWithTitle extends StatelessWidget{

  final TextEditingController? controller;
  final String? title;
  final Function(String? val)? onChanged;
  final int? maxLines;
  final int? minLines;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final FocusNode? focusNode;
  final Function()? onTap;
  final String? Function(String? value)? validator;

  const SimpleTextFieldWithTitle({super.key, this.controller, this.title, this.maxLines, this.validator, this.enabled, this.onTap, this.inputFormatters, this.focusNode, this.minLines, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SmallLightText(
          title: title??'Title',
          textColor: AppColors.fadedTextColor2,
        ),
        SizedBox(
          height: 5.0.sp,
        ),
        SizedBox(
          child: SimpleTextField(
            maxLines: maxLines,
            minLines: minLines,
            focusNode: focusNode,
            onTap: onTap,
            inputFormatters: inputFormatters,
            onChanged: onChanged,
            controller: controller,
            enabled: enabled??true,
            validator: validator,
          ),
        ),
      ],
    );
  }

}