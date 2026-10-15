import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

import '../../../qr/data/model/read_tute/read_tute_enrollment_model.dart';
import '../../../qr/data/model/read_tute/read_tute_response_model.dart';
import '../../../qr/data/model/read_tute/read_tute_student_model.dart';
import '../bloc/tute/tute_bloc.dart';

class CreateTutePage extends StatelessWidget {
  final ReadTuteResponseModel readTuteResponse;

  const CreateTutePage({super.key, required this.readTuteResponse});

  @override
  Widget build(BuildContext context) {
    final data = readTuteResponse.data;
    final student = data?.student;
    final enrollments = data?.enrollments ?? [];

    return BlocListener<TuteBloc, TuteState>(
      listener: (context, state) {
        if (state is TuteCreateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(state.message),
            ),
          );
        } else if (state is TuteError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(backgroundColor: Colors.red, content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(title: const Text("Student Tutes"), centerTitle: true),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (student != null) _buildStudentCard(student),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: enrollments.length,
                itemBuilder: (context, index) {
                  final enrollment = enrollments[index];
                  return _buildEnrollmentCard(context, student!, enrollment);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudentCard(dynamic student) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: student.imgUrl != null
                ? NetworkImage(student.imgUrl!)
                : null,
            child: student.imgUrl == null
                ? const Icon(Icons.person, size: 35)
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.initialName ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text("Student ID: ${student.customId ?? '-'}"),
                Text("Guardian: ${student.guardianMobile ?? '-'}"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnrollmentCard(
    BuildContext context,
    ReadTuteStudentModel student,
    ReadTuteEnrollmentModel enrollment,
  ) {
    final isIssued = enrollment.tuteIssued;
    final isPaid = enrollment.paymentStatus == 'paid';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                enrollment.className ?? '',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                enrollment.categoryName ?? '',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: Text("Grade: ${enrollment.gradeName ?? '-'}")),
              Expanded(
                child: Text("Teacher: ${enrollment.teacherName ?? '-'}"),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Fee: Rs.${enrollment.finalFee}",
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text(
                "Payment: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              _statusChip(
                enrollment.paymentStatus ?? '',
                isPaid ? Colors.green : Colors.orange,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text(
                "Tute: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              _statusChip(
                enrollment.tuteStatus ?? '',
                isIssued ? Colors.green : Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _openIssueDialog(
                context,
                student: student,
                enrollment: enrollment,
              ),
              icon: const Icon(Icons.menu_book),
              label: Text('Issue Tute'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openIssueDialog(
    BuildContext context, {
    required ReadTuteEnrollmentModel enrollment,
    required ReadTuteStudentModel student,
  }) async {
    DateTime selectedMonth = DateTime.now();

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            final monthText = DateFormat('MMMM yyyy').format(selectedMonth);
            final issuedMonth = DateFormat('yyyy-MM-01').format(selectedMonth);
            final autoNote = generateTuteNote(
              studentName: student.initialName ?? '-',
              gradeName: enrollment.gradeName ?? '-',
              className: enrollment.className ?? '-',
              categoryName: enrollment.categoryName ?? '-',
            );

            return AlertDialog(
              title: const Text('Issue Tute'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Selected Month'),
                    subtitle: Text(monthText),
                    trailing: const Icon(Icons.calendar_month),
                    onTap: () async {
                      final picked = await showMonthYearPicker(
                        context: dialogContext,
                        initialDate: selectedMonth,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2035),
                        locale: const Locale('en'),
                      );

                      if (picked != null) {
                        setDialogState(() {
                          selectedMonth = picked;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(autoNote, style: const TextStyle(fontSize: 13)),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);

                    context.read<TuteBloc>().add(
                      CreateTuteEvent(
                        studentId: student.id,
                        studentClassEnrollmentId: enrollment.enrollmentId,
                        issuedMonth: issuedMonth,
                        isIssued: true,
                        issuedAt: DateTime.now().toIso8601String(),
                        note: autoNote,
                      ),
                    );
                  },
                  child: const Text('Issue'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _statusChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  String generateTuteNote({
    required String studentName,
    required String gradeName,
    required String className,
    required String categoryName,
  }) {
    return 'Student: $studentName | Grade: $gradeName | Class: $className | Category: $categoryName';
  }
}
