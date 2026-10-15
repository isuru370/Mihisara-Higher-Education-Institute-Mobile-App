import 'teacher_address_model.dart';
import 'teacher_bank_model.dart';

class TeacherProfileModel {
  final int id;
  final String? customId;
  final String? fullName;
  final String? initials;
  final String? email;
  final String? mobile;
  final String? nic;
  final String? birthday;
  final String? gender;
  final TeacherAddressModel? address;
  final String? graduationDetails;
  final String? experience;
  final TeacherBankModel? bank;
  final bool isActive;

  const TeacherProfileModel({
    required this.id,
    this.customId,
    this.fullName,
    this.initials,
    this.email,
    this.mobile,
    this.nic,
    this.birthday,
    this.gender,
    this.address,
    this.graduationDetails,
    this.experience,
    this.bank,
    required this.isActive,
  });

  factory TeacherProfileModel.fromJson(Map<String, dynamic> json) {
    return TeacherProfileModel(
      id: json['id'] ?? 0,
      customId: json['custom_id'],
      fullName: json['full_name'],
      initials: json['initials'],
      email: json['email'],
      mobile: json['mobile'],
      nic: json['nic'],
      birthday: json['birthday'],
      gender: json['gender'],
      address: json['address'] != null
          ? TeacherAddressModel.fromJson(
              json['address'] as Map<String, dynamic>,
            )
          : null,
      graduationDetails: json['graduation_details'],
      experience: json['experience'],
      bank: json['bank'] != null
          ? TeacherBankModel.fromJson(
              json['bank'] as Map<String, dynamic>,
            )
          : null,
      isActive: json['is_active'] ?? false,
    );
  }
}