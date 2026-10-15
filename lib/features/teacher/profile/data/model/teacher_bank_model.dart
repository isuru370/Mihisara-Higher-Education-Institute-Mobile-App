import 'teacher_bank_branch_model.dart';

class TeacherBankModel {
  final String? accountNumber;
  final TeacherBankBranchModel? branch;

  const TeacherBankModel({this.accountNumber, this.branch});

  factory TeacherBankModel.fromJson(Map<String, dynamic> json) {
    return TeacherBankModel(
      accountNumber: json['account_number'],
      branch: json['branch'] != null
          ? TeacherBankBranchModel.fromJson(
              json['branch'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}
