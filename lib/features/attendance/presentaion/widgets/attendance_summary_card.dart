import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/attendance_report/summary_data.dart';

class AttendanceSummaryCard extends StatelessWidget {
  final SummaryData summary;

  const AttendanceSummaryCard({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.summarize,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildSummaryItem(
                icon: Icons.people,
                label: 'Total',
                value: summary.totalStudents.toString(),
                color: Colors.blue,
              ),
              _buildSummaryItem(
                icon: Icons.check_circle,
                label: 'Present',
                value: summary.presentStudents.toString(),
                color: Colors.green,
              ),
              _buildSummaryItem(
                icon: Icons.cancel,
                label: 'Absent',
                value: summary.absentStudents.toString(),
                color: Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.grey[200]),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildSummaryItem(
                icon: Icons.payment,
                label: 'Paid',
                value: summary.paidStudents.toString(),
                color: Colors.blue,
              ),
              _buildSummaryItem(
                icon: Icons.money_off,
                label: 'Unpaid',
                value: summary.unpaidStudents.toString(),
                color: Colors.orange,
              ),
              _buildSummaryItem(
                icon: Icons.percent,
                label: 'Attendance',
                value: '${summary.attendancePercentage}%',
                color: summary.attendancePercentage >= 80
                    ? Colors.green
                    : Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}