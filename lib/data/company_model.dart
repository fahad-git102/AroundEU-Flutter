class CompanyModel{
  String? id, city, companyDescription, companyResponsibility, contactPerson, country
      ,email, fullLegalName, legalAddress, poastalCode, selectedCountry, taskOfStudents
      , telephone, website, pinNumber, size, piva, legalRepresentative, idLegalRepresent;

  CompanyModel({
    this.id,
    this.city,
    this.companyDescription,
    this.companyResponsibility,
    this.contactPerson,
    this.country,
    this.email,
    this.fullLegalName,
    this.legalAddress,
    this.poastalCode,
    this.selectedCountry,
    this.taskOfStudents,
    this.telephone,
    this.website,
    this.pinNumber,
    this.size,
    this.piva,
    this.legalRepresentative,
    this.idLegalRepresent
  });

  Map<String, dynamic> toMap() {
    return {
      'city': this.city,
      'id': this.id,
      'companyDescription': this.companyDescription,
      'companyResponsibility': this.companyResponsibility,
      'contactPerson': this.contactPerson,
      'country': this.country,
      'email': this.email,
      'fullLegalName': this.fullLegalName,
      'legalAddress': this.legalAddress,
      'poastalCode': this.poastalCode,
      'selectedCountry': this.selectedCountry,
      'taskOfStudents': this.taskOfStudents,
      'telephone': this.telephone,
      'website': this.website,
      'pinNumber': this.pinNumber,
      'size': this.size,
      'piva': this.piva,
      'legalRepresentative': this.legalRepresentative,
      'idLegalRepresent': this.idLegalRepresent
    };
  }

  factory CompanyModel.fromMap(Map<dynamic, dynamic> map) {
    return CompanyModel(
      city: map.containsKey('city')&&map['city']!=null ? map['city'] as String : null,
      id: map.containsKey('id')&&map['id']!=null ? map['id'] as String : null,
      companyDescription: map.containsKey('companyDescription')
          &&map['companyDescription']!=null ? map['companyDescription'] as String : null,
      companyResponsibility: map.containsKey('companyResponsibility')
          &&map['companyResponsibility']!=null ? map['companyResponsibility'] as String : null,
      contactPerson: map.containsKey('contactPerson')&&map['contactPerson']!=null
          ? map['contactPerson'] as String : null,
      country: map.containsKey('country')&&map['country']!=null ? map['country'] as String : null,
      email: map.containsKey('email')&&map['email']!=null ? map['email'] as String : null,
      fullLegalName: map.containsKey('fullLegalName')&&map['fullLegalName']!=null
          ? map['fullLegalName'] as String : null,
      legalAddress: map.containsKey('legalAddress')&&map['legalAddress']!=null
          ? map['legalAddress'] as String : null,
      poastalCode: map.containsKey('poastalCode')&&map['poastalCode']!=null
          ? map['poastalCode'] as String : null,
      selectedCountry: map.containsKey('selectedCountry')&&map['selectedCountry']!=null
          ? map['selectedCountry'] as String : null,
      taskOfStudents: map.containsKey('taskOfStudents')&&map['taskOfStudents']!=null
          ? map['taskOfStudents'] as String : null,
      telephone: map.containsKey('telephone')&&map['telephone']!=null ? map['telephone'] as String : null,
      website: map.containsKey('website')&&map['website']!=null ? map['website'] as String : null,
      pinNumber: map.containsKey('pinNumber')&&map['pinNumber']!=null ? map['pinNumber'] as String : null,
      size: map.containsKey('size')&&map['size']!=null ? map['size'] as String : null,
      piva: map.containsKey('piva')&&map['piva']!=null ? map['piva'] as String : null,
      legalRepresentative: map.containsKey('legalRepresentative')
          &&map['legalRepresentative']!=null ? map['legalRepresentative'] as String : null,
      idLegalRepresent: map.containsKey('idLegalRepresent')
          &&map['idLegalRepresent']!=null ? map['idLegalRepresent'] as String : null,
    );
  }
}