class CountryModel {
  String? countryName;
  String? pincode;

  CountryModel({
    this.countryName,
    this.pincode,
  });

  Map<String, dynamic> toMap() {
    return {
      'countryName': this.countryName,
      'pincode': this.pincode,
    };
  }

  factory CountryModel.fromMap(Map<String, dynamic> map) {
    return CountryModel(
      countryName: map.containsKey('countryName') && map['countryName']!=null ? map['countryName'] as String : null,
      pincode: map.containsKey('pincode') && map['pincode']!=null ? map['pincode'] as String : null,
    );
  }
}