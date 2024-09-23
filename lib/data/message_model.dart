class MessageModel{
  String? message, uid, image, video, audio, key, replyId;
  double? latitude, longitude;
  int? audioTime;

  MessageModel({
    this.message,
    this.uid,
    this.image,
    this.video,
    this.audio,
    this.key,
    this.replyId,
    this.latitude,
    this.longitude,
    this.audioTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'message': this.message,
      'uid': this.uid,
      'image': this.image,
      'video': this.video,
      'audio': this.audio,
      'key': this.key,
      'replyId': this.replyId,
      'latitude': this.latitude,
      'longitude': this.longitude,
      'audioTime': this.audioTime,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      message: map.containsKey('message')&&map['message']!=null ? map['message'] as String : null,
      uid: map.containsKey('uid')&&map['uid']!=null ? map['uid'] as String : null,
      image: map.containsKey('image')&&map['image']!=null ? map['image'] as String : null,
      video: map.containsKey('video')&&map['video']!=null ? map['video'] as String : null,
      audio: map.containsKey('audio')&&map['audio']!=null ? map['audio'] as String : null,
      key: map.containsKey('key')&&map['key']!=null ? map['key'] as String : null,
      replyId: map.containsKey('replyId')&&map['replyId']!=null ? map['replyId'] as String : null,
      latitude: map.containsKey('latitude')&&map['latitude']!=null ? map['latitude'] as double : null,
      longitude: map.containsKey('longitude')&&map['longitude']!=null ? map['longitude'] as double : null,
      audioTime: map.containsKey('audioTime')&&map['audioTime']!=null ? map['audioTime'] as int : null,
    );
  }

  static toListFromListMap(List m) {
    List<MessageModel> messages = [];
    for (int i = 0; i < m.length; i++) {
      messages.add(MessageModel.fromMap(m[i]));
    }
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