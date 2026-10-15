part of 'today_classes_bloc.dart';

sealed class TodayClassesEvent extends Equatable {
  const TodayClassesEvent();

  @override
  List<Object> get props => [];
}

final class FetchTodayClassesEvent extends TodayClassesEvent {}