import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import '../../core/app_colors.dart';
import '../../core/size_config.dart';
import '../text_widgets/medium_bold_text.dart';

///Custom Button class
///
/// Custom button class have many customize options. We use it where we need button function with customize text, on tap functions, either fill or outlined button, and only text or icon with text button.
class Button extends StatefulWidget {
  const Button(
      {Key? key,
        required this.text,
        required this.tapAction,
        this.padding = false,
        this.forceTap = false,
        this.btnColor,
        this.active = true,
        this.outLined = false,
        this.icon,
        this.iconData,
        this.width,
        this.bottomPadding = 0,
        this.height,
        this.btnTxtColor,
        this.borderRadius,
        this.isIconFirst,
        this.iconColor,
        this.maxLines, this.textWidget})
      : super(key: key);
  final String text;
  final bool forceTap;
  final Color? btnColor;
  final Color? btnTxtColor;
  final bool active;
  final Function()? tapAction;
  final double? width;
  final Widget? textWidget;
  final IconData? iconData;
  final double? height;
  final double bottomPadding;
  final String? icon;
  final bool? isIconFirst;
  final bool padding;
  final Color? iconColor;
  final bool? outLined;
  final double? borderRadius;
  final int? maxLines;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Padding(
        padding: EdgeInsets.only(bottom: widget.bottomPadding),
        child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: widget.padding ? SizeConfig.screenWidth! / 20 : 0),
            child: AnimatedContainer(
              width: widget.width ?? SizeConfig.screenWidth,
              height: widget.height ?? 40.sp,
              decoration: BoxDecoration(
                color: widget.btnColor ?? AppColors.white,
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 30),
              ),
              duration: const Duration(milliseconds: 500),
              child: Container(
                  width: getProportionateScreenWidth(350.0),
                  height: SizeConfig.screenHeight! / 17,
                  decoration: BoxDecoration(
                    color: widget.active == false
                        ? AppColors.extraLightGrey
                        : widget.outLined == true
                        ? AppColors.white
                        : widget.btnColor ?? AppColors.mainColor,
                    borderRadius: BorderRadius.circular(
                        widget.borderRadius ?? SizeConfig.screenHeight! / 100),
                    border: Border.all(
                        color: widget.outLined == true
                            ? widget.btnColor ?? Theme.of(context).primaryColor
                            : Colors.transparent),
                  ),
                  child: InkWell(
                    onTap: widget.active
                        ? widget.tapAction
                        : widget.forceTap
                        ? widget.tapAction
                        : () {},
                    child: Center(
                      child: Row(
                        mainAxisAlignment: widget.icon == null
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.center,
                        children: [
                          if (widget.isIconFirst ?? false)
                            widget.icon != "" && widget.icon != null
                                ? Padding(
                              padding: EdgeInsets.only(
                                  left: SizeConfig.screenWidth! / 50),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: SvgPicture.asset(
                                  widget.icon!,
                                  color: widget.iconColor,
                                ),
                              ),
                            )
                                : Icon(widget.iconData),
                          if (widget.isIconFirst ?? false)
                            SizedBox(
                              width: 15.sp,
                            ),
                          Expanded(
                            child: widget.textWidget??MediumBoldText(
                              title: widget.text,
                              maxLines: widget.maxLines??2,
                              textAlign: TextAlign.center,
                              textColor: widget.active == false
                                  ? AppColors.fadedTextColor
                                  : widget.outLined == true
                                  ? widget.btnColor ??
                                  Theme.of(context).primaryColor
                                  : widget.btnTxtColor ?? AppColors.fadedTextColor2,
                            ),
                          ),
                          // if (!(widget.isIconFirst ?? false))
                          //   SizedBox(
                          //     width: 15.sp,
                          //   ),
                          if (!(widget.isIconFirst ?? false))
                            widget.icon != "" && widget.icon != null
                                ? Padding(
                              padding: EdgeInsets.only(
                                  left: SizeConfig.screenWidth! / 50),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: SvgPicture.asset(
                                  widget.icon!,
                                  height: 25.sp,
                                  color: widget.iconColor,
                                ),
                              ),
                            )
                                : Container(),
                        ],
                      ),
                    ),
                  )),
            ),
            ),
        );
    }
}