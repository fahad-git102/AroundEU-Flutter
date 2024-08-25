class CountryModel {
  String? countryName;
  String? pincode;
  String? id;

  CountryModel({
    this.countryName,
    this.pincode,
    this.id
  });

  Map<String, dynamic> toMap() {
    return {
      'countryName': this.countryName,
      'pincode': this.pincode,
      'id': this.id
    };
  }

  factory CountryModel.fromMap(Map<String, dynamic> map) {
    return CountryModel(
      countryName: map.containsKey('countryName') && map['countryName']!=null ? map['countryName'] as String : null,
      id: map.containsKey('id') && map['id']!=null ? map['id'] as String : null,
      pincode: map.containsKey('pincode') && map['pincode']!=null ? map['pincode'] as String : null,
    );
  }
}