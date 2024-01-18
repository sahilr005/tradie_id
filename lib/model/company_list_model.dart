class CompanyListModel {
  List<RList>? cardList;

  CompanyListModel({required this.cardList});

  CompanyListModel.fromJson(Map<String, dynamic> json) {
    cardList = (json['cardList'] as List<dynamic>)
        .map((cardJson) => RList.fromJson(cardJson))
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'cardList': cardList!.map((card) => card.toJson()).toList(),
    };
  }
}

class Result {
  List<RList>? list;

  Result({this.list});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <RList>[];
      json['list'].forEach((v) {
        list!.add(RList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (list != null) {
      data['list'] = list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RList {
  int? employeId;
  String? employeName;
  String? employeEmail;
  String? employeRole;
  String? cardNo;
  String? license;
  String? profileImage;
  dynamic companyId;
  int? id;
  String? name;
  String? lastname;
  String? email;
  String? role;
  String? phoneNo;
  String? password;
  String? companyLogo;
  int? status;
  String? city;
  String? state;
  String? country;
  String? expiryDate;
  dynamic pinCode;
  dynamic description;

  RList(
      {this.employeId,
      this.employeName,
      this.employeEmail,
      this.employeRole,
      this.cardNo,
      this.expiryDate,
      this.license,
      this.profileImage,
      this.companyId,
      this.id,
      this.name,
      this.lastname,
      this.email,
      this.role,
      this.phoneNo,
      this.password,
      this.companyLogo,
      this.status,
      this.city,
      this.state,
      this.country,
      this.pinCode,
      this.description});

  RList.fromJson(Map json) {
    employeId = json['employeId'];
    employeName = json['employeName'];
    employeEmail = json['employeEmail'];
    employeRole = json['employeRole'];
    expiryDate = json['expiry_date'];
    cardNo = json['card_no'];

    license = json['license'];
    profileImage = json['profileImage'];
    companyId = json['company_id'];
    id = json['id'];
    name = json['name'];
    lastname = json['lastname'];
    email = json['email'];
    role = json['role'];
    phoneNo = json['phone_no'];
    password = json['password'];
    companyLogo = json['companyLogo'];
    status = json['status'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    pinCode = json['pin_code'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employeId'] = employeId;
    data['employeName'] = employeName;
    data['employeEmail'] = employeEmail;
    data['employeRole'] = employeRole;
    data['card_no'] = cardNo;

    data['license'] = license;
    data['profileImage'] = profileImage;
    data['company_id'] = companyId;
    data['id'] = id;
    data['name'] = name;
    data['lastname'] = lastname;
    data['email'] = email;
    data['role'] = role;
    data['phone_no'] = phoneNo;
    data['password'] = password;
    data['companyLogo'] = companyLogo;
    data['status'] = status;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['pin_code'] = pinCode;
    data['description'] = description;
    return data;
  }
}
