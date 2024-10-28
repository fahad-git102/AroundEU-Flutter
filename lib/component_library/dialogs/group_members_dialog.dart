import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:groupchat/component_library/image_widgets/circle_image_avatar.dart';
import 'package:groupchat/component_library/image_widgets/no_data_widget.dart';
import 'package:groupchat/component_library/text_widgets/medium_bold_text.dart';
import 'package:groupchat/component_library/text_widgets/small_light_text.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:groupchat/core/size_config.dart';
import 'package:groupchat/providers/app_user_provider.dart';
import 'package:sizer/sizer.dart';

import '../../data/users_model.dart';

class GroupMembersDialog extends ConsumerStatefulWidget {
  final List<String?>? userIds;

  GroupMembersDialog({
    super.key,
    this.userIds,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroupMembersDialog();
}

class _GroupMembersDialog extends ConsumerState<GroupMembersDialog> {
  List<AppUser?>? groupMembers;
  bool? isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchGroupMembers();
  }

  void updateState() {
    setState(() {});
  }

  Future<void> fetchGroupMembers() async {
    isLoading = true;
    updateState();
    List<AppUser?> users =
    await ref.read(appUserProvider).getUsersListByIds(widget.userIds);
    groupMembers = users;
    isLoading = false;
    updateState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 13.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Ensures the dialog height is dynamic
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MediumBoldText(
                        title: 'Group Members'.tr(),
                        textColor: AppColors.lightBlack,
                      ),
                      groupMembers!=null && groupMembers?.isNotEmpty == true?SmallLightText(
                        title: '${groupMembers?.length} members',
                        fontSize: 8.5.sp,
                        textColor: AppColors.lightFadedTextColor,
                      ):Container()
                    ],
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                      child: Padding(padding: EdgeInsets.all(3.sp), child: Icon(Icons.close, color: AppColors.lightBlack, size: 16.sp,),))
                ],
              ),
            ),
            SizedBox(height: 10.sp),
            isLoading == true
                ? Center(
              child: SpinKitPulse(
                color: AppColors.mainColorDark,
              ),
            )
                : groupMembers != null && groupMembers!.isNotEmpty
                ? ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 60.h, // Adjust the height as needed
              ),
              child: ListView.builder(
                itemCount: groupMembers?.length ?? 0,
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 7.sp),
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: (){
                      print(groupMembers?[index]?.uid);
                    },
                    child: Container(
                      width: SizeConfig.screenWidth,
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.sp, vertical: 7.sp),
                      margin: EdgeInsets.all(4.sp),
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(7.sp)),
                          color: AppColors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black87.withOpacity(0.34),
                              blurRadius: 2,
                              offset: const Offset(1, 0.5), // Shadow position
                            ),
                          ]),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleImageAvatar(
                            imagePath: groupMembers?[index]
                                ?.profileUrl ??
                                '',
                            size: 34.sp,
                          ),
                          SizedBox(width: 8.sp),
                          Expanded(
                              child: SmallLightText(
                                textColor: AppColors.lightBlack,
                                title:
                                '${groupMembers?[index]?.firstName ?? ''} ${groupMembers?[index]?.surName ?? ''}',
                              ))
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
                : NoDataWidget(),
          ],
        ),
      ),
    );
  }
}
