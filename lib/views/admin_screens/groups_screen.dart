import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:groupchat/component_library/chat_widgets/group_item_widget.dart';
import 'package:groupchat/component_library/image_widgets/no_data_widget.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:groupchat/data/business_list_model.dart';
import 'package:groupchat/data/group_model.dart';
import 'package:groupchat/data/message_model.dart';
import 'package:groupchat/providers/groups_provider.dart';
import 'package:groupchat/views/chat_screens/chat_screen.dart';
import 'package:sizer/sizer.dart';

import '../../component_library/app_bars/custom_app_bar.dart';
import '../../core/assets_names.dart';
import '../../core/size_config.dart';

class GroupsScreen extends ConsumerStatefulWidget {
  static const route = 'GroupsScreen';

  @override
  ConsumerState<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends ConsumerState<GroupsScreen> {
  BusinessList? currentBusinessList;
  bool pageStarted = true;

  updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final args = ModalRoute.of(context)!.settings.arguments != null
        ? ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>
        : null;
    var groupsPro = ref.watch(groupsProvider);
    if (args != null && pageStarted == true) {
      currentBusinessList ??= args['businessList'] != null
          ? BusinessList.fromMap(args['businessList'])
          : null;
      groupsPro.listenToCurrentBLGroups(currentBusinessList?.key ?? '');
      pageStarted = false;
    }

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
          children: [
            CustomAppBar(
              title: currentBusinessList != null
                  ? currentBusinessList?.name
                  : 'Groups'.tr(),
            ),
            SizedBox(
              height: 10.sp,
            ),
            Expanded(
                child: groupsPro.currentBLGroupsList == null
                    ? Center(
                        child: SpinKitPulse(
                          color: AppColors.mainColorDark,
                        ),
                      )
                    : groupsPro.currentBLGroupsList?.isEmpty == true
                        ? Center(
                            child: Padding(
                                padding: EdgeInsets.only(top: 50.sp),
                                child: NoDataWidget(
                                  text: 'No groups found'.tr(),
                                )))
                        : ListView.builder(
                            itemCount: groupsPro.currentBLGroupsList?.length,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 13.sp),
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: (){
                                  Navigator.pushNamed(context, ChatScreen.route);
                                },
                                child: GroupItem(
                                  title:
                                      groupsPro.currentBLGroupsList?[index].name,
                                  subTile: fetchLastMessage(
                                      groupsPro.currentBLGroupsList?[index]),
                                  imageUrl: groupsPro
                                      .currentBLGroupsList?[index].groupImage,
                                  messagesCount: groupsPro
                                          .currentBLGroupsList?[index]
                                          .unReadCounts
                                          ?.length ??
                                      0,
                                ),
                              );
                            }))
          ],
        ),
      )),
    );
  }

  String fetchLastMessage(GroupModel? group) {
    if (group?.messages != null) {
      MessageModel? lastMessage = MessageModel.fromMap(
          group?.messages?.values.last as Map<dynamic, dynamic>);
      if (lastMessage?.audio != null) {
        return 'Audio'.tr();
      } else if (lastMessage?.video != null) {
        return 'Video'.tr();
      } else if (lastMessage?.image != null) {
        return 'Image'.tr();
      } else {
        return lastMessage?.message ?? 'Last Message'.tr();
      }
    } else {
      return '';
    }
  }
}
