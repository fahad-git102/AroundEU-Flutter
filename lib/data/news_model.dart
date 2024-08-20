class NewsModel{
  String? id, country, description, imageUrl, title, uid;
  int? timeStamp;

  NewsModel({
    this.id,
    this.country,
    this.description,
    this.imageUrl,
    this.title,
    this.uid,
    this.timeStamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'country': this.country,
      'description': this.description,
      'imageUrl': this.imageUrl,
      'title': this.title,
      'uid': this.uid,
      'timeStamp': this.timeStamp,
    };
  }

  factory NewsModel.fromMap(Map<String, dynamic> map) {
    int convertedTimeStamp = (map['timeStamp'] is double)
        ? (map['timeStamp'] as double).round()
        : map['timeStamp'] as int;
    return NewsModel(
      description: map.containsKey('description')&&map['description']!=null ? map['description'] as String : null,
      id: map.containsKey('id')&&map['id']!=null ? map['id'] as String : null,
      country: map.containsKey('country')&&map['country']!=null ? map['country'] as String : null,
      imageUrl: map.containsKey('imageUrl')&&map['imageUrl']!=null ? map['imageUrl'] as String : null,
      title: map.containsKey('title')&&map['title']!=null ? map['title'] as String : null,
      uid: map.containsKey('uid')&&map['uid']!=null ? map['uid'] as String : null,
      timeStamp: map.containsKey('timeStamp')&&map['timeStamp']!=null ? convertedTimeStamp : null,
    );
  }
}