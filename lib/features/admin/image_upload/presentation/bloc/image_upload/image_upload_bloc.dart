import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/image_upload/image_update_response_model.dart';
import '../../../data/models/image_upload/image_upload_request_model.dart';
import '../../../data/models/image_upload/image_upload_response_model.dart';
import '../../../domain/usecases/update_image_usecase.dart';
import '../../../domain/usecases/upload_image_usecase.dart';

part 'image_upload_event.dart';
part 'image_upload_state.dart';

class ImageUploadBloc extends Bloc<ImageUploadEvent, ImageUploadState> {
  final UploadImageUsecase uploadImageUsecase;
  final UpdateImageUseCase updateImageUseCase;

  ImageUploadBloc({
    required this.uploadImageUsecase,
    required this.updateImageUseCase,
  }) : super(ImageUploadInitial()) {
    on<UploadImageEvent>(_onUploadImage);
    on<UpdateImageEvent>(_onUpdateImage);
  }

  Future<void> _onUploadImage(
    UploadImageEvent event,
    Emitter<ImageUploadState> emit,
  ) async {
    emit(ImageUploadLoading());

    try {
      final result = await uploadImageUsecase(event.request);
      emit(ImageUploadSuccess(result));
    } catch (e) {
      emit(ImageUploadError(e.toString()));
    }
  }

  Future<void> _onUpdateImage(
    UpdateImageEvent event,
    Emitter<ImageUploadState> emit,
  ) async {
    emit(ImageUploadLoading());

    try {
      final result = await updateImageUseCase(event.request);
      emit(ImageUpdateSuccess(result));
    } catch (e) {
      emit(ImageUploadError(e.toString()));
    }
  }
}