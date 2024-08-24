import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupchat/component_library/app_bars/custom_app_bar.dart';
import 'package:groupchat/component_library/drawers/admin_home_drawer.dart';
import 'package:groupchat/providers/app_user_provider.dart';
import 'package:sizer/sizer.dart';

import '../../component_library/buttons/custom_icon_button.dart';
import '../../component_library/text_widgets/medium_bold_text.dart';
import '../../core/assets_names.dart';
import '../../core/size_config.dart';

class AdminHomeScreen extends StatefulWidget{
  static const route = 'AdminHomeScreen';
  @override
  State<StatefulWidget> createState() => _AdminHomeScreenState();

}

class _AdminHomeScreenState extends State<AdminHomeScreen>{
  final GlobalKey<ScaffoldState> _homeKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: _homeKey,
      drawer: AdminHomeDrawer(),
      body: SafeArea(
          child: Consumer(builder: (ctx, ref, child){
            var appUserPro = ref.watch(appUserProvider);
            appUserPro.listenToCountries();
            return Container(
              height: SizeConfig.screenHeight,
              padding: EdgeInsets.only(top: 15.0.sp, left: 13.0.sp, right: 13.0.sp),
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
                  Align(
                    alignment: Alignment.topLeft,
                    child: CustomIconPngButton(
                      icon: Images.menuIcon,
                      size: 36.0.sp,
                      onTap: (){
                        _homeKey.currentState!.openDrawer();
                      },
                    ),
                  ),
                  SizedBox(height: 10.0.sp,),
                ],
              ),
            );
          })),
    );
  }

}