import 'dart:async';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:groupchat/component_library/bottomsheets/delete_message_bottomsheet.dart';
import 'package:groupchat/component_library/dialogs/group_members_dialog.dart';
import 'package:groupchat/component_library/image_widgets/circle_image_avatar.dart';
import 'package:groupchat/data/business_list_model.dart';
import 'package:groupchat/data/group_model.dart';
import 'package:groupchat/firebase/notification_service.dart';
import 'package:groupchat/providers/business_list_provider.dart';
import 'package:groupchat/repositories/business_list_repository.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:groupchat/component_library/bottomsheets/chat_media_bottomsheet.dart';
import 'package:groupchat/component_library/bottomsheets/pick_media_bottomsheet.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:groupchat/component_library/chat_widgets/bottom_write_widget.dart';
import 'package:groupchat/component_library/chat_widgets/receiver_message_widget.dart';
import 'package:groupchat/component_library/chat_widgets/sender_message_widget.dart';
import 'package:groupchat/component_library/dialogs/group_info_dialog.dart';
import 'package:groupchat/component_library/loaders/full_screen_loader.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:groupchat/core/static_keys.dart';
import 'package:groupchat/core/utilities_class.dart';
import 'package:groupchat/firebase/auth.dart';
import 'package:groupchat/providers/app_user_provider.dart';
import 'package:groupchat/repositories/groups_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sizer/sizer.dart';

import '../../component_library/buttons/back_button.dart';
import '../../component_library/text_widgets/extra_medium_text.dart';
import '../../core/assets_names.dart';
import '../../core/size_config.dart';
import '../../data/message_model.dart';
import '../../data/users_model.dart';
import '../../firebase/firebase_crud.dart';
import '../../providers/groups_provider.dart';

class ChatScreen extends StatefulWidget {
  static const route = 'ChatScreen';

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Map<String, dynamic>>? mentionsData;
  String? groupId;
  bool? pageStarted = true;
  List<FileWithType>? pickedFiles;
  bool? isLoading = false;
  GlobalKey<FlutterMentionsState> key = GlobalKey<FlutterMentionsState>();
  bool? isRecording = false;
  FlutterSoundRecorder audioRecorder = FlutterSoundRecorder();
  String? filePath;
  double dragExtent = 0.0;
  double threshold = 0.5;
  List<AppUser?>? groupMembers;
  BusinessList? currentBusinessList;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  MessageModel? replyMessage;
  FocusNode? focusNode = FocusNode();

