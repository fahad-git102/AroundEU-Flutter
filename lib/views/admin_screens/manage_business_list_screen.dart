import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupchat/component_library/business_list_widgets/business_list_item.dart';
import 'package:groupchat/component_library/dialogs/new_business_list_dialog.dart';
import 'package:groupchat/core/utilities_class.dart';
import 'package:groupchat/data/business_list_model.dart';
import 'package:groupchat/providers/app_user_provider.dart';
import 'package:groupchat/providers/business_list_provider.dart';
import 'package:groupchat/providers/groups_provider.dart';
import 'package:groupchat/repositories/business_list_repository.dart';
import 'package:groupchat/views/admin_screens/groups_screen.dart';
import 'package:sizer/sizer.dart';

import '../../component_library/app_bars/custom_app_bar.dart';
import '../../component_library/dialogs/custom_dialog.dart';
import '../../core/app_colors.dart';
import '../../core/assets_names.dart';
import '../../core/size_config.dart';

class ManageBusinessListScreen extends StatefulWidget {
  static const route = 'ManageBusinessListScreen';

  @override
  State<StatefulWidget> createState() => _ManageBLState();
}

class _ManageBLState extends State<ManageBusinessListScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(), onPressed: () {
          addBusinessListDialog();
      },
        child: Icon(Icons.add, color: AppColors.lightBlack,),
      ),
      body: SafeArea(child: Consumer(builder: (ctx, ref, child) {
        var businessPro = ref.watch(businessListProvider);
        var appUserPro = ref.watch(appUserProvider);
        businessPro.listenToBusinessList();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                title: 'Business Lists'.tr(),
              ),
              SizedBox(height: 10.sp,),
              Expanded(
                child: ListView.builder(
                  itemCount: businessPro.businessLists?.length??0,
                  shrinkWrap: true,
                    padding: EdgeInsets.only(left: 13.sp, right: 13.sp, bottom: 50.sp),
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: (){
                          ref.watch(groupsProvider).currentBLGroupsList = null;

                          Navigator.pushNamed(context, GroupsScreen.route, arguments: {
                            'businessList': businessPro.businessLists?[index].toMap()
                          });
                        },
                        child: BusinessListItem(
                          title: businessPro.businessLists?[index].name,
                          country: appUserPro.getCountryById(businessPro
                              .businessLists?[index].countryId??'')?.countryName??'',
                          showDot: businessPro.businessLists?[index].showDot,
                          onOptionSelected: (value){
                            if (value == 0) {
                              showEditBusinessListDialog(businessPro.businessLists![index]);
                            } else if (value == 1) {
                              showDeleteBusinessListDialog(businessPro.businessLists![index]);
                            }
                          },
                        ),
                      );
                    }),
              )
            ],
          ),
        );
      })),
    );
  }

  showDeleteBusinessListDialog(BusinessList businessList){
    showDialog(context: context, builder: (ctx)=> CustomDialog(
      title2: "Are you sure you want to delete this Business list ?".tr(),
      btn1Text:'Delete'.tr(),
      btn2Text: 'Cancel'.tr(),
      btn1Outlined: true,
      icon: Images.deleteIcon,
      iconColor: AppColors.red,
      btn1Color: AppColors.red,
      onBtn2Tap: (){
        Navigator.pop(context);
      },
      onBtn1Tap: (){
        BusinessListRepository().deleteBusinessList(ctx,
            businessList.key??'', (){
          Utilities().showCustomToast(isError: false, message: 'Deleted'.tr());
              Navigator.pop(context);
            }, (p0){
              Utilities().showCustomToast(isError: true, message: p0.toString());
              Navigator.pop(context);
            });
      },
    ));
  }

  addBusinessListDialog(){
    showDialog(context: context, builder: (ctx)=> AddBusinessListDialog());
  }

  showEditBusinessListDialog(BusinessList businessList){
    showDialog(context: context, builder: (ctx)=> AddBusinessListDialog(
      isEdit: true,
      businessList: businessList,
    ));
  }

}
