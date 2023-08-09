part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeData extends HomeEvent {
  final List<HomeModel> homeModel;
  const HomeData({required this.homeModel});

  @override
  List<Object?> get props => [homeModel];
}
