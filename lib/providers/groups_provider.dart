import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupchat/core/static_keys.dart';
import 'package:groupchat/data/users_model.dart';
import 'package:groupchat/firebase/firebase_crud.dart';

import '../data/group_model.dart';
import '../data/message_model.dart';
import '../firebase/auth.dart';
import '../repositories/groups_repository.dart';

final groupsProvider = ChangeNotifierProvider((ref) => GroupsProvider());

class GroupsProvider extends ChangeNotifier {
  List<GroupModel>? currentBLGroupsList;
  List<AppUser>? usersCache;

  void listenToGroupById(String groupId){
    GroupsRepository().getGroupStreamById(groupId: groupId).listen((groupModel){
      if(groupModel!=null){
        int? existingIndex = currentBLGroupsList?.indexWhere((group) => group.key == groupModel?.key);
        groupModel.messages?.sort((a, b) => a.timeStamp??0.compareTo(b.timeStamp??0));
        if (existingIndex!=null&&existingIndex >= 0) {
          currentBLGroupsList?[existingIndex] = groupModel;
        } else {
          currentBLGroupsList??=[];
          currentBLGroupsList?.add(groupModel);
        }
        if(currentBLGroupsList!=null && currentBLGroupsList?.isNotEmpty==true){
          for(GroupModel group in currentBLGroupsList??[]){
            if(group.messages!=null && group.messages?.isNotEmpty==true){
              group.messages?.sort((a, b) {
                var aTimeStamp = a.timeStamp??0;
                var bTimeStamp = b.timeStamp??0;
                return aTimeStamp.compareTo(bTimeStamp);
              });
            }
          }
        }
        notifyListeners();
      }
    });
  }

  void listenToCurrentBLGroups(String businessKey) {
    GroupsRepository().getGroupsStream(businessKey: businessKey).listen((groupsData) {
      if(groupsData.entries.isNotEmpty == true){
        for (var entry in groupsData.entries) {
          int? existingIndex = currentBLGroupsList?.indexWhere((group) => group.key == entry.key);

          List<MessageModel> sortedMessages = List<MessageModel>.from(entry.value.messages??[]);
          sortedMessages.sort((a, b) => a.timeStamp??0.compareTo(b.timeStamp??0));

          GroupModel updatedGroup = GroupModel(
            key: entry.key,
            businessKey: entry.value.businessKey,
            createdBy: entry.value.createdBy,
            name: entry.value.name,
            pincode: entry.value.pincode,
            groupImage: entry.value.groupImage,
            createdOn: entry.value.createdOn,
            approvedMembers: entry.value.approvedMembers,
            pendingMembers: entry.value.pendingMembers,
            deleted: entry.value.deleted,
            fileUrls: entry.value.fileUrls,
            messages: sortedMessages,
            // messages: entry.value.messages,
            unReadCounts: entry.value.unReadCounts,
            category: entry.value.category,
            categoryList: entry.value.categoryList,
          );

          if (existingIndex!=null&&existingIndex >= 0) {
            currentBLGroupsList?[existingIndex] = updatedGroup;
          } else {
            currentBLGroupsList??=[];
            currentBLGroupsList?.add(updatedGroup);
          }
        }

        if(currentBLGroupsList!=null && currentBLGroupsList?.isNotEmpty==true){
          for(GroupModel group in currentBLGroupsList??[]){
            if(group.messages!=null && group.messages?.isNotEmpty==true){
              group.messages?.sort((a, b) {
                var aTimeStamp = a.timeStamp??0;
                var bTimeStamp = b.timeStamp??0;
                return aTimeStamp.compareTo(bTimeStamp);
              });
            }
          }
        }
      }else{
        currentBLGroupsList = [];
      }
      notifyListeners();
    });
  }

  incrementUnreadCountsForGroup(BuildContext context, GroupModel groupModel, List<AppUser> admins){
    for (String? item in groupModel.approvedMembers??[]){
      if(item != Auth().currentUser?.uid){
        if (groupModel.unReadCounts?.containsKey(item)==true) {
          groupModel.unReadCounts?[item] = (groupModel.unReadCounts?[item] as int) + 1;
        } else {
          groupModel.unReadCounts?[item] = 1;
        }
      }
    }

    for(AppUser admin in admins){
      if(admin.uid != Auth().currentUser?.uid){
        if (groupModel.unReadCounts?.containsKey(admin.uid)==true) {
          groupModel.unReadCounts?[admin.uid] = (groupModel.unReadCounts?[admin.uid] as int) + 1;
        } else {
          groupModel.unReadCounts?[admin.uid] = 1;
        }
      }
    }
    if (groupModel.unReadCounts != null) {
      Map<String, dynamic> map = groupModel.unReadCounts!.cast<String, dynamic>();
      FirebaseCrud().updateData(key: '$groups/${groupModel.key}/unReadCounts', context: context, data: map, onComplete: (){
        print('counts increased...');
      });
    }
  }

}
