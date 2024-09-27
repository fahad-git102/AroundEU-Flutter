import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupchat/component_library/chat_widgets/bottom_textfield_widget.dart';
import 'package:groupchat/component_library/chat_widgets/receiver_message_widget.dart';
import 'package:groupchat/component_library/chat_widgets/sender_message_widget.dart';
import 'package:groupchat/core/utilities_class.dart';
import 'package:groupchat/firebase/auth.dart';
import 'package:groupchat/providers/app_user_provider.dart';
import 'package:sizer/sizer.dart';

import '../../component_library/app_bars/custom_app_bar.dart';
import '../../core/assets_names.dart';
import '../../core/size_config.dart';
import '../../data/message_model.dart';
import '../../data/users_model.dart';
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

  @override
  void dispose() {
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
        duration: Duration(milliseconds: 300),  // Adjust the duration as needed
        curve: Curves.easeInOut,  // Choose the desired animation curve
      );
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      if(mounted){
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
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Images.mainBackground),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              CustomAppBar(
                title: groupsPro.currentBLGroupsList
                            ?.firstWhere((element) => element.key == groupId) !=
                        null
                    ? groupsPro.currentBLGroupsList
                        ?.firstWhere((element) => element.key == groupId)
                        .name
                    : 'Chat'.tr(),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: groupsPro.currentBLGroupsList
                          ?.firstWhere((element) => element.key == groupId)
                          .messages
                          ?.length ??
                      0,
                  padding: EdgeInsets.symmetric(horizontal: 13.sp),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    MessageModel? messageModel = groupsPro.currentBLGroupsList
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
                              return InkWell(
                                onTap: (){
                                  print(messageModel?.timeStamp);
                                },
                                child: ReceiverMessageWidget(
                                  senderName: senderName,
                                  messageModel: messageModel,
                                ),
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
                child: BottomTextfieldWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<AppUser?> fetchUser(String id) async {
    AppUser? user = await ref.watch(appUserProvider).getUserById(id);
    return user;
  }

}
