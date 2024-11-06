class BusinessList {
  String? key, name, countryId;
  bool? deleted;
  int? timeStamp;
  bool? showDot;
  Map<dynamic, dynamic>? unReadFlags;

  BusinessList({
    this.key,
    this.name,
    this.showDot,
    this.countryId,
    this.deleted=false,
    this.unReadFlags,
    this.timeStamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'key': this.key,
      'name': this.name,
      'showDot': this.showDot,
      'countryId': this.countryId,
      'deleted': this.deleted,
      'unReadFlags': this.unReadFlags,
      'timeStamp': this.timeStamp,
    };
  }

  factory BusinessList.fromMap(Map<String, dynamic> map) {
    int convertedTimeStamp = (map['timeStamp'] is double)
        ? (map['timeStamp'] as double).round()
        : map['timeStamp'] as int;
    return BusinessList(
      key: map.containsKey('key')&&map['key']!=null ? map['key'] as String : null,
      unReadFlags: map.containsKey('unReadFlags')&&map['unReadFlags']!=null ? map['unReadFlags'] : null,
      name: map.containsKey('name')&&map['name']!=null ? map['name'] as String : null,
      countryId: map.containsKey('countryId')&&map['countryId']!=null ? map['countryId'] as String : null,
      deleted: map.containsKey('deleted')&&map['deleted']!=null ? map['deleted'] as bool : null,
      showDot: map.containsKey('showDot')&&map['showDot']!=null ? map['showDot'] as bool : null,
      timeStamp: map.containsKey('timeStamp')&&map['timeStamp']!=null ? convertedTimeStamp : null,
    );
  }
}