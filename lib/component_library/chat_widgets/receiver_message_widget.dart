import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:groupchat/component_library/app_bars/custom_app_bar.dart';
import 'package:groupchat/component_library/chat_widgets/audio_message_widget.dart';
import 'package:groupchat/component_library/chat_widgets/document_message_widget.dart';
import 'package:groupchat/component_library/chat_widgets/video_message_widget.dart';
import 'package:groupchat/component_library/text_widgets/small_light_text.dart';
import 'package:groupchat/data/message_model.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_colors.dart';
import '../../core/utilities_class.dart';
import '../text_widgets/extra_medium_text.dart';

class ReceiverMessageWidget extends StatefulWidget {
  MessageModel? messageModel;
  String? senderName;

  @override
  State<StatefulWidget> createState() => _ReceiverMessageState();

  ReceiverMessageWidget({super.key, this.messageModel, this.senderName});
}

class _ReceiverMessageState extends State<ReceiverMessageWidget> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SmallLightText(
            title: widget.senderName ?? 'Sender name',
            textColor: AppColors.lightBlack,
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10.sp),
            padding: EdgeInsets.all(5.sp),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(7.sp)),
                color: AppColors.mainColor.withOpacity(0.3)),
            child: IntrinsicWidth(
              child: Align(
                alignment: Alignment.centerLeft,
                child: manageMessageView(widget.messageModel!),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget? manageMessageView(MessageModel message) {
    final isImage = message.image != null;
    final isAudio = message.audio != null;
    final isVideo = message.video != null;
    final isDocument = message.document != null;
    final isMessage = message.message != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isImage == true
            ? ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(7.sp)),
                child: CachedNetworkImage(
                  height: 140.sp,
                  width: 140.sp,
                  imageUrl: message.image ?? '',
                  placeholder: (context, url) => SpinKitPulse(
                    color: AppColors.mainColorDark,
                  ),
                  // Placeholder while loading
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  // Error widget
                  fit: BoxFit.cover, // Adjust this as needed
                ),
              )
            : isAudio == true
                ? AudioMessageWidget(audioUrl: message.audio ?? '')
                : isVideo
                    ? VideoMessageWidget(videoUrl: message.video ?? '')
                    : isDocument
                        ? DocumentMessageWidget(
                            messageId: message.key,
                            documentUrl: message.document ?? '',
                            documentName:
                                message.documentName ?? 'Document'.tr(),
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
