class CoordinatorsContact{
  String? phone, text, id;

  CoordinatorsContact({
    this.phone,
    this.text,
    this.id
  });

  Map<String, dynamic> toMap() {
    return {
      'phone': this.phone,
      'text': this.text,
      'id': this.id
    };
  }

  factory CoordinatorsContact.fromMap(Map<String, dynamic> map) {
    return CoordinatorsContact(
      phone: map.containsKey('phone')&&map['phone']!=null ? map['phone'] as String : null,
      text: map.containsKey('text')&&map['text']!=null ? map['text'] as String : null,
      id: map.containsKey('id')&&map['id']!=null ? map['id'] as String : null,
    );
  }
}