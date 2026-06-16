import '../../../../../core/constants/api_constants.dart';

class StudentCustomIdModel {
  final int id;
  final String customId;
  final String fname;
  final String lname;
  final String imgUrl;
  final String gradeName;

  StudentCustomIdModel({
    required this.id,
    required this.customId,
    required this.fname,
    required this.lname,
    required this.imgUrl,
    required this.gradeName,
  });

  factory StudentCustomIdModel.fromJson(Map<String, dynamic> json) {
    return StudentCustomIdModel(
      id: json['id'],
      customId: json['custom_id'] ?? '',
      fname: json['fname'] ?? '',
      lname: json['lname'] ?? '',
      imgUrl: json['img_url'].toString().replaceFirst(
        'http://127.0.0.1:8000',
        ApiConstants.baseUrl,
      ),
      gradeName: json['grade'] != null ? json['grade']['grade_name'] ?? '' : '',
    );
  }
}
