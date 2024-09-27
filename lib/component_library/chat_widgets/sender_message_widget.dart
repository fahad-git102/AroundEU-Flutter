import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:groupchat/component_library/chat_widgets/document_message_widget.dart';
import 'package:groupchat/component_library/chat_widgets/video_message_widget.dart';
import 'package:groupchat/component_library/text_widgets/small_light_text.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:groupchat/core/utilities_class.dart';
import 'package:groupchat/data/message_model.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'audio_message_widget.dart';

class SenderMessageWidget extends StatefulWidget {
  MessageModel? messageModel;

  @override
  State<StatefulWidget> createState() => _SenderMessageState();

  SenderMessageWidget({
    super.key,
    this.messageModel,
  });
}

class _SenderMessageState extends State<SenderMessageWidget> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(5.sp),
        margin: EdgeInsets.only(bottom: 10.sp),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(7.sp)),
            boxShadow: [
              BoxShadow(
                color: AppColors.lightFadedTextColor.withOpacity(0.5),
                offset: const Offset(0, 0.5),
                blurRadius: 1.0,
              ),
            ],
            color: AppColors.white.withOpacity(0.8)),
        child: IntrinsicWidth(
          child: Align(
            alignment: Alignment.centerRight,
            child: manageMessageView(widget.messageModel!),
          ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
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
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
              )
            : isAudio == true
                ? AudioMessageWidget(audioUrl: message.audio ?? '')
                : isVideo
                    ? VideoMessageWidget(videoUrl: message.video ?? '')
                    : isDocument
                        ? DocumentMessageWidget(
                            messageId: message.key,
                            documentName:
                                message.documentName ?? 'Document'.tr(),
                            documentUrl: message.document ?? '',
                          )
                        : isMessage
                            ? Padding(
                                padding: EdgeInsets.all(7.sp),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 7.sp, right: 7.sp, top: 7.sp),
                                  child: Linkify(
                                    onOpen: (link) async {
                                      if (!await launchUrl(
                                          Uri.parse(link.url))) {
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
                                ))
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
