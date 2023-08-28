import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:tradie_id/config/config.dart';
import 'package:tradie_id/model/login_model.dart';

class ApiCall {
  static postLoginData(
      {required String email, required String password}) async {
    try {
      final response = await dio.post(
        'http://68.178.163.90:4500/api/employe/login',
        data: {'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
        LoginModel loginModel = LoginModel.fromJson(response.data);
        return loginModel;
      } else {
        throw response.data["message"];
      }
    } on DioException catch (e) {
      if (e.response != null) {
        log(e.response!.data.toString());
        throw e.response!.data["message"];
      } else {
        throw 'An error occurred while processing your request.';
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  static homeData({phoneNo}) async {
    try {
      final response = await dio.post(
        'http://68.178.163.90:4500/api/employe/companyList',
        data: {'phone_no': phoneNo},
      );
      print(response.data);
      if (response.statusCode == 200) {
        LoginModel loginModel = LoginModel.fromJson(response.data);
        return loginModel;
      } else {
        throw response.data["message"];
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
