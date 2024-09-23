import 'package:groupchat/data/message_model.dart';

class GroupModel{
  String? businessKey, createdBy, name, pincode;
  int? createdOn;
  List<String?>? approvedMembers;
  List<String?>? pendingMembers;
  String? groupImage;
  bool? deleted;
  List<String?>? fileUrls;
  Map<dynamic,dynamic>? messages;
  String? key;
  Map<dynamic, dynamic>? unReadCounts;
  List<String?>? categoryList;
  String? category;

  GroupModel({
    this.businessKey,
    this.createdBy,
    this.name,
    this.pincode,
    this.groupImage,
    this.createdOn,
    this.messages,
    this.pendingMembers,
    this.approvedMembers,
    this.deleted,
    this.fileUrls,
    this.key,
    this.unReadCounts,
    this.categoryList,
    this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'businessKey': this.businessKey,
      'createdBy': this.createdBy,
      'name': this.name,
      'pincode': this.pincode,
      'createdOn': this.createdOn,
      'approvedMembers': this.approvedMembers,
      'deleted': this.deleted,
      'fileUrls': this.fileUrls,
      'groupImage': this.groupImage,
      'key': this.key,
      // 'messages': MessageModel.toListOfMapFromListMap(this.messages??[]),
      'messages': messages,
      'pendingMembers': this.pendingMembers,
      'unReadCounts': this.unReadCounts,
      'categoryList': this.categoryList,
      'category': this.category,
    };
  }

  factory GroupModel.fromMap(Map<dynamic, dynamic> map) {
    int convertedTimeStamp = (map['createdOn'] is double)
        ? (map['createdOn'] as double).round()
        : map['createdOn'] as int;
    return GroupModel(
      businessKey: map.containsKey('businessKey')&&map['businessKey']!=null ? map['businessKey'] as String : null,
      groupImage: map.containsKey('groupImage')&&map['groupImage']!=null ? map['groupImage'] as String : null,
      createdBy: map.containsKey('createdBy')&&map['createdBy']!=null ? map['createdBy'] as String : null,
      name: map.containsKey('name')&&map['name']!=null ? map['name'] as String : null,
      pincode: map.containsKey('pincode')&&map['pincode']!=null ? map['pincode'] as String : null,
      createdOn: map.containsKey('createdOn')&&map['createdOn']!=null ? convertedTimeStamp : null,
      approvedMembers: map.containsKey('approvedMembers') && map['approvedMembers'] != null
          ? List<String?>.from(map["approvedMembers"].map((x) => x))
          : null,
      // messages: map.containsKey('messages')&& map['messages']!=null
      //     ? MessageModel.toListFromListMap(map['messages']) : null,
      messages: map.containsKey('messages')&& map['messages']!=null
          ? map['messages'] : null,
      pendingMembers: map.containsKey('pendingMembers') && map['pendingMembers'] != null
          ? List<String?>.from(map["pendingMembers"].map((x) => x))
          : null,
      deleted: map.containsKey('deleted') && map['deleted'] != null ? map["deleted"] as bool : null,
      fileUrls: map.containsKey('fileUrls') && map['fileUrls'] != null
          ? List<String?>.from(map["fileUrls"].map((x) => x))
          : null,
      key: map.containsKey('key')&&map['key']!=null ? map['key'] as String : null,
      unReadCounts: map.containsKey('unReadCounts')&&map['unReadCounts']!=null ? map['unReadCounts'] : null,
      categoryList: map.containsKey('categoryList') && map['categoryList'] != null
          ? List<String?>.from(map["categoryList"].map((x) => x))
          : null,
      category: map.containsKey('category')&&map['category']!=null ? map['category'] as String : null,
    );
  }
}