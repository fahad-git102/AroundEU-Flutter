import 'package:flutter/cupertino.dart';

class MessageModel{
  String? message, uid, image, video, audio, key, replyId, document, documentName;
  double? latitude, longitude;
  int? audioTime, timeStamp;

  MessageModel({
    this.message,
    this.uid,
    this.image,
    this.video,
    this.audio,
    this.documentName,
    this.key,
    this.document,
    this.replyId,
    this.timeStamp,
    this.latitude,
    this.longitude,
    this.audioTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'message': this.message,
      'uid': this.uid,
      'image': this.image,
      'document': this.document,
      'video': this.video,
      'audio': this.audio,
      'documentName': this.documentName,
      'timeStamp': this.timeStamp,
      'key': this.key,
      'replyId': this.replyId,
      'latitude': this.latitude,
      'longitude': this.longitude,
      'audioTime': this.audioTime,
    };
  }

  factory MessageModel.fromMap(Map<dynamic, dynamic> map) {
    int convertedTimeStamp = (map['timeStamp'] is double)
        ? (map['timeStamp'] as double).round()
        : map['timeStamp'] as int;
    return MessageModel(
      message: map.containsKey('message')&&map['message']!=null ? map['message'] as String : null,
      uid: map.containsKey('uid')&&map['uid']!=null ? map['uid'] as String : null,
      image: map.containsKey('image')&&map['image']!=null ? map['image'] as String : null,
      video: map.containsKey('video')&&map['video']!=null ? map['video'] as String : null,
      document: map.containsKey('document')&&map['document']!=null ? map['document'] as String : null,
      documentName: map.containsKey('documentName')&&map['documentName']!=null ? map['documentName'] as String : null,
      audio: map.containsKey('audio')&&map['audio']!=null ? map['audio'] as String : null,
      key: map.containsKey('key')&&map['key']!=null ? map['key'] as String : null,
      replyId: map.containsKey('replyId')&&map['replyId']!=null ? map['replyId'] as String : null,
      latitude: map.containsKey('latitude')&&map['latitude']!=null ? map['latitude'] as double : null,
      longitude: map.containsKey('longitude')&&map['longitude']!=null ? map['longitude'] as double : null,
      audioTime: map.containsKey('audioTime')&&map['audioTime']!=null ? map['audioTime'] as int : null,
      timeStamp: map.containsKey('timeStamp')&&map['timeStamp']!=null ? convertedTimeStamp : null,
    );
  }

  static toListFromListMap(List m) {
    List<MessageModel> messages = [];
    for (int i = 0; i < m.length; i++) {
      messages.add(MessageModel.fromMap(m[i]));
    }
    return messages;
  }

  static List<MessageModel> toListFromMap(Map<dynamic, dynamic> map) {
    List<MessageModel> messages = [];
    map.forEach((key, value) {
      messages.add(MessageModel.fromMap(Map<String, dynamic>.from(value)));
    });
    return messages;
  }

  static toListOfMapFromListMap(List<MessageModel> m) {
    List<Map> messages = [];
    for (int i = 0; i < m.length; i++) {
      messages.add(m[i].toMap());
    }
    return messages;
  }

}