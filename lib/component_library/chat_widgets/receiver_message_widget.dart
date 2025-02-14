import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:groupchat/component_library/chat_widgets/audio_message_widget.dart';
import 'package:groupchat/component_library/chat_widgets/document_message_widget.dart';
import 'package:groupchat/component_library/chat_widgets/location_message_widget.dart';
import 'package:groupchat/component_library/chat_widgets/reply_message_widget.dart';
import 'package:groupchat/component_library/chat_widgets/video_message_widget.dart';
import 'package:groupchat/component_library/text_widgets/small_light_text.dart';
import 'package:groupchat/data/message_model.dart';
import 'package:groupchat/views/chat_screens/full_video_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_colors.dart';
import '../../core/download_manager.dart';
import '../../core/utilities_class.dart';
import '../../views/profile_screens/full_image_screen.dart';
import '../../views/profile_screens/user_profile_screen.dart';

class ReceiverMessageWidget extends StatefulWidget {
  MessageModel? messageModel;
  String? senderName;
  ValueChanged<MessageModel>? onSwipeMessage;
  MessageModel? replyMessage;
  Function()? replyWidgetTap;

  @override
  State<StatefulWidget> createState() => _ReceiverMessageState();

  ReceiverMessageWidget({super.key, this.replyWidgetTap, this.messageModel, this.replyMessage, this.senderName, this.onSwipeMessage});
}

class _ReceiverMessageState extends State<ReceiverMessageWidget> {
  @override
  Widget build(BuildContext context) {
    return SwipeTo(
      onRightSwipe: (details) => widget.onSwipeMessage!(widget.messageModel!),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (ctx) => UserProfileScreen(
                            userId: widget.messageModel?.uid ?? '')));
              },
              child: SmallLightText(
                title: widget.senderName ?? 'Sender name',
                textColor: AppColors.lightBlack,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10.sp),
              padding: EdgeInsets.all(5.sp),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7.sp)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.lightFadedTextColor.withOpacity(0.5),
                      offset: const Offset(0, 0.5),
                      blurRadius: 1.0,
                    ),
                  ],
                  color: AppColors.white.withOpacity(0.7)),
              child: IntrinsicWidth(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: manageMessageView(widget.messageModel!)??Container(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget? manageMessageView(MessageModel message) {
    final isImage = message.image != null;
    final isAudio = message.audio != null;
    final isVideo = message.video != null;
    final isDocument = message.document != null;
    final isMessage = message.message != null;
    final isLocation = message.latitude != null && message.longitude != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        message.replyId !=null ? InkWell(
          onTap: widget.replyWidgetTap,
          child: ReplyMessageWidget(
            uid: widget.replyMessage?.uid,
            small: true,
            message: widget.replyMessage?.message?? widget.replyMessage?.documentName ??'Document'.tr(),
          ),
        ):Container(),
        isImage == true
            ? InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullImageScreen(
                        imageUrl: message.image ?? '',
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(7.sp)),
                  child: CachedNetworkImage(
                    height: 140.sp,
                    width: 140.sp,
                    imageUrl: message.image ?? '',
                    placeholder: (context, url) => SpinKitPulse(
                      color: AppColors.mainColorDark,
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : isAudio == true
                ? AudioMessageWidget(audioUrl: message.audio ?? '')
                : isVideo
                    ? InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => VideoPlayerScreen(
                                      videoUrl: message.video ?? '')));
                        },
                        child:
                            VideoMessageWidget(videoUrl: message.video ?? ''))
                    : isDocument
                        ? InkWell(
          onTap: () {

            DownloadManager().downloadFile(message.document??'', message.documentName??'document.pdf');
          },
                          child: DocumentMessageWidget(
                              messageId: message.key,
                              documentUrl: message.document ?? '',
                              documentName:
                                  message.documentName ?? 'Document'.tr(),
                            ),
                        )
                        : isMessage
                            ? Padding(
                                padding: EdgeInsets.only(
                                    left: 7.sp, right: 7.sp, top: 7.sp),
                                child: Linkify(
                                  onOpen: (link) async {
                                    if (!await launchUrl(Uri.parse(link.url))) {
                                      throw Exception(
                                          'Could not launch ${link.url}');
                                    }
                                  },
                                  textAlign: TextAlign.start,
                                  text: Utilities().parseHtmlToPlainText(
                                      widget.messageModel?.message ?? ''),
                                  style: TextStyle(
                                      color: AppColors.lightBlack,
                                      fontSize: 12.3.sp),
                                  linkStyle: TextStyle(
                                      color: AppColors.hyperLinkColor),
                                ),
                              )
                            : isLocation
                                ? LocationMessageWidget(
                                    latitude: message.latitude,
                                    longitude: message.longitude,
                                  )
                                : Container(),
        SizedBox(
          height: 3.sp,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 7.0.sp),
          child: SmallLightText(
            title: Utilities().formatTimestamp(message.timeStamp ?? 0),
            textColor: AppColors.lightFadedTextColor,
            fontSize: 9.sp,
          ),
        )
      ],
    );
  }
}
