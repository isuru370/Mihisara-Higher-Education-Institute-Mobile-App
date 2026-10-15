class ReadStudentRequestModel {
  final String customId;

  ReadStudentRequestModel({required this.customId});

  Map<String, dynamic> toQuery() {
    return {
      'custom_id': customId,
    };
  }
}
