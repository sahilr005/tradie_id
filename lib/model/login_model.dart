class LoginModel {
  String? status;
  String? message;
  Data? data;

  LoginModel({this.status, this.message, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
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
        result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessToken'] = this.accessToken;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['status'] = this.status;
    data['phone_no'] = this.phoneNo;
    data['role'] = this.role;
    data['license'] = this.license;
    data['card_no'] = this.cardNo;
    data['expiry_date'] = this.expiryDate;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['description'] = this.description;
    return data;
  }
}
