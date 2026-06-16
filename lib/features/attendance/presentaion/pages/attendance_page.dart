import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexorait_education_app/features/qr/presentation/bloc/read_payment/read_payment_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../qr/data/model/read_attendance/read_attendance_data_model.dart';
import '../../../student_classes/data/models/store_student_class_enrollment/create_student_class_enrollment_model.dart';
import '../../../student_classes/data/models/store_student_class_enrollment/create_student_request_class_model.dart';
import '../../../student_classes/presentaion/bloc/class_room/class_room_bloc.dart';
import '../../data/models/atendance_request_model.dart';
import '../bloc/attendance/attendance_bloc.dart';

class AttendancePage extends StatefulWidget {
  final int classScheduleId;
  final String? markMethod;
  final ReadAttendanceDataModel attendanceData;

  const AttendancePage({
    super.key,
    required this.classScheduleId,
    this.markMethod,
    required this.attendanceData,
  });

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  bool markTute = false;
  bool markPayment = false;
  bool isMarkingAttendance = false;

  @override
  Widget build(BuildContext context) {
    final student = widget.attendanceData.student;
    final enrollment = widget.attendanceData.enrollment;
    final attendance = widget.attendanceData.attendance;
    final lastPayment = widget.attendanceData.lastPayment;
    final tute = widget.attendanceData.tute;

    final hasImage = student.imgUrl != null && student.imgUrl!.isNotEmpty;
    final currentMonth = _currentYearMonth();
    final isCurrentMonthPaid = _isPaidForCurrentMonth(
      lastPayment?.paymentMonth,
    );
    final paymentMonthLabel = _paymentMonthLabel(lastPayment?.paymentMonth);

    return MultiBlocListener(
      listeners: [
        BlocListener<AttendanceBloc, AttendanceState>(
          listener: (context, state) {
            if (state is AttendanceSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );

              if (markPayment) {
                context.read<ReadPaymentBloc>().add(
                  ReadPaymentRequested(student.customId),
                );

                // Attendance page close karanawa
                Navigator.pop(context, true);
              } else {
                Navigator.pop(context, true);
              }
            } else if (state is AttendanceError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),

        BlocListener<ClassRoomBloc, ClassRoomState>(
          listener: (context, state) {
            if (state is ClassRoomCreateSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Class enrolled successfully'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            } else if (state is ClassRoomError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            'Attendance Details',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _studentHeader(
                  student: student,
                  enrollment: enrollment,
                  hasImage: hasImage,
                ),
                const SizedBox(height: 8),

                SizedBox(
                  height: 140,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 180,
                          child: _summaryCard(
                            title: 'Payment Status',
                            value: isCurrentMonthPaid ? 'PAID' : 'UNPAID',
                            icon: isCurrentMonthPaid
                                ? Icons.check_circle_rounded
                                : Icons.cancel_rounded,
                            color: isCurrentMonthPaid
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 180,
                          child: _summaryCard(
                            title: 'Payment Month',
                            value: paymentMonthLabel,
                            icon: Icons.calendar_month_rounded,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 180,
                          child: _summaryCard(
                            title: 'Amount',
                            value: lastPayment != null
                                ? 'Rs. ${lastPayment.amount}'
                                : 'Rs. 0.00',
                            icon: Icons.attach_money_rounded,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 180,
                          child: _summaryCard(
                            title: 'Attendance',
                            value:
                                '${attendance.attendedClasses}/${attendance.totalClasses}',
                            icon: Icons.fact_check_rounded,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 180,
                          child: _summaryCard(
                            title: 'Current Month',
                            value: currentMonth,
                            icon: Icons.event_available_rounded,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                if (enrollment.enrollmentId != null)
                  _sectionCard(
                    title: 'Tute',
                    icon: Icons.menu_book_rounded,
                    children: [
                      if (tute != null && tute.isIssued)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: Colors.blue.withOpacity(0.18),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.verified_rounded,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Tute already issued for ${tute.month}',
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Row(
                          children: [
                            Switch(
                              value: markTute,
                              onChanged: (value) {
                                setState(() {
                                  markTute = value;
                                });
                              },
                              activeThumbColor: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Mark Tute',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),

                _sectionCard(
                  title: 'Payment',
                  icon: Icons.payments_rounded,
                  children: [
                    Row(
                      children: [
                        Switch(
                          value: markPayment,
                          onChanged: isMarkingAttendance
                              ? null
                              : (value) {
                                  setState(() {
                                    markPayment = value;
                                  });

                                  if (value) {
                                    setState(() {
                                      isMarkingAttendance = true;
                                    });

                                    context.read<AttendanceBloc>().add(
                                      MarkAttendanceRequested(
                                        request: AttendanceRequestModel(
                                          studentId: student.id,
                                          classScheduleId:
                                              widget.classScheduleId,
                                          studentClassId:
                                              enrollment.studentClassId,
                                          classCategoryFeeId:
                                              enrollment.classCategoryFeeId,
                                          markMethod:
                                              widget.markMethod ?? 'qr_mobile',
                                          markTute: markTute,
                                          note:
                                              'Student: ${student.initialName} | Grade: ${enrollment.grade} | Class: ${enrollment.className} | Category: ${enrollment.categoryName}',
                                        ),
                                      ),
                                    );
                                  }
                                },
                          activeThumbColor: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Open Payment Details After Mark',
                            style: TextStyle(fontWeight: FontWeight.w600),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                if (enrollment.isEnrolled == false)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Colors.orange.withOpacity(0.25),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.orange.shade700,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'This student is not enrolled in this class. To collect payments for this class, the student must first be enrolled.',
                            style: TextStyle(
                              color: Colors.orange.shade900,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                if (enrollment.isEnrolled == false)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showAddClassDialog(
                          context,
                          studentId: student.id,
                          studentClassId: enrollment.studentClassId,
                          classCategoryFeeId: enrollment.classCategoryFeeId,
                          category: enrollment.categoryName,
                          className: enrollment.className,
                          grade: enrollment.grade,
                          studentName: student.initialName,
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add Class'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.read<AttendanceBloc>().add(
                        MarkAttendanceRequested(
                          request: AttendanceRequestModel(
                            studentId: student.id,
                            classScheduleId: widget.classScheduleId,
                            studentClassId: enrollment.studentClassId,
                            classCategoryFeeId: enrollment.classCategoryFeeId,
                            markMethod: widget.markMethod ?? 'qr_mobile',
                            markTute: markTute,
                            note:
                                'Student: ${student.initialName} | Grade: ${enrollment.grade} | Class: ${enrollment.className} | Category: ${enrollment.categoryName}',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.check_circle_rounded),
                    label: const Text('Mark Attendance'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _studentHeader({
    required dynamic student,
    required dynamic enrollment,
    required bool hasImage,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(30),
        boxShadow: AppColors.largeShadow,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: Colors.white,
                backgroundImage: hasImage
                    ? NetworkImage(student.imgUrl!)
                    : null,
                child: !hasImage
                    ? const Icon(
                        Icons.person_rounded,
                        color: AppColors.primary,
                        size: 34,
                      )
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.initialName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Student ID: ${student.customId}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Guardian: ${student.guardianMobile}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 45,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(
                    width: 260,
                    child: _chip(
                      icon: Icons.class_rounded,
                      label:
                          '${enrollment.className} • Grade ${enrollment.grade}',
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 220,
                    child: _chip(
                      icon: Icons.subject_rounded,
                      label:
                          'Subject: ${enrollment.subject} - ${enrollment.categoryName}',
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 200,
                    child: _chip(
                      icon: Icons.person_rounded,
                      label: 'Teacher: ${enrollment.teacher}',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.softShadow,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: AppColors.softShadow,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.dark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  void _showAddClassDialog(
    BuildContext context, {
    required int studentId,
    required int studentClassId,
    required int classCategoryFeeId,
    required String studentName,
    required String grade,
    required String className,
    required String category,
  }) {
    final customFeeController = TextEditingController();
    final customFeeReasonController = TextEditingController();
    final discountPercentageController = TextEditingController();
    final discountReasonController = TextEditingController();
    final noteController = TextEditingController();

    bool isFreeCard = false;

    noteController.text =
        'Student: $studentName | Grade: $grade | Class: $className | Category: $category | Status: Enrolled from Attendance Page';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              titlePadding: EdgeInsets.zero,
              contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
              actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              title: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: const Text(
                  'Add Class',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xfff8fafc),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Free Card',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Switch(
                            value: isFreeCard,
                            activeThumbColor: AppColors.primary,
                            onChanged: (value) {
                              setState(() {
                                isFreeCard = value;

                                if (isFreeCard) {
                                  customFeeController.clear();
                                  customFeeReasonController.clear();
                                  discountPercentageController.clear();
                                  discountReasonController.clear();
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    if (!isFreeCard) ...[
                      _dialogField(
                        controller: customFeeController,
                        label: 'Custom Fee',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      _dialogField(
                        controller: customFeeReasonController,
                        label: 'Custom Fee Reason',
                      ),
                      const SizedBox(height: 12),
                      _dialogField(
                        controller: discountPercentageController,
                        label: 'Discount Percentage',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      _dialogField(
                        controller: discountReasonController,
                        label: 'Discount Reason',
                      ),
                    ],
                    const SizedBox(height: 12),
                    _dialogField(
                      controller: noteController,
                      label: 'Note',
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final enrollmentModel = CreateStudentClassEnrollmentModel(
                      studentId: studentId,
                      studentClassId: studentClassId,
                      classCategoryFeeId: classCategoryFeeId,
                      isFreeCard: isFreeCard,
                      customFee: isFreeCard
                          ? null
                          : (customFeeController.text.trim().isEmpty
                                ? null
                                : double.tryParse(
                                    customFeeController.text.trim(),
                                  )),
                      customFeeReason: isFreeCard
                          ? null
                          : customFeeReasonController.text.trim(),
                      discountPercentage: isFreeCard
                          ? null
                          : (discountPercentageController.text.trim().isEmpty
                                ? null
                                : double.tryParse(
                                    discountPercentageController.text.trim(),
                                  )),
                      discountReason: isFreeCard
                          ? null
                          : discountReasonController.text.trim(),
                      note: noteController.text.trim().isEmpty
                          ? null
                          : noteController.text.trim(),
                    );

                    context.read<ClassRoomBloc>().add(
                      CreateStudentClassEnrollmentEvent(
                        request: CreateStudentClassRequestModel(
                          classEnrollmentModel: enrollmentModel,
                        ),
                      ),
                    );

                    Navigator.pop(dialogContext);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _dialogField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    int? maxLines,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xfff8fafc),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  String _currentYearMonth() {
    final now = DateTime.now();
    final month = now.month.toString().padLeft(2, '0');
    return '${now.year}-$month';
  }

  bool _isPaidForCurrentMonth(String? paymentMonth) {
    final normalizedMonth = _normalizeYearMonth(paymentMonth);
    return normalizedMonth != null && normalizedMonth == _currentYearMonth();
  }

  String _paymentMonthLabel(String? paymentMonth) {
    final normalizedMonth = _normalizeYearMonth(paymentMonth);
    return normalizedMonth ?? 'No Payment';
  }

  String? _normalizeYearMonth(String? value) {
    if (value == null) return null;

    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;

    if (trimmed.length >= 7) {
      return trimmed.substring(0, 7);
    }

    return trimmed;
  }
}
