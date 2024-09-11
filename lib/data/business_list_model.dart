class BusinessList {
  String? key, name, countryId;
  bool? deleted;
  int? timeStamp;

  BusinessList({
    this.key,
    this.name,
    this.countryId,
    this.deleted=false,
    this.timeStamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'key': this.key,
      'name': this.name,
      'countryId': this.countryId,
      'deleted': this.deleted,
      'timeStamp': this.timeStamp,
    };
  }

  factory BusinessList.fromMap(Map<String, dynamic> map) {
    int convertedTimeStamp = (map['timeStamp'] is double)
        ? (map['timeStamp'] as double).round()
        : map['timeStamp'] as int;
    return BusinessList(
      key: map.containsKey('key')&&map['key']!=null ? map['key'] as String : null,
      name: map.containsKey('name')&&map['name']!=null ? map['name'] as String : null,
      countryId: map.containsKey('countryId')&&map['countryId']!=null ? map['countryId'] as String : null,
      deleted: map.containsKey('deleted')&&map['deleted']!=null ? map['deleted'] as bool : null,
      timeStamp: map.containsKey('timeStamp')&&map['timeStamp']!=null ? convertedTimeStamp : null,
    );
  }
}