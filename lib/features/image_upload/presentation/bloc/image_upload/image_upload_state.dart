part of 'image_upload_bloc.dart';

sealed class ImageUploadState extends Equatable {
  const ImageUploadState();

  @override
  List<Object?> get props => [];
}

final class ImageUploadInitial extends ImageUploadState {}

final class ImageUploadLoading extends ImageUploadState {}

final class ImageUploadSuccess extends ImageUploadState {
  final ImageUploadResponseModel response;

  const ImageUploadSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

final class ImageUploadError extends ImageUploadState {
  final String message;

  const ImageUploadError(this.message);

  @override
  List<Object?> get props => [message];
}