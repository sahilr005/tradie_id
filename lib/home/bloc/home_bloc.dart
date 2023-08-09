import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tradie_id/model/home_model.dart';
import 'package:tradie_id/repo/post_repo.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeData>(homeData);
  }

  FutureOr<void> homeData(HomeData event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      HomeModel homeModel = await ApiCall.homeData();
      if (homeModel.status != "error") {
        emit(HomeSuccess());
      } else {
        emit(const HomeError(error: "Something want wrong"));
      }
    } catch (e) {
      emit(HomeError(error: e.toString()));
    }
  }
}
