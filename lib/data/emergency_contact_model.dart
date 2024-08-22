class EmergencyContactModel {
  String? name, key, number;

  EmergencyContactModel({
    this.name,
    this.key,
    this.number,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'key': this.key,
      'number': this.number,
    };
  }

  factory EmergencyContactModel.fromMap(Map<String, dynamic> map) {
    return EmergencyContactModel(
      name: map.containsKey('name')&&map['name']!=null ? map['name'] as String : null,
      key: map.containsKey('key')&&map['key']!=null ? map['key'] as String : null,
      number: map.containsKey('number')&&map['number']!=null ? map['number'] as String : null,
    );
  }
}