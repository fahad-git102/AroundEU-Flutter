import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:groupchat/core/assets_names.dart';

import 'custom_dialog.dart';

class SimpleErrorDialog extends StatelessWidget{

  final String? title;
  final String? btnText;
  final Function()? onBtnTap;

  const SimpleErrorDialog({super.key, required this.title, this.btnText, this.onBtnTap});

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title2: title,
      showBtn2: false,
      btn1Text: btnText??"OK".tr(),
      icon: Images.warningRedIcon,
      onBtn1Tap: onBtnTap?? (){
        Navigator.of(context).pop();
      },
    );
  }

}