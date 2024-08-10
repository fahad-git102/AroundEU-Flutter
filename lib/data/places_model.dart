import 'location_model.dart';

class EUPlace {
  String? key, description, uid, imageUrl, category, status, country, creatorName;
  int? timeStamp;
  LocationModel? location;

  EUPlace({
    this.key,
    this.description,
    this.uid,
    this.creatorName,
    this.location,
    this.imageUrl,
    this.category,
    this.status,
    this.country,
    this.timeStamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'key': this.key,
      'description': this.description,
      'uid': this.uid,
      'creatorName': this.creatorName,
      'imageUrl': this.imageUrl,
      'category': this.category,
      'location': this.location?.toMap(),
      'status': this.status,
      'country': this.country,
      'timeStamp': this.timeStamp,
    };
  }

  factory EUPlace.fromMap(Map<String, dynamic> map) {
    int convertedTimeStamp = (map['timeStamp'] is double)
        ? (map['timeStamp'] as double).round()
        : map['timeStamp'] as int;
    return EUPlace(
      key: map.containsKey('key')&&map['key']!=null ? map['key'] as String : null,
      description: map.containsKey('description')&&map['description']!=null ? map['description'] as String : null,
      uid: map.containsKey('uid')&&map['uid']!=null ? map['uid'] as String : null,
      location: map.containsKey('location') && map['location'] != null
          ? LocationModel.fromMap(Map<String, dynamic>.from(map['location'] as Map))
          : null,
      imageUrl: map.containsKey('imageUrl')&&map['imageUrl']!=null ? map['imageUrl'] as String : null,
      category: map.containsKey('category')&&map['category']!=null ? map['category'] as String : null,
      creatorName: map.containsKey('creatorName')&&map['creatorName']!=null ? map['creatorName'] as String : null,
      status: map.containsKey('status')&&map['status']!=null ? map['status'] as String : null,
      country: map.containsKey('country')&&map['country']!=null ? map['country'] as String : null,
      timeStamp: map.containsKey('timeStamp')&&map['timeStamp']!=null ? convertedTimeStamp : null,
    );
  }

}