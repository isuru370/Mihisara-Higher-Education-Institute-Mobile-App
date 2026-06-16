import 'package:nexorait_education_app/features/admission/data/model/store/admission_payment_request_model.dart';

import '../../../students/data/models/create_student/create_student_response_model.dart';
import '../../data/model/admission/admission_response_model.dart';
import '../../data/model/payment/admission_payment_response_model.dart';

abstract class AdmissionRepository {
  Future<AdmissionResponseModel> fetchAdmissionData();
  Future<AdmissionPaymentResponseModel> fetchAdmissionPaymentData();
  Future<CreateStudentResponseModel> storeAdmissionPayment(
    AdmissionPaymentRequestModel request,
  );
}
