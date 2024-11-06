import 'package:easy_localization/easy_localization.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:groupchat/component_library/chat_widgets/reply_message_widget.dart';
import 'package:groupchat/component_library/text_widgets/extra_medium_text.dart';
import 'package:groupchat/component_library/text_widgets/small_light_text.dart';
import 'package:groupchat/data/message_model.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_colors.dart';
import '../../core/size_config.dart';

class BottomWriteWidget extends StatefulWidget {
  Function()? emojiPressed;
  bool? isRecording;
  bool? showEmojis;
  MessageModel? replyMessage;
  bool? showSendButton;
  FocusNode? focusNode;
  List<Map<String, dynamic>>? mentionsData;
  Function()? onAttachmentTap;
  Function()? onReplyCancel;
  Function(PointerUpEvent)? pointerUpEvent;
  Function(PointerDownEvent)? pointerDownEvent;
  Function()? onCameraTap;
  Function()? onSendTap;
  Function(String val)? onTextFieldChanged;
  GlobalKey<FlutterMentionsState>? mentionsKey;

  @override
  State<StatefulWidget> createState() => _BottomWriteWidgetState();

  BottomWriteWidget({
    this.emojiPressed,
    this.isRecording,
    this.showEmojis,
    this.focusNode,
    this.pointerUpEvent,
    this.pointerDownEvent,
    this.replyMessage,
    this.onReplyCancel,
    this.showSendButton,
    this.mentionsData,
    this.onAttachmentTap,
    this.onCameraTap,
    this.onTextFieldChanged,
    this.onSendTap,
    this.mentionsKey,
  });
}

class _BottomWriteWidgetState extends State<BottomWriteWidget> {
  updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 8.sp, right: 6.sp, bottom: 10.sp, top: 10.sp),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x73000000),
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                          color: AppColors.backGroundMidWhite),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10.sp), topRight:  Radius.circular(10.sp)),
                                color: AppColors.extraLightFadedTextColor),
                            child: widget.replyMessage!=null?ReplyMessageWidget(
                              uid: widget.replyMessage?.uid,
                              message: widget.replyMessage?.message??'Document'.tr(),
                              onReplyCancel: widget.onReplyCancel,
                            ):Container(),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 4.0.sp,
                              ),
                              IconButton(
                                icon: const Icon(Icons.emoji_emotions_outlined),
                                onPressed: widget.emojiPressed,
                              ),
                              Expanded(
                                child: FlutterMentions(
                                  key: widget.mentionsKey,
                                  suggestionPosition: SuggestionPosition.Top,
                                  maxLines: 5,
                                  focusNode: widget.focusNode,
                                  minLines: 1,
                                  textInputAction: TextInputAction.done,
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: widget.isRecording == true
                                          ? AppColors.green
                                          : AppColors.black,
                                      fontSize: 12.0.sp,
                                      fontWeight: FontWeight.w200),
                                  decoration: InputDecoration(
                                    fillColor: Colors.transparent,
                                    isDense: true,
                                    border: _border(),
                                    enabledBorder: _border(),
                                    focusedBorder: _border(),
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                            color: AppColors.fadedTextColor,
                                            fontSize: 12.0.sp),
                                    hintText: "Message".tr(),
                                  ),
                                  onSubmitted: (String value) async {},
                                  onChanged: widget.onTextFieldChanged,
                                  mentions: [
                                    Mention(
                                      trigger: "@",
                                      style:
                                          TextStyle(color: Theme.of(context).primaryColor),
                                      data: widget.mentionsData ?? [],
                                      suggestionBuilder: (p0) {
                                        return Container(
                                          margin: EdgeInsets.only(left: 30.0.sp),
                                          color: AppColors.backGroundDarkWhite,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15.0.sp, vertical: 10.0.sp),
                                            child: ExtraMediumText(
                                              title: p0['display'],
                                              textColor: AppColors.lightBlack,
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.attach_file),
                                    onPressed: widget.onAttachmentTap,
                                  ),

                                  IconButton(
                                    icon: const Icon(Icons.camera_alt_outlined),
                                    onPressed: widget.onCameraTap,
                                  ),
                                  SizedBox(width: 4.sp,)
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ///horizontal spacer
            ///
            widget.showSendButton == true
                ? InkWell(
              onTap: widget.onSendTap,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor,
                ),
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Icon(
                    Icons.send,
                    size: 20.sp,
                    color: AppColors.white,
                  ),
                ),
              ),
            )
                : Listener(
              onPointerUp: widget.pointerUpEvent,
              onPointerDown: widget.pointerDownEvent,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.isRecording == true
                      ? Colors.red
                      : Theme.of(context).primaryColor,
                ),
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Icon(
                    Icons.mic,
                    size: 20.sp,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
          ],
        ),
        Offstage(
          offstage: widget.showEmojis == false,
          child: SizedBox(
              height: 250,
              child: EmojiPicker(
                  textEditingController:
                  widget.mentionsKey?.currentState?.controller,
                  onBackspacePressed: () {
                    widget.mentionsKey?.currentState?.controller
                      ?..text = widget.mentionsKey!.currentState!.controller!
                          .text.characters
                          .toString()
                      ..selection = TextSelection.fromPosition(TextPosition(
                          offset: widget.mentionsKey!.currentState!
                              .controller!.text.length));
                  },
                  onEmojiSelected: (category, emoji) {
                    // widget.showSendButton = true;
                    // updateState();
                  },
                  config: Config(
                    columns: 7,
                    emojiSizeMax: SizeConfig.screenWidth! / 20,
                    verticalSpacing: 0,
                    horizontalSpacing: 0,
                    gridPadding: EdgeInsets.zero,
                    initCategory: Category.RECENT,
                    bgColor: AppColors.white,
                    indicatorColor: Colors.blue,
                    iconColor: Colors.grey,
                    iconColorSelected: Colors.blue,
                    backspaceColor: Colors.blue,
                    skinToneDialogBgColor: Colors.white,
                    skinToneIndicatorColor: Colors.grey,
                    enableSkinTones: true,
                    recentTabBehavior: RecentTabBehavior.RECENT,
                    recentsLimit: 28,
                    replaceEmojiOnLimitExceed: false,
                    noRecents: SmallLightText(
                      title: 'No Recents'.tr(),
                      textAlign: TextAlign.center,
                    ),
                    loadingIndicator: SpinKitPulse(
                      color: AppColors.mainColorDark,
                    ),
                    tabIndicatorAnimDuration: kTabScrollDuration,
                    categoryIcons: const CategoryIcons(),
                    buttonMode: ButtonMode.MATERIAL,
                    checkPlatformCompatibility: true,
                  ))),
        ),
      ],
    );
  }

  OutlineInputBorder _border() {
    return OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent, width: 0),
      borderRadius: BorderRadius.circular(100),
    );
  }
}
