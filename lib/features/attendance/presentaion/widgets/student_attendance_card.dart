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
    return InkWell(
      onTap: () => _showStudentDetailsPopup(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Row: Index, Image, Student Info, Status Badges
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1F2937),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(
                              Icons.school,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Grade ${student.student.grade}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Icon(
                              Icons.badge,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              student.student.studentCode,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.phone,
                              size: 14,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              student.student.guardianMobile.isEmpty
                                  ? '-'
                                  : student.student.guardianMobile,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xff1F2937),
                              ),
                            ),
                          ],
                        ),
                        if (student.attendance.attendedAt != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 14,
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatTime(student.attendance.attendedAt!),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Divider
              Divider(color: Colors.grey[200], height: 1),
              const SizedBox(height: 8),
              // Bottom Badges Row
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildEnrollmentBadge(),
                  _buildAttendanceBadgeSmall(),
                  _buildPaymentBadgeSmall(),
                ],
              ),
              // Payment Details if Paid
              if (student.payment.isPaid) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue.withOpacity(0.1)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rs ${student.payment.amount}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                                fontSize: 14,
                              ),
                            ),
                            if (student.payment.paymentMonth != null)
                              Text(
                                _formatPaymentMonth(
                                  student.payment.paymentMonth!,
                                ),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (student.payment.receiptNumber != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.orange.withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.receipt_long,
                                size: 14,
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                student.payment.receiptNumber!,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.orange[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ),
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

    if (initials.isEmpty) {
      return '?';
    }

    if (initials.length >= 2) {
      return initials.substring(0, 2).toUpperCase();
    } else {
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

  Widget _buildAttendanceBadgeSmall() {
    final isPresent = student.attendance.isPresent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isPresent
            ? Colors.green.withOpacity(0.08)
            : Colors.red.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPresent
              ? Colors.green.withOpacity(0.2)
              : Colors.red.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPresent ? Icons.check_circle : Icons.cancel,
            size: 12,
            color: isPresent ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 4),
          Text(
            isPresent ? 'Present' : 'Absent',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isPresent ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentBadgeSmall() {
    final isPaid = student.payment.isPaid;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isPaid
            ? Colors.blue.withOpacity(0.08)
            : Colors.orange.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPaid
              ? Colors.blue.withOpacity(0.2)
              : Colors.orange.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPaid ? Icons.payment : Icons.money_off,
            size: 12,
            color: isPaid ? Colors.blue : Colors.orange,
          ),
          const SizedBox(width: 4),
          Text(
            isPaid ? 'Paid' : 'Unpaid',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isPaid ? Colors.blue : Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnrollmentBadge() {
    // Check if student has enrollment status field
    final isEnrolled = student.enrollmentStatus;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isEnrolled
            ? Colors.teal.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isEnrolled
              ? Colors.teal.withOpacity(0.2)
              : Colors.red.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isEnrolled ? Icons.check_circle_outline : Icons.cancel_outlined,
            size: 12,
            color: isEnrolled ? Colors.teal : Colors.red,
          ),
          const SizedBox(width: 4),
          Text(
            isEnrolled ? 'Enrolled' : 'Not Enrolled',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isEnrolled ? Colors.teal : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  void _showStudentDetailsPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (_, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Profile Header
                  Row(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [AppColors.primary, Color(0xff1D4ED8)],
                          ),
                        ),
                        child: ClipOval(
                          child: student.student.imgUrl.isNotEmpty
                              ? Image.network(
                                  student.student.imgUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      _buildPopupAvatar(),
                                )
                              : _buildPopupAvatar(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              student.student.initialName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff1F2937),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Grade ${student.student.grade} • ${student.student.studentCode}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            _buildEnrollmentBadge(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),
                  // Details
                  _buildDetailRow(
                    Icons.phone,
                    'Contact Number',
                    student.student.guardianMobile,
                  ),
                  _buildDetailRow(
                    Icons.access_time,
                    'Attendance Time',
                    student.attendance.attendedAt != null
                        ? _formatTime(student.attendance.attendedAt!)
                        : 'Not attended',
                  ),
                  _buildDetailRow(
                    Icons.credit_card,
                    'Payment Status',
                    student.payment.isPaid ? 'Paid' : 'Unpaid',
                    student.payment.isPaid ? Colors.green : Colors.orange,
                  ),
                  if (student.payment.isPaid) ...[
                    _buildDetailRow(
                      Icons.attach_money,
                      'Amount',
                      'Rs ${student.payment.amount}',
                      Colors.green,
                    ),
                    if (student.payment.paymentMonth != null)
                      _buildDetailRow(
                        Icons.calendar_today,
                        'Payment Month',
                        _formatPaymentMonth(student.payment.paymentMonth!),
                      ),
                    if (student.payment.paidAt != null)
                      _buildDetailRow(
                        Icons.check_circle,
                        'Paid Date',
                        _formatPaymentDate(student.payment.paidAt!),
                      ),
                    if (student.payment.receiptNumber != null)
                      _buildDetailRow(
                        Icons.receipt_long,
                        'Receipt Number',
                        student.payment.receiptNumber!,
                      ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPopupAvatar() {
    final initials = _getInitials();
    return Center(
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value, [
    Color? valueColor,
  ]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value.isNotEmpty ? value : 'Not available',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: valueColor ?? const Color(0xff1F2937),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(String dateTime) {
    try {
      final date = DateTime.parse(dateTime);
      final hour = date.hour;
      final minute = date.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:$minute $period';
    } catch (e) {
      return dateTime;
    }
  }

  String _formatPaymentMonth(String dateTime) {
    try {
      final date = DateTime.parse(dateTime);
      const months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];
      return '${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return dateTime;
    }
  }

  String _formatPaymentDate(String dateTime) {
    try {
      final date = DateTime.parse(dateTime);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTime;
    }
  }
}
