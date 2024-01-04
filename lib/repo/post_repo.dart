import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tradie_id/config/config.dart';
import 'package:tradie_id/home/ui/home_page.dart';
import 'package:tradie_id/model/login_model.dart';

class ApiCall {
  static postLoginData({required String phone}) async {
    try {
      final response = await dio.post(
        'https://backend.tradieid.net.au/api/employe/login',
        data: {'phone_no': phone},
      );
      if (response.statusCode == 200) {
        LoginModel loginModel = LoginModel.fromJson(response.data);
        box!.put('phone', phone);
        log(response.data.toString());
        Get.offAll(() => const HomePage());

        return loginModel;
      } else {
        Fluttertoast.showToast(msg: response.data["message"]);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        log(e.response!.data.toString());
        Fluttertoast.showToast(msg: e.response!.data["message"]);
      } else {
        Fluttertoast.showToast(
            msg: 'An error occurred while processing your request.');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      log(e.toString());
    }
  }
}
