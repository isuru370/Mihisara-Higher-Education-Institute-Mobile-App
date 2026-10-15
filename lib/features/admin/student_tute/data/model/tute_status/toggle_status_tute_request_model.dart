class ToggleStatusTuteRequestModel {
  final int tuteId;

  ToggleStatusTuteRequestModel({
    required this.tuteId,
  });

  Map<String, dynamic> toJson() {
    return {
      'tuteId': tuteId,
    };
  }
}