import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/teacher_profile_model.dart';
import '../../../domain/usecase/get_teacher_profile.dart';

part 'teacher_profile_event.dart';
part 'teacher_profile_state.dart';

class TeacherProfileBloc
    extends Bloc<TeacherProfileEvent, TeacherProfileState> {
  final GetTeacherProfile getTeacherProfile;
  final UpdateTeacherProfile updateTeacherProfile;
  final ChangeTeacherPassword changeTeacherPassword;

  TeacherProfileBloc({
    required this.getTeacherProfile,
    required this.updateTeacherProfile,
    required this.changeTeacherPassword,
  }) : super(TeacherProfileInitial()) {
    on<FetchTeacherProfile>(_onFetchTeacherProfile);
    on<UpdateTeacherProfile>(_onUpdateTeacherProfile);
    on<ChangeTeacherPassword>(_onChangeTeacherPassword);
  }

  Future<void> _onFetchTeacherProfile(
    FetchTeacherProfile event,
    Emitter<TeacherProfileState> emit,
  ) async {
    emit(TeacherProfileLoading());

    try {
      final profile = await getTeacherProfile();

      emit(TeacherProfileLoaded(profile: profile));
    } catch (e) {
      emit(TeacherProfileError(message: _cleanErrorMessage(e)));
    }
  }

  Future<void> _onUpdateTeacherProfile(
    UpdateTeacherProfile event,
    Emitter<TeacherProfileState> emit,
  ) async {
    TeacherProfileModel? currentProfile;

    final currentState = state;

    if (currentState is TeacherProfileLoaded) {
      currentProfile = currentState.profile;
    } else if (currentState is TeacherProfileUpdating) {
      currentProfile = currentState.profile;
    } else if (currentState is TeacherProfileUpdated) {
      currentProfile = currentState.profile;
    }

    if (currentProfile != null) {
      emit(TeacherProfileUpdating(profile: currentProfile));
    } else {
      emit(TeacherProfileLoading());
    }

    try {
      // final updatedProfile = await updateTeacherProfile(
      //   data: event.data,
      // );

      // emit(
      //   TeacherProfileUpdated(
      //     profile: updatedProfile,
      //   ),
      // );
    } catch (e) {
      emit(TeacherProfileError(message: _cleanErrorMessage(e)));
    }
  }

  Future<void> _onChangeTeacherPassword(
    ChangeTeacherPassword event,
    Emitter<TeacherProfileState> emit,
  ) async {
    TeacherProfileModel? currentProfile;

    final currentState = state;

    if (currentState is TeacherProfileLoaded) {
      currentProfile = currentState.profile;
    } else if (currentState is TeacherProfileUpdated) {
      currentProfile = currentState.profile;
    } else if (currentState is TeacherProfileUpdating) {
      currentProfile = currentState.profile;
    }

    emit(TeacherPasswordChanging(profile: currentProfile));

    try {
      // await changeTeacherPassword(
      //   currentPassword: event.currentPassword,
      //   newPassword: event.newPassword,
      //   newPasswordConfirmation:
      //       event.newPasswordConfirmation,
      // );

      emit(TeacherPasswordChanged(profile: currentProfile));
    } catch (e) {
      emit(TeacherProfileError(message: _cleanErrorMessage(e)));
    }
  }

  String _cleanErrorMessage(Object error) {
    final message = error.toString();

    if (message.startsWith('Exception: ')) {
      return message.substring('Exception: '.length);
    }

    return message;
  }
}
