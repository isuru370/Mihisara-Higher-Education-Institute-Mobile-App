import '../../../../../core/constants/api_constants.dart';
import 'assignment_grade_model.dart';

class AssignmentStudentModel {
  final int id;
  final String customId;
  final String initialName;
  final String? imgUrl;
  final AssignmentGradeModel grade;

  const AssignmentStudentModel({
    required this.id,
    required this.customId,
    required this.initialName,
    required this.imgUrl,
    required this.grade,
  });

  factory AssignmentStudentModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawPath = json['img_url']?.toString();

    return AssignmentStudentModel(
      id: json['id'] ?? 0,
      customId: json['custom_id'] ?? '',
      initialName: json['initial_name'] ?? '',
      imgUrl: rawPath == null || rawPath.isEmpty
          ? null
          : rawPath.startsWith('http')
              ? rawPath
              : '${ApiConstants.baseUrl.replaceAll(RegExp(r'/$'), '')}/storage/$rawPath',
      grade: AssignmentGradeModel.fromJson(
        json['grade'] ?? {},
      ),
    );
  }
}