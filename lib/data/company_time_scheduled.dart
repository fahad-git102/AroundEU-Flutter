class CompanyTimeScheduled{
  String? id, companyId, description, morningFrom, morningTo
      , noonFrom, noonTo, uid;
  List<String>? selectedDays;

  CompanyTimeScheduled({
    this.id,
    this.companyId,
    this.description,
    this.morningFrom,
    this.morningTo,
    this.noonFrom,
    this.noonTo,
    this.uid,
    this.selectedDays,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'companyId': this.companyId,
      'description': this.description,
      'morningFrom': this.morningFrom,
      'morningTo': this.morningTo,
      'noonFrom': this.noonFrom,
      'noonTo': this.noonTo,
      'uid': this.uid,
      'selectedDays': this.selectedDays,
    };
  }

  factory CompanyTimeScheduled.fromMap(Map<String, dynamic> map) {
    return CompanyTimeScheduled(
      id: map.containsKey('id')&&map['id']!=null ? map['id'] as String : null,
      companyId: map.containsKey('companyId')&&map['companyId']!=null ? map['companyId'] as String : null,
      description: map.containsKey('description')&&map['description']!=null ? map['description'] as String : null,
      morningFrom: map.containsKey('morningFrom')&&map['morningFrom']!=null ? map['morningFrom'] as String : null,
      morningTo: map.containsKey('morningTo')&&map['morningTo']!=null ? map['morningTo'] as String : null,
      noonFrom: map.containsKey('noonFrom')&&map['noonFrom']!=null ? map['noonFrom'] as String : null,
      noonTo: map.containsKey('noonTo')&&map['noonTo']!=null ? map['noonTo'] as String : null,
      uid: map.containsKey('uid')&&map['uid']!=null ? map['uid'] as String : null,
      selectedDays: map.containsKey('selectedDays') && map['selectedDays'] != null
          ? List<String>.from(map['selectedDays'] as List)
          : null,
    );
  }
}