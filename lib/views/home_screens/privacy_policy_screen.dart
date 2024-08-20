
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:groupchat/core/size_config.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../component_library/app_bars/custom_app_bar.dart';
import '../../core/assets_names.dart';

class PrivacyPolicyScreen extends StatefulWidget{
  static const route = 'PrivacyPolicyScreen';
  @override
  State<StatefulWidget> createState() => _PrivacyPolicyScreenState();

}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen>{
  String pdfPath = "";


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Images.mainBackground),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                title: 'Privacy Policy'.tr(),
              ),
              Expanded(
                child: SfPdfViewer.asset(
                  'assets/pdfs/privacy_notice.pdf',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}