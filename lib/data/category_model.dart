class CategoryModel{
  String? category, categoryId, country, fileUrl, name;
  int? timeStamp;

  CategoryModel({
    this.category,
    this.categoryId,
    this.country,
    this.fileUrl,
    this.name,
    this.timeStamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'category': this.category,
      'categoryId': this.categoryId,
      'country': this.country,
      'fileUrl': this.fileUrl,
      'name': this.name,
      'timeStamp': this.timeStamp,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    int convertedTimeStamp = (map['timeStamp'] is double)
        ? (map['timeStamp'] as double).round()
        : map['timeStamp'] as int;
    return CategoryModel(
      category: map.containsKey('category')&&map['category']!=null ? map['category'] as String : null,
      categoryId: map.containsKey('categoryId')&&map['categoryId']!=null ? map['categoryId'] as String : null,
      country: map.containsKey('country')&&map['country']!=null ? map['country'] as String : null,
      fileUrl: map.containsKey('fileUrl')&&map['fileUrl']!=null ? map['fileUrl'] as String : null,
      name: map.containsKey('name')&&map['name']!=null ? map['name'] as String : null,
      timeStamp: map.containsKey('timeStamp')&&map['timeStamp']!=null ? convertedTimeStamp : null,
    );
  }

}