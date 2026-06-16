part of 'class_category_bloc.dart';

sealed class ClassCategoryState extends Equatable {
  const ClassCategoryState();

  @override
  List<Object?> get props => [];
}

final class ClassCategoryInitial extends ClassCategoryState {}

final class ClassCategoryLoading extends ClassCategoryState {}

final class ClassCategoryLoaded extends ClassCategoryState {
  final ClassCategoryResponseModel response;

  const ClassCategoryLoaded(this.response);

  @override
  List<Object?> get props => [response];
}

final class ClassCategoryError extends ClassCategoryState {
  final String message;

  const ClassCategoryError({required this.message});

  @override
  List<Object?> get props => [message];
}
