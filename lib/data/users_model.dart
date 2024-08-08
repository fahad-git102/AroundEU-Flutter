class AppUser {
  String? uid, firstName, surName, email, country, dob, phone,
      selectedCountry, userType, about, profileUrl;
  int? joinedOn;
  bool? joined, admin;
  List<String?>? deviceTokens;

  AppUser({this.uid,
    this.firstName,
    this.surName,
    this.email,
    this.country,
    this.dob,
    this.phone,
    this.selectedCountry,
    this.userType,
    this.about,
    this.profileUrl,
    this.joinedOn,
    this.joined,
    this.admin,
    this.deviceTokens});

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'firstName': this.firstName,
      'surName': this.surName,
      'email': this.email,
      'country': this.country,
      'dob': this.dob,
      'phone': this.phone,
      'selectedCountry': this.selectedCountry,
      'userType': this.userType,
      'about': this.about,
      'profileUrl': this.profileUrl,
      'joinedOn': this.joinedOn,
      'joined': this.joined,
      'admin': this.admin,
      'deviceTokens': this.deviceTokens,
    };
  }

  factory AppUser.fromMap(Map<dynamic, dynamic> map) {
    return AppUser(
      uid: map.containsKey('uid') && map['uid'] != null ? map["uid"] : null,
      firstName: map.containsKey('firstName') && map['firstName'] != null ? map["firstName"] : null,
      surName: map.containsKey('surName') && map['surName'] != null ? map["surName"] : null,
      email: map.containsKey('email') && map['email'] != null ? map["email"] : null,
      country: map.containsKey('country') && map['country'] != null ? map["country"] : null,
      dob: map.containsKey('dob') && map['dob'] != null ? map["dob"] : null,
      phone: map.containsKey('phone') && map['phone'] != null ? map["phone"] : null,
      selectedCountry: map.containsKey('selectedCountry') && map['selectedCountry'] != null ? map["selectedCountry"] : null,
      userType: map.containsKey('userType') && map['userType'] != null ? map["userType"] : null,
      about: map.containsKey('about') && map['about'] != null ? map["about"] : null,
      profileUrl: map.containsKey('profileUrl') && map['profileUrl'] != null ? map["profileUrl"] : null,
      joinedOn: map.containsKey('joinedOn') && map['joinedOn'] != null ? map["joinedOn"] as int : null,
      joined: map.containsKey('joined') && map['joined'] != null ? map["joined"] as bool : null,
      admin: map.containsKey('admin') && map['admin'] != null ? map["admin"] as bool : null,
      deviceTokens: map.containsKey('deviceTokens') && map['deviceTokens'] != null
          ? List<String?>.from(map["deviceTokens"].map((x) => x))
          : null,
    );
  }
}