import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/attendance_report/student_data.dart';

class StudentAttendanceCard extends StatelessWidget {
  final StudentData student;
  final int index;

  const StudentAttendanceCard({
    super.key,
    required this.student,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Index / Number
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Profile Image or Avatar
            _buildProfileImage(),
            const SizedBox(width: 12),
            // Student Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.student.initialName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff1F2937),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Grade ${student.student.grade}',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          student.student.studentCode,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Status Badges
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildAttendanceBadge(),
                const SizedBox(height: 4),
                _buildPaymentBadge(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    final hasImage = student.student.imgUrl.isNotEmpty;
    final initials = _getInitials();

    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, Color(0xff1D4ED8)],
        ),
      ),
      child: hasImage
          ? ClipOval(
              child: Image.network(
                student.student.imgUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return _buildInitialsAvatar(initials);
                },
                errorBuilder: (context, error, stackTrace) {
                  return _buildInitialsAvatar(initials);
                },
              ),
            )
          : _buildInitialsAvatar(initials),
    );
  }

  String _getInitials() {
    final nameParts = student.student.initialName.trim().split(' ');
    String initials = '';

    for (var part in nameParts) {
      if (part.isNotEmpty) {
        initials += part[0];
      }
    }

    // If no initials found, use '?'
    if (initials.isEmpty) {
      return '?';
    }

    // Get first 2 characters safely
    if (initials.length >= 2) {
      return initials.substring(0, 2).toUpperCase();
    } else {
      // If only 1 character, return it
      return initials.toUpperCase();
    }
  }

  Widget _buildInitialsAvatar(String initials) {
    return Center(
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAttendanceBadge() {
    final isPresent = student.attendance.isPresent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isPresent
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPresent
              ? Colors.green.withOpacity(0.3)
              : Colors.red.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPresent ? Icons.check_circle : Icons.cancel,
            size: 14,
            color: isPresent ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 4),
          Text(
            isPresent ? 'Present' : 'Absent',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isPresent ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentBadge() {
    final isPaid = student.payment.isPaid;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isPaid
            ? Colors.blue.withOpacity(0.1)
            : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPaid
              ? Colors.blue.withOpacity(0.3)
              : Colors.orange.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPaid ? Icons.payment : Icons.money_off,
            size: 14,
            color: isPaid ? Colors.blue : Colors.orange,
          ),
          const SizedBox(width: 4),
          Text(
            isPaid ? 'Paid' : 'Unpaid',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isPaid ? Colors.blue : Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}
