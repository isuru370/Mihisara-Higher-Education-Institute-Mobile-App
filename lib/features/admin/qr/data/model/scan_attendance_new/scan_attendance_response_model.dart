import 'attendance_data_model.dart';
import 'class_selection_model.dart';

class ScanAttendanceResponseModel {
  final bool success;
  final String message;
  final AttendanceDataModel? data;

  /// True when the student has more than one class open right now and the
  /// staff member must choose which class to mark. In that case [data] is
  /// null and [selection] holds the choices.
  final bool requiresSelection;
  final ClassSelectionModel? selection;

  ScanAttendanceResponseModel({
    required this.success,
    required this.message,
    this.data,
    this.requiresSelection = false,
    this.selection,
  });

  factory ScanAttendanceResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final requiresSelection = json['requires_selection'] == true;
    final rawData = json['data'];

    return ScanAttendanceResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      requiresSelection: requiresSelection,
      data: !requiresSelection && rawData is Map<String, dynamic>
          ? AttendanceDataModel.fromJson(rawData)
          : null,
      selection: requiresSelection && rawData is Map<String, dynamic>
          ? ClassSelectionModel.fromJson(rawData)
          : null,
    );
  }
}
