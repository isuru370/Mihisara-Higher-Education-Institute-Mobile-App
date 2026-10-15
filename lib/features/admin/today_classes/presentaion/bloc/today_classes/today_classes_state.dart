part of 'today_classes_bloc.dart';

sealed class TodayClassesState extends Equatable {
  const TodayClassesState();

  @override
  List<Object> get props => [];
}

final class TodayClassesInitial extends TodayClassesState {}

final class TodayClassesLoading extends TodayClassesState {}

final class TodayClassesLoaded extends TodayClassesState {
  final List<TodayClassItemModel> classes;

  const TodayClassesLoaded(this.classes);

  @override
  List<Object> get props => [classes];
}

final class TodayClassesError extends TodayClassesState {
  final String message;

  const TodayClassesError(this.message);

  @override
  List<Object> get props => [message];
}