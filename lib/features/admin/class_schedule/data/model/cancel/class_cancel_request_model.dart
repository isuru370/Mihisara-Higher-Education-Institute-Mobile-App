class ClassCancelRequestModel {
  final int scheduleId;
  final String? cancelReason;

  const ClassCancelRequestModel({
    required this.scheduleId,
    this.cancelReason,
  });

  Map<String, dynamic> toJson() {
    return {
      'schedule_id': scheduleId,
      'cancel_reason': cancelReason,
    };
  }
}