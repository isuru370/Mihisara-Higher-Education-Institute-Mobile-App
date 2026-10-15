import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/daily_attendance_details_request_model.dart';
import '../bloc/daily_attendance_details/daily_attendance_details_bloc.dart';

class TodayAttendancePage extends StatefulWidget {
  final String token;
  final int classId;
  final int attendanceId;
  final int classCategory;

  const TodayAttendancePage({
    super.key,
    required this.token,
    required this.classId,
    required this.attendanceId,
    required this.classCategory,
  });

  @override
  State<TodayAttendancePage> createState() => _TodayAttendancePageState();
}

class _TodayAttendancePageState extends State<TodayAttendancePage> {
  @override
  void initState() {
    super.initState();

    context.read<DailyAttendanceDetailsBloc>().add(
      LoadDailyAttendanceDetailsEvent(
        token: widget.token,
        request: DailyAttendanceDetailsRequestModel(
          classId: widget.classId,
          attendanceId: widget.attendanceId,
          classCategoryStudentClassId: widget.classCategory,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Today Attendance")),
      body:
          BlocBuilder<DailyAttendanceDetailsBloc, DailyAttendanceDetailsState>(
            builder: (context, state) {
              // 🔵 Loading
              if (state is DailyAttendanceDetailsLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              // 🔴 Error
              if (state is DailyAttendanceDetailsError) {
                return Center(child: Text(state.message));
              }

              // 🟢 Loaded
              if (state is DailyAttendanceDetailsLoaded) {
                final data = state.response.data;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Category Header
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).primaryColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          data.matchedGroup.categoryName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// Summary Card
                      _buildSummaryCard(data.summary),

                      const SizedBox(height: 24),

                      const Text(
                        "Students",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      ...data.attendanceList.map(
                        (student) => _buildStudentCard(student),
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox();
            },
          ),
    );
  }

  Widget _buildStudentCard(student) {
    final isPresent = student.isPresent;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            /// Status Circle
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isPresent
                    ? Colors.green.withValues(alpha: 0.15)
                    : Colors.red.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPresent ? Icons.check : Icons.close,
                color: isPresent ? Colors.green : Colors.red,
              ),
            ),

            const SizedBox(width: 16),

            /// Student Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.lname,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text("Student ID: ${student.customId}"),
                  Text("Guardian: ${student.guardianMobile}"),
                ],
              ),
            ),

            /// Status Text
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isPresent
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isPresent ? "Present" : "Absent",
                style: TextStyle(
                  color: isPresent ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =============================
  // Summary Card
  // =============================
  Widget _buildSummaryCard(summary) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Date: ${summary.date}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 20),

            _buildSummaryItem(
              "Total Students",
              summary.totalStudents.toString(),
            ),
            const SizedBox(height: 12),

            _buildSummaryItem(
              "Present",
              summary.present.toString(),
              color: Colors.green,
            ),

            const SizedBox(height: 12),

            _buildSummaryItem(
              "Absent",
              summary.absent.toString(),
              color: Colors.red,
            ),

            const SizedBox(height: 20),

            LinearProgressIndicator(
              value: summary.attendancePercentage / 100,
              borderRadius: BorderRadius.circular(8),
              minHeight: 8,
            ),

            const SizedBox(height: 8),

            Text(
              "Attendance: ${summary.attendancePercentage}%",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}
