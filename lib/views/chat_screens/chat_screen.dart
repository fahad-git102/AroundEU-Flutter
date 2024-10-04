import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:groupchat/component_library/bottomsheets/chat_media_bottomsheet.dart';
import 'package:groupchat/component_library/bottomsheets/pick_media_bottomsheet.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:groupchat/component_library/chat_widgets/bottom_write_widget.dart';
import 'package:groupchat/component_library/chat_widgets/receiver_message_widget.dart';
import 'package:groupchat/component_library/chat_widgets/sender_message_widget.dart';
import 'package:groupchat/component_library/dialogs/add_new_group_dialog.dart';
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
import 'package:sizer/sizer.dart';

import '../../component_library/app_bars/custom_app_bar.dart';
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

  updateState() {
    setState(() {});
  }

  Future<void> _initRecorder() async {
    await Permission.microphone.request();
    await audioRecorder.openRecorder();
  }

  @override
  void dispose() {
    audioRecorder.closeRecorder();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  void _animateToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void initState() {
    _initRecorder();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _scrollToBottom();
      }
    });
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
    }
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
                    image: AssetImage(Images.mainBackground),
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
                            ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(30.sp)),
                              child: CachedNetworkImage(imageUrl: groupsPro.currentBLGroupsList
                                  ?.firstWhere((element) => element.key == groupId)
                                  .groupImage??'', height: 30.sp, width: 30.sp, fit: BoxFit.fill,),
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
                                    : 'Chat'.tr(),
                                textColor: AppColors.lightBlack,
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                showDialog(context: context, builder: (ctx)=> GroupInfoDialog(
                                  groupModel: groupsPro.currentBLGroupsList
                                      ?.firstWhere((element) => element.key == groupId),
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
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: groupsPro.currentBLGroupsList
                                ?.firstWhere(
                                    (element) => element.key == groupId)
                                .messages
                                ?.length ??
                            0,
                        padding: EdgeInsets.symmetric(horizontal: 13.sp),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          MessageModel? messageModel = groupsPro
                              .currentBLGroupsList
                              ?.firstWhere((element) => element.key == groupId)
                              .messages?[index];
                          return groupsPro.currentBLGroupsList
                                      ?.firstWhere(
                                          (element) => element.key == groupId)
                                      .messages?[index]
                                      .uid ==
                                  Auth().currentUser?.uid
                              ? SenderMessageWidget(
                                  messageModel: groupsPro.currentBLGroupsList
                                      ?.firstWhere(
                                          (element) => element.key == groupId)
                                      .messages?[index],
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
                                    );
                                  },
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
                          showEmojis = false;
                          updateState();
                        },
                        child: BottomWriteWidget(
                          mentionsKey: key,
                          emojiPressed: () {
                            showEmojis = !showEmojis!;
                            updateState();
                          },
                          isRecording: isRecording,
                          showEmojis: showEmojis,
                          showSendButton: showSendButton,
                          mentionsData: [],
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
                            if (val.isNotEmpty && isRecording == false) {
                              showSendButton = true;
                              updateState();
                            } else {
                              showSendButton = false;
                              updateState();
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
                        ),
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

  sendTextMessage(String groupId) {
    if (key.currentState?.controller?.text.isNotEmpty == true) {
      MessageModel messageModel = MessageModel(
          message: key.currentState?.controller?.text,
          uid: Auth().currentUser?.uid,
          timeStamp: DateTime.now().millisecondsSinceEpoch);
      GroupsRepository().sendMessage(messageModel, groupId, context, () {
        key.currentState?.controller?.clear();
        _animateToBottom();
      }, (p0) {
        Utilities().showErrorMessage(context, message: p0.toString());
      });
    }
  }

  sendFileMessage(String groupId, FileWithType fileWithType,
      {String? documentName}) async {
    isLoading = true;
    updateState();
    String? fileUrl = fileWithType.file != null
        ? await FirebaseCrud()
            .uploadImage(context: context, file: File(fileWithType.file!.path))
        : null;
    MessageModel messageModel = MessageModel(
        uid: Auth().currentUser?.uid,
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
    GroupsRepository().sendMessage(messageModel, groupId, context, () {
      isLoading = false;
      updateState();
      key.currentState?.controller?.clear();
      _animateToBottom();
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
    isLoading = true;
    updateState();
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

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
          uid: Auth().currentUser?.uid,
          timeStamp: DateTime.now().millisecondsSinceEpoch);
      GroupsRepository().sendMessage(messageModel, groupId ?? '', context, () {
        isLoading = false;
        updateState();
        key.currentState?.controller?.clear();
        _animateToBottom();
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
