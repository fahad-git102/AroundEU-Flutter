import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/group_model.dart';
import '../repositories/groups_repository.dart';

final groupsProvider = ChangeNotifierProvider((ref) => GroupsProvider());

class GroupsProvider extends ChangeNotifier {
  List<GroupModel>? currentBLGroupsList;

  void listenToCurrentBLGroups(String businessKey) {
    GroupsRepository().getGroupsStream(businessKey: businessKey).listen((groupsData) {
      currentBLGroupsList = groupsData.entries.map((entry) {
        return GroupModel(
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
          messages: entry.value.messages,
          unReadCounts: entry.value.unReadCounts,
          category: entry.value.category,
          categoryList: entry.value.categoryList,
        );
      }).toList();
      notifyListeners();
    });
  }
}
