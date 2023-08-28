import 'package:bloc/bloc.dart';
import 'dart:async';
import 'package:tradie_id/config/config.dart';
import 'package:tradie_id/login/bloc/login_event.dart';
import 'package:tradie_id/login/bloc/login_state.dart';
import 'package:tradie_id/model/login_model.dart';
import 'package:tradie_id/repo/post_repo.dart';

// BLoC
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>(loginButtonPressed);
  }

  FutureOr<void> loginButtonPressed(
      LoginButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      LoginModel loginModel = await ApiCall.postLoginData(
          email: event.username, password: event.password);

      box!.put('id', loginModel.data!.result![0].id);
      box!.put('name', loginModel.data!.result![0].name);
      box!.put('phone', loginModel.data!.result![0].phoneNo);
      box!.put('email', loginModel.data!.result![0].email);
      box!.put('cardNo', loginModel.data!.result![0].cardNo);
      box!.put('city', loginModel.data!.result![0].city);
      box!.put('accessToken', loginModel.data!.accessToken);
      box!.put('role', loginModel.data!.result![0].role);
      box!.put('license', loginModel.data!.result![0].license);
      box!.put('cardNo', loginModel.data!.result![0].cardNo);
      box!.put('expiryDate', loginModel.data!.result![0].expiryDate);

      emit(LoginSuccess());
      if (loginModel.status == "error") {
        emit(LoginFailure(error: loginModel.message.toString()));
      }
    } catch (error) {
      emit(LoginFailure(error: error.toString()));
    }
  }
}