  Future<void> _initRecorder() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
    await audioRecorder.openRecorder();
  }

  @override
  void dispose() {
    audioRecorder.closeRecorder();
    key.currentState?.controller?.dispose();
    focusNode?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _initRecorder();
    super.initState();
  }

  initChat(WidgetRef ref, Map<String, dynamic> args) {
    var groupsPro = ref.watch(groupsProvider);
    if (args != null && pageStarted == true) {
      pageStarted = false;
      groupId = args['groupId'] ?? '';
      GroupsRepository().readAllMessages(groupId ?? '');
      ref.watch(appUserProvider).listenToAdmins();
      ref.watch(appUserProvider).listenToCoordinators();
    }
    if (groupsPro.currentBLGroupsList == null ||
        groupsPro.currentBLGroupsList?.isEmpty == true) {
      groupsPro.listenToGroupById(groupId ?? '');
    } else {
      if (groupsPro.currentBLGroupsList
              ?.firstWhere((element) => element.key == groupId) ==
          null) {
        Utilities().showErrorMessage(context,
            barrierDismissible: false,
            message: "Something went wrong".tr(), onBtnTap: () {
          Navigator.pop(context);
          Navigator.pop(context);
        });
      }
    }
    if (mentionsData == null) {
      fetchMentionsData(ref);
    }
    if (currentBusinessList == null) {
      if (groupsPro.currentBLGroupsList
              ?.firstWhere((element) => element.key == groupId) !=
          null) {
        GroupModel? groupModel = groupsPro.currentBLGroupsList
            ?.firstWhere((element) => element.key == groupId);
        var businessPro = ref.watch(businessListProvider);
        businessPro.listenToBusinessList();
        for (BusinessList item in businessPro.businessLists ?? []) {
          if (item.key == groupModel?.businessKey) {
            currentBusinessList = item;
          }
        }
        BusinessListRepository().resetFlagForMe(context, currentBusinessList);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final args = ModalRoute.of(context)!.settings.arguments != null
        ? ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>
        : null;
    return Consumer(builder: (ctx, ref, child) {
      var groupsPro = ref.watch(groupsProvider);
      initChat(ref, args ?? {});
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Images.chatBackground),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: SizeConfig.screenWidth,
                      color: Colors.transparent,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 13.sp,
                            right: 13.sp,
                            top: 18.sp,
                            bottom: 15.sp),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            BackIconButton(
                              size: 24.0.sp,
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            SizedBox(
                              width: 6.0.sp,
                            ),
                            CircleImageAvatar(
                              imagePath: groupsPro.currentBLGroupsList
                                      ?.firstWhere(
                                          (element) => element.key == groupId)
                                      .groupImage ??
                                  '',
                              size: 30.sp,
                            ),
                            SizedBox(
                              width: 10.0.sp,
                            ),
                            Expanded(
                              child: ExtraMediumText(
                                title: groupsPro.currentBLGroupsList
                                            ?.firstWhere((element) =>
                                                element.key == groupId) !=
                                        null
                                    ? groupsPro.currentBLGroupsList
                                        ?.firstWhere(
                                            (element) => element.key == groupId)
                                        .name
                                    : ''.tr(),
                                textColor: AppColors.lightBlack,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (ctx) => GroupInfoDialog(
                                          groupModel: groupsPro
                                              .currentBLGroupsList
                                              ?.firstWhere((element) =>
                                                  element.key == groupId),
                                          onMembersTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (ctx) =>
                                                    GroupMembersDialog(
                                                      userIds: groupsPro
                                                              .currentBLGroupsList
                                                              ?.firstWhere(
                                                                  (element) =>
                                                                      element
                                                                          .key ==
                                                                      groupId)
                                                              .approvedMembers ??
                                                          [],
                                                    ));
                                          },
                                        ));
                              },
                              child: Padding(
                                  padding: EdgeInsets.all(4.sp),
                                  child: Icon(
                                    Icons.info_outline,
                                    color: AppColors.lightBlack,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ScrollablePositionedList.builder(
                        reverse: true,
                        // controller: _scrollController,
                        itemScrollController: itemScrollController,
                        itemPositionsListener: itemPositionsListener,
                        itemCount: groupsPro.currentBLGroupsList
                                ?.firstWhere(
                                    (element) => element.key == groupId)
                                .messages
                                ?.length ??
                            0,
                        padding: EdgeInsets.symmetric(horizontal: 13.sp),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          List<MessageModel>? reversedMessages = groupsPro
                              .currentBLGroupsList
                              ?.firstWhere((element) => element.key == groupId)
                              .messages
                              ?.reversed
                              .toList();
                          MessageModel? messageModel = reversedMessages?[index];

                          return GestureDetector(
                            onLongPress: () {
                              if (messageModel?.uid ==
                                  Auth().currentUser?.uid) {
                                showDeleteMessageBottomSheet(
                                    context, messageModel!);
                              } else {
                                Clipboard.setData(ClipboardData(
                                    text: messageModel?.message ?? ''));
                                Utilities().showCustomToast(
                                    message: 'Message copied!'.tr(),
                                    isError: false);
                              }
                            },
                            child: messageModel?.uid == Auth().currentUser?.uid
                                ? SenderMessageWidget(
                                    messageModel: messageModel,
                                    replyMessage: messageModel?.replyId != null
                                        ? reversedMessages
                                                    ?.where((message) =>
                                                        message.key ==
                                                        messageModel?.replyId)
                                                    .isNotEmpty ==
                                                true
                                            ? reversedMessages?.firstWhere(
                                                (message) =>
                                                    message.key ==
                                                    messageModel?.replyId)
                                            : null
                                        : null,
                                    onSwipeMessage: (message) {
                                      replyToMessage(message);
                                    },
                                    replyWidgetTap: () {
                                      if (messageModel?.replyId != null) {
                                        scrollToReplyMessage(
                                            messageModel?.replyId ?? '',
                                            reversedMessages ?? []);
                                      }
                                    },
                                  )
                                : FutureBuilder<AppUser?>(
                                    future:
                                        fetchUser(messageModel?.uid ?? '', ref),
                                    builder: (context, snapshot) {
                                      var senderName = '';
                                      if (snapshot.hasData) {
                                        senderName =
                                            '${snapshot.data!.firstName ?? ''} ${snapshot.data!.surName ?? ''}';
                                      }
                                      return ReceiverMessageWidget(
                                        senderName: senderName,
                                        messageModel: messageModel,
                                        replyMessage: messageModel?.replyId !=
                                                null
                                            ? reversedMessages
                                                        ?.where((message) =>
                                                            message.key ==
                                                            messageModel
                                                                ?.replyId)
                                                        .isNotEmpty ==
                                                    true
                                                ? reversedMessages?.firstWhere(
                                                    (message) =>
                                                        message.key ==
                                                        messageModel?.replyId)
                                                : null
                                            : null,
                                        onSwipeMessage: (message) {
                                          replyToMessage(message);
                                        },
                                        replyWidgetTap: () {
                                          if (messageModel?.replyId != null) {
                                            scrollToReplyMessage(
                                                messageModel?.replyId ?? '',
                                                reversedMessages ?? []);
                                          }
                                        },
                                      );
                                    },
                                  ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: mentionsData != null
                          ? BottomWriteWidget(
                              mentionsKey: key,
                              onReplyCancel: () {
                                setState(() {
                                  print('update 9');
                                  replyMessage = null;
                                });
                              },
                              focusNode: focusNode,
                              replyMessage: replyMessage,
                              isRecording: isRecording,
                              // showSendButton: showSendButton,
                              mentionsData: mentionsData,
                              pointerDownEvent: (details) {
                                setState(() {
                                  isRecording = true;
                                });
                                key.currentState?.controller?.text =
                                    'Recording...'.tr();
                                _startRecording();
                              },
                              pointerUpEvent: (details) {
                                setState(() {
                                  isRecording = false;
                                });
                                key.currentState?.controller?.clear();
                                _stopRecording(ref);
                              },
                              onCameraTap: () async {
                                XFile? pickedImage = await Utilities.pickImage(
                                    imageSource: 'camera');
                                if (pickedImage != null) {
                                  FileWithType fileWithType = FileWithType(
                                      file: File(pickedImage.path),
                                      fileType: MessageType.image);
                                  pickedFiles ??= [];
                                  pickedFiles?.add(fileWithType);
                                  showBottomSheetWithFiles(ref);
                                  setState(() {
                                    print('update 12');
                                  });
                                }
                              },
                              onAttachmentTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (BuildContext context) {
                                      return PickMediaBottomsheet(
                                        onMediaTap: () {
                                          Navigator.pop(context);
                                          pickMultipleImagesFromGallery(ref);
                                        },
                                        onDocumentTap: () {
                                          Navigator.pop(context);
                                          pickFiles(ref);
                                        },
                                        onLocationTap: () {
                                          Navigator.pop(context);
                                          sendLocationMessage(ref);
                                        },
                                      );
                                    });
                              },
                              onSendTap: () {
                                sendTextMessage(groupId ?? '', ref);
                              },
                            )
                          : Container(),
                    ),
                  ],
                ),
              ),
              FullScreenLoader(
                loading: isLoading,
              )
            ],
          ),
        ),
      );
    });
  }

  Future<AppUser?> fetchUser(String id, WidgetRef ref) async {
    AppUser? user = await ref.watch(appUserProvider).getUserById(id);
    return user;
  }

  manageNotification(WidgetRef ref) async {
    List<AppUser?> usersList = [];
    var groupsPro = ref.watch(groupsProvider);
    var appUserPro = ref.watch(appUserProvider);
    GroupModel? group = groupsPro.currentBLGroupsList
        ?.firstWhere((element) => element.key == groupId);
    groupMembers ??= await appUserPro.getUsersListByIds(groupsPro
        .currentBLGroupsList
        ?.firstWhere((element) => element.key == groupId)
        .approvedMembers
        ?.toSet()
        .toList());
    await appUserPro.listenToAdmins();
    usersList.addAll(groupMembers ?? []);
    usersList.addAll(appUserPro.allAdminsList ?? []);
    NotificationService().sendNotification(group?.key ?? '', usersList,
        group?.name ?? '', appUserPro.currentUser?.firstName ?? '');
  }

  Future<List<Map<String, dynamic>>> setMentionsData(WidgetRef ref) async {
    var groupsPro = ref.watch(groupsProvider);
    var appUserPro = ref.watch(appUserProvider);
    groupMembers = await appUserPro.getUsersListByIds(groupsPro
        .currentBLGroupsList
        ?.firstWhere((element) => element.key == groupId)
        .approvedMembers
        ?.toSet()
        .toList());
    List<Map<String, dynamic>> mapList = [];
    if (groupMembers?.isNotEmpty == true) {
      for (int i = 0; i < groupMembers!.length; i++) {
        Map<String, dynamic> map = {
          'id': groupMembers?[i]?.uid,
          'display':
              '${groupMembers?[i]?.firstName} ${groupMembers?[i]?.surName}'
        };
        mapList.add(map);
      }
    }
    return mapList;
  }

  void fetchMentionsData(WidgetRef ref) async {
    List<Map<String, dynamic>> data = await setMentionsData(ref);
    setState(() {
      print('update 13');
      mentionsData = data;
    });
  }

  sendTextMessage(String groupId, WidgetRef ref) {
    var groupsPro = ref.watch(groupsProvider);
    var appUserPro = ref.watch(appUserProvider);
    if (key.currentState?.controller?.text.isNotEmpty == true) {
      MessageModel messageModel = MessageModel(
          message: key.currentState?.controller?.text,
          uid: Auth().currentUser?.uid,
          replyId: replyMessage?.key,
          timeStamp: DateTime.now().millisecondsSinceEpoch);
      key.currentState?.controller?.clear();
      replyMessage = null;
      GroupsRepository().sendMessage(messageModel, groupId, context, () {
        manageNotification(ref);
        // key.currentState?.controller?.clear();
        groupsPro.incrementUnreadCountsForGroup(
            context,
            groupsPro.currentBLGroupsList!
                .firstWhere((element) => element.key == groupId),
            appUserPro.allAdminsList ?? []);
        manageBusinessListFlags(groupsPro, appUserPro, ref);
      }, (p0) {
        Utilities().showErrorMessage(context, message: p0.toString());
      });
    }
  }

  manageBusinessListFlags(GroupsProvider groupsPro, AppUserProvider appUserPro,
      WidgetRef ref) async {
    var businessPro = ref.read(businessListProvider);
    await businessPro.listenToBusinessList();
    List<String>? admins =
        appUserPro.allAdminsList?.map((user) => user.uid!).toList();
    List<String>? coordinators =
        appUserPro.allCoordinatorsList?.map((user) => user.uid!).toList();
    if (businessPro.businessLists != null) {
      BusinessListRepository().incrementUnreadFlagsForCountries(
          context,
          groupsPro.currentBLGroupsList!
              .firstWhere((element) => element.key == groupId),
          context,
          admins ?? [],
          coordinators ?? [],
          businessPro.businessLists!.firstWhere((element) =>
              element.key ==
              groupsPro.currentBLGroupsList!
                  .firstWhere((element) => element.key == groupId)
                  .businessKey),
          () {},
          (p0) {});
    }
  }

  sendFileMessage(String groupId, FileWithType fileWithType, WidgetRef ref,
      {String? documentName}) async {
    var groupsPro = ref.watch(groupsProvider);
    var appUserPro = ref.watch(appUserProvider);
    setState(() {
      print('update 14');
      isLoading = true;
    });
    String? extension = path
        .extension(fileWithType.file?.path ?? '')
        .toLowerCase()
        .replaceAll('.', '');
    String? fileUrl = fileWithType.file != null
        ? await FirebaseCrud().uploadImage(
            context: context,
            file: File(fileWithType.file!.path),
            ext: extension)
        : null;
    MessageModel messageModel = MessageModel(
        uid: Auth().currentUser?.uid,
        replyId: replyMessage?.key,
        timeStamp: DateTime.now().millisecondsSinceEpoch);
    if (fileWithType.fileType == MessageType.image) {
      messageModel.image = fileUrl;
    } else if (fileWithType.fileType == MessageType.video) {
      messageModel.video = fileUrl;
    } else if (fileWithType.fileType == MessageType.audio) {
      messageModel.audio = fileUrl;
    } else if (fileWithType.fileType == MessageType.document) {
      messageModel.document = fileUrl;
      messageModel.documentName = documentName ?? '';
    }
    replyMessage = null;
    GroupsRepository().sendMessage(messageModel, groupId, context, () {
      manageNotification(ref);
      setState(() {
        print('update 1');
        isLoading = false;
      });
      key.currentState?.controller?.clear();
      groupsPro.incrementUnreadCountsForGroup(
          context,
          groupsPro.currentBLGroupsList!
              .firstWhere((element) => element.key == groupId),
          appUserPro.allAdminsList ?? []);
      manageBusinessListFlags(groupsPro, appUserPro, ref);
    }, (p0) {
      setState(() {
        print('update 2');
        isLoading = false;
      });
      Utilities().showErrorMessage(context, message: p0.toString());
    });
  }

  Future<void> pickMultipleImagesFromGallery(WidgetRef ref) async {
    pickedFiles = null;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg', 'mp4', 'avi', 'mkv'],
      allowMultiple: true,
    );

    if (result != null) {
      pickedFiles ??= [];
      if (result.paths.length < 10) {
        List<File> files = result.paths.map((path) => File(path!)).toList();
        for (var file in files) {
          String fileExtension = file.path.split('.').last.toLowerCase();
          if (['jpg', 'jpeg', 'png'].contains(fileExtension)) {
            FileWithType fileWithType =
                FileWithType(file: file, fileType: MessageType.image);
            pickedFiles?.add(fileWithType);
          } else if (['mp4', 'avi', 'mkv'].contains(fileExtension)) {
            FileWithType fileWithType =
                FileWithType(file: file, fileType: MessageType.video);
            pickedFiles?.add(fileWithType);
          }
        }
        showBottomSheetWithFiles(ref);
      } else {
        Utilities().showErrorMessage(context,
            message: 'You can pick upto 10 images maximum'.tr());
      }
    }
  }

  void scrollToReplyMessage(String replyId, List<MessageModel> messages) {
    int replyIndex = messages.indexWhere((msg) => msg.key == replyId);
    if (replyIndex != -1) {
      itemScrollController.scrollTo(
        index: replyIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  replyToMessage(MessageModel message) {
    setState(() {
      print('update 3');
      replyMessage = message;
    });
    focusNode?.requestFocus();
  }

  void showDeleteMessageBottomSheet(BuildContext context, MessageModel item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DeleteMessageBottomsheet(
          onCancelTap: () {
            Navigator.pop(context);
          },
          textToCopy: item.message,
          onCopyPaste: () {
            Clipboard.setData(ClipboardData(text: item.message ?? ''));
            Utilities().showCustomToast(
                message: 'Message copied!'.tr(), isError: false);
          },
          showEveryoneButton: item.uid != Auth().currentUser?.uid,
          onDeleteForEveryoneTap: () {
            Navigator.pop(context);
            GroupsRepository().deleteMessage(
                context, item.key ?? '', groupId ?? '', () {}, (p0) {
              Utilities()
                  .showCustomToast(message: p0.toString(), isError: true);
            });
          },
        );
      },
    );
  }

  Future<void> pickFiles(WidgetRef ref) async {
    pickedFiles = null;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'docx',
        'xls',
        'xlsx',
        'ppt',
        'pptx',
        'txt'
      ],
    );

    if (result != null) {
      if (result.paths.length < 10) {
        pickedFiles ??= [];
        List<File> files = result.paths.map((path) => File(path!)).toList();
        for (var file in files) {
          FileWithType fileWithType =
              FileWithType(file: file, fileType: MessageType.document);
          pickedFiles?.add(fileWithType);
        }
        showBottomSheetWithFiles(ref);
      } else {
        Utilities().showErrorMessage(context,
            message: 'You can pick upto 10 images maximum'.tr());
      }
    } else {
      print("No file selected");
    }
  }

  void showBottomSheetWithFiles(WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ClassMediaBottomSheet(
          pickedFiles: pickedFiles,
          onSendTap: () {
            Navigator.pop(context);
            for (FileWithType file in pickedFiles ?? []) {
              sendFileMessage(groupId ?? '', file, ref,
                  documentName: file.file?.path.split('/').last);
            }
          },
        );
      },
      isScrollControlled: true,
    );
  }

  Future<void> sendLocationMessage(WidgetRef ref) async {
    var groupsPro = ref.watch(groupsProvider);
    var appUserPro = ref.watch(appUserProvider);
    setState(() {
      print('update 4');
      isLoading = true;
    });
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    print('requesting for location permission');
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    if (permission != LocationPermission.denied &&
        permission != LocationPermission.deniedForever) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      MessageModel messageModel = MessageModel(
          latitude: position.latitude,
          longitude: position.longitude,
          replyId: replyMessage?.key,
          uid: Auth().currentUser?.uid,
          timeStamp: DateTime.now().millisecondsSinceEpoch);
      replyMessage = null;
      GroupsRepository().sendMessage(messageModel, groupId ?? '', context, () {
        manageNotification(ref);
        setState(() {
          print('update 5');
          isLoading = false;
        });
        key.currentState?.controller?.clear();
        groupsPro.incrementUnreadCountsForGroup(
            context,
            groupsPro.currentBLGroupsList!
                .firstWhere((element) => element.key == groupId),
            appUserPro.allAdminsList ?? []);
        manageBusinessListFlags(groupsPro, appUserPro, ref);
        // _animateToBottom();
      }, (p0) {
        setState(() {
          print('update 6');
          isLoading = false;
        });
        Utilities().showErrorMessage(context, message: p0.toString());
      });
    } else {
      setState(() {
        print('update 7');
        isLoading = false;
      });
    }
  }

  Future<void> _startRecording() async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    filePath = '${appDir.path}/audio_record.aac';
    await audioRecorder.startRecorder(
      toFile: filePath,
      codec: Codec.aacADTS,
    );
  }

  Future<void> _stopRecording(WidgetRef ref) async {
    await audioRecorder.stopRecorder();
    if (filePath != null && filePath?.isNotEmpty == true) {
      FileWithType fileWithType =
          FileWithType(file: File(filePath ?? ''), fileType: MessageType.audio);
      pickedFiles = [];
      pickedFiles?.add(fileWithType);
      showBottomSheetWithFiles(ref);
      setState(() {
        print('update 8');
      });
    }
  }
}

class FileWithType {
  File? file;
  MessageType? fileType;

  FileWithType({
    this.file,
    this.fileType,
  });
}
