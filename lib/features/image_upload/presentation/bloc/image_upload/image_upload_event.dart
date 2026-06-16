part of 'image_upload_bloc.dart';

sealed class ImageUploadEvent extends Equatable {
  const ImageUploadEvent();

  @override
  List<Object?> get props => [];
}

class UploadImageEvent extends ImageUploadEvent {
  final ImageUploadRequestModel request;

  const UploadImageEvent(this.request);

  @override
  List<Object?> get props => [request];
}