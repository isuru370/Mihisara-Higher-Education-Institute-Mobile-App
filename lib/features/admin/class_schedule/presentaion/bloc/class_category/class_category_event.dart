part of 'class_category_bloc.dart';

sealed class ClassCategoryEvent extends Equatable {
  const ClassCategoryEvent();

  @override
  List<Object?> get props => [];
}

class FetchClassCategoryEvent
    extends ClassCategoryEvent {
  final ClassCategoryRequestModel request;

  const FetchClassCategoryEvent(
    this.request,
  );

  @override
  List<Object?> get props => [request];
}