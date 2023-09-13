class LoginModel {
  String? status;
  String? login;
  String? message;

  LoginModel({this.status, this.login, this.message});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    login = json['login'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['login'] = this.login;
    data['message'] = this.message;
    return data;
  }
}
