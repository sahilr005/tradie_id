class LoginModel {
  String? status;
  String? message;
  Data? data;

  LoginModel({this.status, this.message, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? accessToken;
  List<Result>? result;

  Data({this.accessToken, this.result});

  Data.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accessToken'] = accessToken;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  int? id;
  String? name;
  String? email;
  String? password;
  int? status;
  String? phoneNo;
  String? role;
  String? license;
  String? cardNo;
  String? expiryDate;
  String? city;
  String? state;
  String? country;
  String? description;

  Result(
      {this.id,
      this.name,
      this.email,
      this.password,
      this.status,
      this.phoneNo,
      this.role,
      this.license,
      this.cardNo,
      this.expiryDate,
      this.city,
      this.state,
      this.country,
      this.description});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    status = json['status'];
    phoneNo = json['phone_no'];
    role = json['role'];
    license = json['license'];
    cardNo = json['card_no'];
    expiryDate = json['expiry_date'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['status'] = status;
    data['phone_no'] = phoneNo;
    data['role'] = role;
    data['license'] = license;
    data['card_no'] = cardNo;
    data['expiry_date'] = expiryDate;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['description'] = description;
    return data;
  }
}
