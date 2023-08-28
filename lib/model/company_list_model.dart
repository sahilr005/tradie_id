class CompanyListModel {
  String? status;
  String? message;
  Result? result;

  CompanyListModel({this.status, this.message, this.result});

  CompanyListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  List<RList>? list;

  Result({this.list});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <RList>[];
      json['list'].forEach((v) {
        list!.add(new RList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
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
  String? expiryDate;
  String? license;
  String? profileImage;
  int? companyId;
  int? id;
  String? name;
  String? email;
  int? role;
  String? phoneNo;
  String? password;
  String? companyLogo;
  int? status;
  String? city;
  String? state;
  String? country;
  Null? pinCode;
  Null? description;

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
    cardNo = json['card_no'];
    expiryDate = json['expiry_date'];
    license = json['license'];
    profileImage = json['profileImage'];
    companyId = json['company_id'];
    id = json['id'];
    name = json['name'];
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeId'] = this.employeId;
    data['employeName'] = this.employeName;
    data['employeEmail'] = this.employeEmail;
    data['employeRole'] = this.employeRole;
    data['card_no'] = this.cardNo;
    data['expiry_date'] = this.expiryDate;
    data['license'] = this.license;
    data['profileImage'] = this.profileImage;
    data['company_id'] = this.companyId;
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['role'] = this.role;
    data['phone_no'] = this.phoneNo;
    data['password'] = this.password;
    data['companyLogo'] = this.companyLogo;
    data['status'] = this.status;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['pin_code'] = this.pinCode;
    data['description'] = this.description;
    return data;
  }
}
