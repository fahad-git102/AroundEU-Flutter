import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupchat/component_library/business_list_widgets/business_list_item.dart';
import 'package:groupchat/component_library/dialogs/add_new_group_dialog.dart';
import 'package:groupchat/providers/app_user_provider.dart';
import 'package:groupchat/providers/business_list_provider.dart';
import 'package:sizer/sizer.dart';

import '../../component_library/app_bars/custom_app_bar.dart';
import '../../core/assets_names.dart';
import '../../core/size_config.dart';

class AddNewGroupScreen extends StatefulWidget{
  static const route = 'AddNewGroupScreen';
  @override
  State<StatefulWidget> createState() => _AddNewGroupScreen();
}

class _AddNewGroupScreen extends State<AddNewGroupScreen>{
  
  bool? isLoading = false;
  bool? pageStarted = true;
  
  updateState(){
    setState(() {
      
    });
  }
  
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Consumer(builder: (ctx, ref, build){
            var businessListPro = ref.watch(businessListProvider);
            var appUserPro = ref.watch(appUserProvider);
            if(pageStarted == true){
              businessListPro.listenToBusinessList();
            }
            return Container(
              height: SizeConfig.screenHeight,
              width: SizeConfig.screenWidth,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Images.mainBackground),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  CustomAppBar(
                    title: 'Select Business List:'.tr(),
                  ),
                  SizedBox(
                    height: 10.sp,
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: businessListPro.businessLists?.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 13.sp),
                        itemBuilder: (BuildContext context, int index){
                          return InkWell(
                            onTap: (){
                              showNewGroupDialog();
                            },
                            child: BusinessListItem(
                              title: businessListPro.businessLists?[index].name,
                              showMenuButton: false,
                              country: appUserPro.getCountryById(businessListPro
                                  .businessLists?[index].countryId??'')?.countryName??'',
                            ),
                          );
                        }
                    ),
                  )
                ],
              ),
            );
          })
      ),
    );
  }

  showNewGroupDialog(){
    showDialog(context: context, builder: (context) => AddNewGroupDialog());
  }
  
}