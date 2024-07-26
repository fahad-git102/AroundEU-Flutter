import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/size_config.dart';
import '../text_widgets/extra_medium_text.dart';

class RadioButtonWithTextOption extends StatefulWidget {
  const RadioButtonWithTextOption(
      {Key? key,
        this.active = false,
        this.onTap,
        this.title = "",
        this.size,
        this.titleColor,
        this.thumbColor,
        this.isOnTapActive, this.titleWeight})
      : super(key: key);
  final bool active;
  final Function()? onTap;
  final String? title;
  final FontWeight? titleWeight;
  final double? size;
  final Color? titleColor;
  final Color? thumbColor;
  final bool? isOnTapActive;

  @override
  State<RadioButtonWithTextOption> createState() =>
      _RadioButtonWithTextOptionState();
}

class _RadioButtonWithTextOptionState extends State<RadioButtonWithTextOption> {
  @override
  Widget build(BuildContext context) {
    return (widget.isOnTapActive ?? true)
        ? GestureDetector(
      onTap: widget.onTap ?? () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.active == false
                ? Icons.radio_button_unchecked
                : Icons.radio_button_checked,
            size: widget.size ?? SizeConfig.screenHeight! / 50,
            color: widget.thumbColor ?? widget.titleColor,
          ),
          const SizedBox(
            width: 5,
          ),
          if (widget.title != null)
            widget.titleColor != null
                ? Expanded(
              child: ExtraMediumText(
                title: widget.title!,
                maxLines: 3,
                decrease: 3,
                textColor: widget.titleColor ?? AppColors.black,
                fontWeight: widget.titleWeight??FontWeight.w400,
              ),
            )
                : Expanded(
              child: ExtraMediumText(
                title: widget.title!,
                maxLines: 3,
                decrease: 3,
                textColor: widget.titleColor ?? AppColors.black,
              ),
            ),
        ],
      ),
    )
        : Row(
      children: [
        Icon(
          widget.active == false
              ? Icons.radio_button_unchecked
              : Icons.radio_button_checked,
          size: widget.size ?? SizeConfig.screenHeight! / 50,
        ),
        const SizedBox(
          width: 5,
        ),
        if (widget.title != null)
          Expanded(
            child: ExtraMediumText(
              title: widget.title!,
              maxLines: 3,
              decrease: 3,
              textColor: widget.titleColor ?? AppColors.black,
            ),
          ),
      ],

    );
  }
}