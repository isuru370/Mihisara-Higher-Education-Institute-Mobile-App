import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexorait_education_app/features/qr/presentation/bloc/read_payment/read_payment_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../qr/data/model/scan_attendance_new/scan_attendance_response_model.dart';
import '../../../qr/data/model/scan_attendance_new/schedule_model.dart';
import '../../../qr/data/model/scan_attendance_new/student_model.dart';
import '../../../student_classes/presentaion/bloc/class_room/class_room_bloc.dart';
import '../../data/models/atendance_request_model.dart';
import '../bloc/attendance/attendance_bloc.dart';

class AttendancePageNew extends StatefulWidget {
  final String? markMethod;
  final ScanAttendanceResponseModel attendanceData;

  const AttendancePageNew({
    super.key,
    this.markMethod,
    required this.attendanceData,
  });

  @override
  State<AttendancePageNew> createState() => _AttendancePageNewState();
}

class _AttendancePageNewState extends State<AttendancePageNew> {
  bool markTute = false;
  bool markPayment = false;
  bool isMarkingAttendance = false;

  @override
  Widget build(BuildContext context) {
    final student = widget.attendanceData.data!.student;
    final classSchedule = widget.attendanceData.data!.schedule;
    final enrollment = widget.attendanceData.data!.enrollment;
    final studentClass = widget.attendanceData.data!.schedule.studentClass;
    final attendance = widget.attendanceData.data!.attendance;
    final lastPayment = widget.attendanceData.data!.lastPayment;
    final tute = widget.attendanceData.data!.tute;

    final hasImage = student.imgUrl.isNotEmpty;
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
                  ReadPaymentRequested(student.studentCode),
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
                  classSchedule: classSchedule,
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
                                '${attendance.presentCount}/${attendance.totalCount}',
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

                _sectionCard(
                  title: 'Tute',
                  icon: Icons.menu_book_rounded,
                  children: [
                    if (tute.isIssued)
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
                                          classScheduleId: classSchedule.id,
                                          studentClassId: enrollment.id,
                                          classCategoryFeeId:
                                              enrollment.classCategoryFeeId,
                                          markMethod:
                                              widget.markMethod ?? 'qr_mobile',
                                          markTute: markTute,
                                          note:
                                              'Student: ${student.initialName} | Grade: ${student.grade.gradeName} | Class: ${studentClass.className} | Category: ${studentClass.category}',
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

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.orange.withOpacity(0.25)),
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

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.read<AttendanceBloc>().add(
                        MarkAttendanceRequested(
                          request: AttendanceRequestModel(
                            studentId: student.id,
                            classScheduleId: classSchedule.id,
                            studentClassId: enrollment.studentClassId,
                            classCategoryFeeId: enrollment.classCategoryFeeId,
                            markMethod: widget.markMethod ?? 'qr_mobile',
                            markTute: markTute,
                            note:
                                'Student: ${student.initialName} | Grade: ${student.grade.gradeName} | Class: ${studentClass.className} | Category: ${studentClass.category}',
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
    required StudentModel student,
    required ScheduleModel classSchedule,
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
                      'Student ID: ${student.studentCode}',
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
                          '${classSchedule.studentClass.className} • Grade ${classSchedule.studentClass.grade}',
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 220,
                    child: _chip(
                      icon: Icons.subject_rounded,
                      label:
                          'Subject: ${classSchedule.studentClass.subject} - ${classSchedule.studentClass.category}',
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 200,
                    child: _chip(
                      icon: Icons.person_rounded,
                      label: 'Teacher: ${classSchedule.studentClass.teacher}',
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
