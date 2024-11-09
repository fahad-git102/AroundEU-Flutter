import 'dart:async';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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

class ChatScreen extends ConsumerStatefulWidget {
  static const route = 'ChatScreen';

  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  List<Map<String, dynamic>>? mentionsData;
  String? groupId;
  final ScrollController _scrollController = ScrollController();
  bool? pageStarted = true;
  List<FileWithType>? pickedFiles;
  bool? isLoading = false;
  bool? showSendButton = false;
  GlobalKey<FlutterMentionsState> key = GlobalKey<FlutterMentionsState>();
  bool? isRecording = false;
  bool? showEmojis = false;
  FlutterSoundRecorder audioRecorder = FlutterSoundRecorder();
  String? filePath;
  double dragExtent = 0.0;
  double threshold = 0.5;
  List<AppUser?>? groupMembers;
  BusinessList? currentBusinessList;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  MessageModel? replyMessage;
  FocusNode? focusNode = FocusNode();

  updateState() {
    setState(() {});
  }

  Future<void> _initRecorder() async {
    print('requesting for microphone');
    await Permission.microphone.request();
    await audioRecorder.openRecorder();
  }

  @override
  void dispose() {
    audioRecorder.closeRecorder();
    key.currentState?.controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _initRecorder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final args = ModalRoute.of(context)!.settings.arguments != null
        ? ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>
        : null;
    var groupsPro = ref.watch(groupsProvider);
    if (args != null && pageStarted == true) {
      pageStarted = false;
      groupId = args['groupId'] ?? '';
      GroupsRepository().readAllMessages(groupId??'');
      ref.watch(appUserProvider).listenToAdmins();
      ref.watch(appUserProvider).listenToCoordinators();
    }
    if(groupsPro.currentBLGroupsList==null || groupsPro.currentBLGroupsList?.isEmpty==true){
      groupsPro.listenToGroupById(groupId??'');
    }else{
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
    if(mentionsData==null){
      fetchMentionsData();
    }
    if(currentBusinessList==null){
      if(groupsPro.currentBLGroupsList
          ?.firstWhere((element) => element.key == groupId) !=
          null){
        GroupModel? groupModel = groupsPro.currentBLGroupsList
            ?.firstWhere((element) => element.key == groupId);
        var businessPro = ref.watch(businessListProvider);
        businessPro.listenToBusinessList();
        for(BusinessList item in businessPro.businessLists??[]){
          if(item.key == groupModel?.businessKey){
            currentBusinessList = item;
          }
        }
        BusinessListRepository().resetFlagForMe(context, currentBusinessList);
      }
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                showEmojis = false;
                updateState();
              },
              child: Container(
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
                        padding: EdgeInsets.only(left: 13.sp, right: 13.sp, top: 18.sp, bottom: 15.sp),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            BackIconButton(
                              size: 24.0.sp,
                              onTap: (){
                                Navigator.of(context).pop();
                              },
                            ),
                            SizedBox(width: 6.0.sp,),
                            CircleImageAvatar(
                              imagePath: groupsPro.currentBLGroupsList
                                ?.firstWhere((element) => element.key == groupId)
                          .groupImage??'',
                              size: 30.sp,
                            ),
                            SizedBox(width: 10.0.sp,),
                            Expanded(
                              child: ExtraMediumText(
                                title: groupsPro.currentBLGroupsList?.firstWhere(
                                        (element) => element.key == groupId) !=
                                    null
                                    ? groupsPro.currentBLGroupsList
                                    ?.firstWhere((element) => element.key == groupId)
                                    .name
                                    : ''.tr(),
                                textColor: AppColors.lightBlack,
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                showDialog(context: context, builder: (ctx) => GroupInfoDialog(
                                  groupModel: groupsPro.currentBLGroupsList
                                      ?.firstWhere((element) => element.key == groupId),
                                  onMembersTap: (){
                                    showDialog(context: context, builder: (ctx) => GroupMembersDialog(
                                      userIds: groupsPro.currentBLGroupsList
                                          ?.firstWhere((element) => element.key == groupId).approvedMembers??[],
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
                            ?.firstWhere((element) => element.key == groupId)
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
                              if(messageModel?.uid == Auth().currentUser?.uid){
                                showDeleteMessageBottomSheet(context, messageModel!);
                              }
                            },
                            child: messageModel?.uid == Auth().currentUser?.uid
                                ? SenderMessageWidget(
                              messageModel: messageModel,
                              replyMessage: messageModel?.replyId!=null ? reversedMessages
                                  ?.where((message) => message.key == messageModel?.replyId)
                                  .isNotEmpty == true
                                  ? reversedMessages?.firstWhere((message) => message.key == messageModel?.replyId)
                                  : null:null,
                              onSwipeMessage: (message){
                                replyToMessage(message);
                              },
                              replyWidgetTap: (){
                                if(messageModel?.replyId!=null){
                                  scrollToReplyMessage(messageModel?.replyId??'', reversedMessages??[]);
                                }
                              },
                            )
                                : FutureBuilder<AppUser?>(
                              future: fetchUser(messageModel?.uid ?? ''),
                              builder: (context, snapshot) {
                                var senderName = '';
                                if (snapshot.hasData) {
                                  senderName =
                                  '${snapshot.data!.firstName ?? ''} ${snapshot.data!.surName ?? ''}';
                                }
                                return ReceiverMessageWidget(
                                  senderName: senderName,
                                  messageModel: messageModel,
                                  replyMessage: messageModel?.replyId!=null ? reversedMessages
                                      ?.where((message) => message.key == messageModel?.replyId)
                                      .isNotEmpty == true
                                      ? reversedMessages?.firstWhere((message) => message.key == messageModel?.replyId)
                                      : null:null,
                                  onSwipeMessage: (message){
                                    replyToMessage(message);
                                  },
                                  replyWidgetTap: (){
                                    if(messageModel?.replyId!=null){
                                      scrollToReplyMessage(messageModel?.replyId??'', reversedMessages??[]);
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
                      child: GestureDetector(
                        onTap: () {
                          // showEmojis = false;
                          showSendButton = false;
                          updateState();
                        },
                        child: mentionsData!=null?BottomWriteWidget(
                          mentionsKey: key,
                          onReplyCancel: (){
                            setState(() {
                              replyMessage = null;
                            });
                          },
                          focusNode: focusNode,
                          replyMessage: replyMessage,
                          // emojiPressed: () {
                          //   showEmojis = !showEmojis!;
                          //   if(showEmojis == true){
                          //     showSendButton = true;
                          //   }else{
                          //     showSendButton = false;
                          //   }
                          //   updateState();
                          // },
                          isRecording: isRecording,
                          // showEmojis: showEmojis,
                          showSendButton: showSendButton,
                          mentionsData: mentionsData,
                          pointerDownEvent: (details) {
                            showEmojis = false;
                            isRecording = true;
                            updateState();
                            key.currentState?.controller?.text =
                                'Recording...'.tr();
                            _startRecording();
                          },
                          pointerUpEvent: (details) {
                            isRecording = false;
                            updateState();
                            key.currentState?.controller?.clear();
                            _stopRecording();
                          },
                          onTextFieldChanged: (val) {
                            if(showEmojis == false){
                              if (val.isNotEmpty && isRecording == false) {
                                setState(() {
                                  showSendButton = true;
                                });
                              } else {
                                setState(() {
                                  showSendButton = false;
                                });
                              }
                            }
                          },
                          onCameraTap: () async {
                            showEmojis = false;
                            XFile? pickedImage = await Utilities.pickImage(
                                imageSource: 'camera');
                            if (pickedImage != null) {
                              FileWithType fileWithType = FileWithType(
                                  file: File(pickedImage.path ?? ''),
                                  fileType: MessageType.image);
                              pickedFiles ??= [];
                              pickedFiles?.add(fileWithType);
                              showBottomSheetWithFiles();
                              updateState();
                            }
                          },
                          onAttachmentTap: () {
                            showEmojis = false;
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (BuildContext context) {
                                  return PickMediaBottomsheet(
                                    onMediaTap: () {
                                      Navigator.pop(context);
                                      pickMultipleImagesFromGallery();
                                    },
                                    onDocumentTap: () {
                                      Navigator.pop(context);
                                      pickFiles();
                                    },
                                    onLocationTap: () {
                                      Navigator.pop(context);
                                      sendLocationMessage();
                                    },
                                  );
                                });
                          },
                          onSendTap: () {
                            sendTextMessage(groupId ?? '');
                          },
                        ):Container()
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FullScreenLoader(
              loading: isLoading,
            )
          ],
        ),
      ),
    );
  }

  Future<AppUser?> fetchUser(String id) async {
    AppUser? user = await ref.watch(appUserProvider).getUserById(id);
    return user;
  }

  manageNotification() async {
    List<AppUser?> usersList = [];
    var groupsPro = ref.watch(groupsProvider);
    var appUserPro = ref.watch(appUserProvider);
    GroupModel? group = groupsPro
        .currentBLGroupsList
        ?.firstWhere((element) => element.key == groupId);
    groupMembers ??= await appUserPro.getUsersListByIds(groupsPro
        .currentBLGroupsList
        ?.firstWhere((element) => element.key == groupId).approvedMembers?.toSet().toList());
    await appUserPro.listenToAdmins();
    usersList.addAll(groupMembers??[]);
    usersList.addAll(appUserPro.allAdminsList??[]);
    NotificationService().sendNotification(group?.key??'', usersList, group?.name??'', appUserPro.currentUser?.firstName??'');
  }

  Future<List<Map<String, dynamic>>> setMentionsData() async {
    var groupsPro = ref.watch(groupsProvider);
    var appUserPro = ref.watch(appUserProvider);
    groupMembers = await appUserPro.getUsersListByIds(groupsPro
        .currentBLGroupsList
        ?.firstWhere((element) => element.key == groupId).approvedMembers?.toSet().toList());
    List<Map<String, dynamic>> mapList = [];
    if(groupMembers?.isNotEmpty==true){
      for(int i = 0; i<groupMembers!.length; i++){
        Map<String, dynamic> map = {
          'id': groupMembers?[i]?.uid,
          'display': '${groupMembers?[i]?.firstName} ${groupMembers?[i]?.surName}'
        };
        mapList.add(map);
      }
    }
    return mapList;
  }

  void fetchMentionsData() async {
    List<Map<String, dynamic>> data = await setMentionsData();
    setState(() {
      mentionsData = data;
    });
  }

  sendTextMessage(String groupId) {
    var groupsPro = ref.watch(groupsProvider);
    var appUserPro = ref.watch(appUserProvider);
    if (key.currentState?.controller?.text.isNotEmpty == true) {
      MessageModel messageModel = MessageModel(
          message: key.currentState?.controller?.text,
          uid: Auth().currentUser?.uid,
          replyId: replyMessage?.key,
          timeStamp: DateTime.now().millisecondsSinceEpoch);
      replyMessage = null;
      GroupsRepository().sendMessage(messageModel, groupId, context, () {
        manageNotification();
        key.currentState?.controller?.clear();
        groupsPro.incrementUnreadCountsForGroup(context, groupsPro.currentBLGroupsList
        !.firstWhere((element) => element.key == groupId), appUserPro.allAdminsList??[]);
        manageBusinessListFlags(groupsPro, appUserPro);
      }, (p0) {
        Utilities().showErrorMessage(context, message: p0.toString());
      });
    }
  }

  manageBusinessListFlags(GroupsProvider groupsPro, AppUserProvider appUserPro) async {
    var businessPro = ref.read(businessListProvider);
    await businessPro.listenToBusinessList();
    List<String>? admins = appUserPro.allAdminsList?.map((user) => user.uid!).toList();
    List<String>? coordinators = appUserPro.allCoordinatorsList?.map((user) => user.uid!).toList();
    if(businessPro.businessLists!=null){
      BusinessListRepository().incrementUnreadFlagsForCountries(context, groupsPro.currentBLGroupsList
      !.firstWhere((element) => element.key == groupId), context, admins??[], coordinators??[],
          businessPro.businessLists!.firstWhere((element)=> element.key == groupsPro.currentBLGroupsList
          !.firstWhere((element) => element.key == groupId).businessKey), (){}, (p0){});
    }
  }

  sendFileMessage(String groupId, FileWithType fileWithType,
      {String? documentName}) async {
    var groupsPro = ref.watch(groupsProvider);
    var appUserPro = ref.watch(appUserProvider);
    isLoading = true;
    updateState();
    String? extension = path.extension(fileWithType.file?.path??'').toLowerCase().replaceAll('.', '');
    String? fileUrl = fileWithType.file != null
        ? await FirebaseCrud()
            .uploadImage(context: context, file: File(fileWithType.file!.path), ext: extension)
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
      manageNotification();
      isLoading = false;
      updateState();
      key.currentState?.controller?.clear();
      groupsPro.incrementUnreadCountsForGroup(context, groupsPro.currentBLGroupsList
          !.firstWhere((element) => element.key == groupId), appUserPro.allAdminsList??[]);
      manageBusinessListFlags(groupsPro, appUserPro);
    }, (p0) {
      isLoading = false;
      updateState();
      Utilities().showErrorMessage(context, message: p0.toString());
    });
  }

  Future<void> pickMultipleImagesFromGallery() async {
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
        showBottomSheetWithFiles();
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
  //
  // void scrollToReplyMessage(String replyId, List<MessageModel> messages) {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     int replyIndex = messages.indexWhere((msg) => msg.key == replyId);
  //     if (replyIndex != -1) {
  //       final targetKey = messages[replyIndex].globalKey;
  //       if (targetKey.currentContext != null) {
  //         Scrollable.ensureVisible(
  //           targetKey.currentContext!,
  //           duration: const Duration(milliseconds: 300),
  //           curve: Curves.easeInOut,
  //         );
  //       }
  //     }
  //   });
  // }

  replyToMessage(MessageModel message){
    setState(() {
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
            Navigator.pop(context); // Close the sheet on cancel
          },
          showEveryoneButton: item.uid != Auth().currentUser?.uid,
          onDeleteForEveryoneTap: () {
            Navigator.pop(context);
            GroupsRepository().deleteMessage(context, item.key??'', groupId??'', (){

            }, (p0){
              Utilities().showCustomToast(message: p0.toString(), isError: true);
            });
          },
        );
      },
    );
  }


  Future<void> pickFiles() async {
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
        showBottomSheetWithFiles();
      } else {
        Utilities().showErrorMessage(context,
            message: 'You can pick upto 10 images maximum'.tr());
      }
    } else {
      print("No file selected");
    }
  }

  void showBottomSheetWithFiles() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ClassMediaBottomSheet(
          pickedFiles: pickedFiles,
          onSendTap: () {
            Navigator.pop(context);
            for (FileWithType file in pickedFiles ?? []) {
              sendFileMessage(groupId ?? '', file,
                  documentName: file.file?.path.split('/').last);
            }
          },
        );
      },
      isScrollControlled: true,
    );
  }

  Future<void> sendLocationMessage() async {
    var groupsPro = ref.watch(groupsProvider);
    var appUserPro = ref.watch(appUserProvider);
    isLoading = true;
    updateState();
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
        manageNotification();
        isLoading = false;
        updateState();
        key.currentState?.controller?.clear();
        groupsPro.incrementUnreadCountsForGroup(context, groupsPro.currentBLGroupsList
        !.firstWhere((element) => element.key == groupId), appUserPro.allAdminsList??[]);
        manageBusinessListFlags(groupsPro, appUserPro);
        // _animateToBottom();
      }, (p0) {
        isLoading = false;
        updateState();
        Utilities().showErrorMessage(context, message: p0.toString());
      });
    } else {
      isLoading = false;
      updateState();
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

  Future<void> _stopRecording() async {
    await audioRecorder.stopRecorder();
    if (filePath != null && filePath?.isNotEmpty == true) {
      FileWithType fileWithType =
          FileWithType(file: File(filePath ?? ''), fileType: MessageType.audio);
      pickedFiles = [];
      pickedFiles?.add(fileWithType);
      showBottomSheetWithFiles();
      updateState();
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
