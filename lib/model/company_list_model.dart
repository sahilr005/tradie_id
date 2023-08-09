class CompanyListModel {
  String? status;
  String? message;
  Result? result;

  CompanyListModel({this.status, this.message, this.result});

  CompanyListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.toJson();
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
        list!.add(RList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (list != null) {
      data['list'] = list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RList {
  int? employeId;
  String? expiryDate;
  String? license;
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
  dynamic pinCode;
  dynamic description;

  RList(
      {this.employeId,
      this.expiryDate,
      this.license,
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

  RList.fromJson(Map<dynamic, dynamic> json) {
    employeId = json['employeId'];
    expiryDate = json['expiry_date'];
    license = json['license'];
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employeId'] = employeId;
    data['expiry_date'] = expiryDate;
    data['license'] = license;
    data['company_id'] = companyId;
    data['id'] = id;
    data['name'] = name;
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
