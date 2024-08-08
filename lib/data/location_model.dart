class LocationModel {
  String? address;
  double? latitude, longitude;

  LocationModel({
    this.address,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'address': this.address,
      'latitude': this.latitude,
      'longitude': this.longitude,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      address: map.containsKey('address')&&map['address']!=null ? map['address'] as String : null,
      latitude: map.containsKey('latitude')&&map['latitude']!=null ? map['latitude'] as double : null,
      longitude: map.containsKey('longitude')&&map['longitude']!=null ? map['longitude'] as double : null,
    );
  }
}