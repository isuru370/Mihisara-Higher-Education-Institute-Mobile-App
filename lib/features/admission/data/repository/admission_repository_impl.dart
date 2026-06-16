import 'package:nexorait_education_app/features/admission/data/model/payment/admission_payment_response_model.dart';

import '../../../students/data/models/create_student/create_student_response_model.dart';
import '../../domain/repository/admission_repository.dart';
import '../datasources/admission_remote_datasource.dart';
import '../model/admission/admission_response_model.dart';
import '../model/store/admission_payment_request_model.dart';

class AdmissionRepositoryImpl implements AdmissionRepository {
  final AdmissionRemoteDatasource remoteDatasource;
  AdmissionRepositoryImpl(this.remoteDatasource);
  @override
  Future<AdmissionResponseModel> fetchAdmissionData() {
    return remoteDatasource.fetchAdmissionData();
  }

  @override
  Future<AdmissionPaymentResponseModel> fetchAdmissionPaymentData() {
    return remoteDatasource.fetchAdmissionPaymentData();
  }

  @override
  Future<CreateStudentResponseModel> storeAdmissionPayment(
    AdmissionPaymentRequestModel request,
  ) {
    return remoteDatasource.storeAdmissionPayment(request);
  }
}
