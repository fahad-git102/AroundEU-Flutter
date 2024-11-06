import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:groupchat/component_library/app_bars/custom_app_bar.dart';
import 'package:groupchat/component_library/text_widgets/small_light_text.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:groupchat/core/size_config.dart';
import 'package:groupchat/core/utilities_class.dart';
import 'package:sizer/sizer.dart';

import '../../core/assets_names.dart';
import '../../data/users_model.dart';
import '../../firebase/auth.dart';
import '../../providers/app_user_provider.dart';

class ReplyMessageWidget extends ConsumerStatefulWidget{
  String? message;
  String? uid;
  Function()? onReplyCancel;
  bool? small;

  ReplyMessageWidget({super.key,
    this.message,
    this.onReplyCancel,
    this.small=false,
    this.uid
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReplyMessageState();
}

class _ReplyMessageState extends ConsumerState<ReplyMessageWidget>{
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widget.small == true?BoxDecoration(
        color: AppColors.extraLightFadedTextColor,
        borderRadius: BorderRadius.all(Radius.circular(5.sp))
      ):null,
      padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
      child: Row(
        children: [
          Container(
            width: 4.sp,
            height: widget.small==true?35.sp:40.sp,
            color: AppColors.green,
          ),
          SizedBox(width: 5.sp,),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.uid == Auth().currentUser?.uid ? SmallLightText(
                      title: 'You'.tr(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w400,
                      textColor: AppColors.lightBlack,
                    ) : FutureBuilder<AppUser?>(
                        future: fetchUser(widget.uid ?? ''),
                        builder: (context, snapshot){
                          var senderName = '';
                          if(snapshot.hasData){
                            senderName = snapshot.data!.firstName??'';
                          }
                          return SmallLightText(
                            title: senderName,
                            maxLines: 1,
                            fontSize: widget.small==true? 9:11,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w400,
                            textColor: AppColors.lightBlack,
                          );
                        }
                    ),
                    widget.small==false?Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: widget.onReplyCancel,
                        child: Padding(
                            padding: EdgeInsets.all(4.sp),
                            child: SvgPicture.asset(Images.closeNormal, height: 10.sp, width: 10.sp, color: AppColors.lightBlack,)),
                      ),
                    ):Container()
                  ],
                ),
                SmallLightText(
                  title: Utilities().parseHtmlToPlainText(widget.message??''),
                  textColor: AppColors.fadedTextColor2,
                  overflow: TextOverflow.ellipsis,
                  fontSize: widget.small==true? 9:11,
                  maxLines: 1,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<AppUser?> fetchUser(String id) async {
    AppUser? user = await ref.watch(appUserProvider).getUserById(id);
    return user;
  }

}