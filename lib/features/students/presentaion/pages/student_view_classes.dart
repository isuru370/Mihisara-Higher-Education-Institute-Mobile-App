import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../bloc/student_classes/student_classes_bloc.dart';

class StudentViewClasses extends StatelessWidget {
  final int studentId;
  final String studentName;
  final String customId;

  const StudentViewClasses({
    super.key,
    required this.studentId,
    required this.studentName,
    required this.customId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentClassesBloc, StudentClassesState>(
      builder: (context, state) {
        if (state is StudentClassesLoading) {
          return Scaffold(
            backgroundColor: AppColors.background,

            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              title: const Text('Student Classes'),
            ),

            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is StudentClassesLoaded) {
          final classes = state.response.data;

          return Scaffold(
            backgroundColor: AppColors.background,

            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,

              title: const Text(
                'Student Classes',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),

            body: Column(
              children: [
                // HERO SECTION
                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(20),

                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,

                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),

                  child: Column(
                    children: [
                      Text(
                        studentName,

                        textAlign: TextAlign.center,

                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.14),

                          borderRadius: BorderRadius.circular(100),

                          border: Border.all(
                            color: Colors.white.withOpacity(.2),
                          ),
                        ),

                        child: Text(
                          customId,

                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: _topInfoCard(
                              title: 'Classes',
                              value: classes.length.toString(),
                              icon: Icons.class_rounded,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: _topInfoCard(
                              title: 'Active',
                              value: classes
                                  .where((e) => e.isActive)
                                  .length
                                  .toString(),

                              icon: Icons.verified_rounded,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // LIST
                Expanded(
                  child: classes.isEmpty
                      ? const Center(child: Text('No Classes Found'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),

                          itemCount: classes.length,

                          itemBuilder: (context, index) {
                            final item = classes[index];

                            return Container(
                              margin: const EdgeInsets.only(bottom: 18),

                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(28),
                                boxShadow: AppColors.softShadow,
                              ),

                              child: Padding(
                                padding: const EdgeInsets.all(18),

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    // TOP
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,

                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(14),

                                          decoration: BoxDecoration(
                                            color: AppColors.primary
                                                .withOpacity(.08),

                                            borderRadius: BorderRadius.circular(
                                              18,
                                            ),
                                          ),

                                          child: const Icon(
                                            Icons.menu_book_rounded,
                                            color: AppColors.primary,
                                          ),
                                        ),

                                        const SizedBox(width: 14),

                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,

                                            children: [
                                              Text(
                                                item.className,

                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),

                                              const SizedBox(height: 6),

                                              Text(
                                                '${item.gradeName} • ${item.teacherName}',

                                                style: TextStyle(
                                                  color: Colors.grey.shade700,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),

                                              const SizedBox(height: 4),

                                              Text(
                                                item.categoryName,

                                                style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 18),

                                    // STATUS
                                    Wrap(
                                      spacing: 10,
                                      runSpacing: 10,

                                      children: [
                                        _statusChip(
                                          text: item.isActive
                                              ? 'Active'
                                              : 'Inactive',

                                          color: item.isActive
                                              ? AppColors.success
                                              : AppColors.danger,
                                        ),

                                        _statusChip(
                                          text: item.isFreeCard
                                              ? 'Free Card'
                                              : 'Paid',

                                          color: item.isFreeCard
                                              ? AppColors.warning
                                              : AppColors.primary,
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 18),

                                    // PAYMENT DETAILS
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _paymentCard(
                                            title: 'Class Fee',
                                            value:
                                                'LKR ${item.defultFee.toStringAsFixed(2)}',

                                            color: AppColors.primary,
                                          ),
                                        ),

                                        const SizedBox(width: 12),

                                        Expanded(
                                          child: _paymentCard(
                                            title: 'Paid Amount',
                                            value:
                                                'LKR ${item.finalFee.toStringAsFixed(2)}',

                                            color: AppColors.success,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 16),

                                    Text(
                                      'Registered Date : ${item.registeredDate != null ? item.registeredDate!.toIso8601String().split("T").first : "-"}',

                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),

                                    const SizedBox(height: 18),

                                    // ACTION BUTTONS
                                    Row(
                                      children: [
                                        // PAYMENT
                                        if (!item.isFreeCard) ...[
                                          Expanded(
                                            child: _actionButton(
                                              color: AppColors.primary,
                                              icon: Icons.payment_rounded,
                                              label: 'Payment',

                                              onTap: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  '/payment-history',

                                                  arguments: {
                                                    'student_id': studentId,
                                                    'enrollment_id':
                                                        item.enrollmentId,
                                                  },
                                                );
                                              },
                                            ),
                                          ),

                                          const SizedBox(width: 10),
                                        ],

                                        // ATTENDANCE
                                        Expanded(
                                          child: _actionButton(
                                            color: AppColors.success,
                                            icon: Icons.check_circle_rounded,
                                            label: 'Attendance',

                                            onTap: () {
                                              Navigator.pushNamed(
                                                context,
                                                '/attendance-history',

                                                arguments: {
                                                  'student_id': studentId,
                                                  'enrollment_id':
                                                      item.enrollmentId,
                                                },
                                              );
                                            },
                                          ),
                                        ),

                                        const SizedBox(width: 10),

                                        // TUTE
                                        Expanded(
                                          child: _actionButton(
                                            color: AppColors.warning,
                                            icon: Icons.menu_book_rounded,
                                            label: 'Tute',

                                            onTap: () {
                                              Navigator.pushNamed(
                                                context,
                                                '/tute',

                                                arguments: {
                                                  'student_id': studentId,
                                                  'enrollment_id':
                                                      item.enrollmentId,
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,

          appBar: AppBar(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            title: const Text('Student Classes'),
          ),

          body: const Center(child: Text('No Classes Found')),
        );
      },
    );
  }

  Widget _topInfoCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.12),

        borderRadius: BorderRadius.circular(22),

        border: Border.all(color: Colors.white.withOpacity(.18)),
      ),

      child: Column(
        children: [
          Icon(icon, color: Colors.white),

          const SizedBox(height: 8),

          Text(
            value,

            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,

            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip({required String text, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),

      decoration: BoxDecoration(
        color: color.withOpacity(.10),
        borderRadius: BorderRadius.circular(100),
      ),

      child: Text(
        text,

        style: TextStyle(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _paymentCard({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: color.withOpacity(.08),
        borderRadius: BorderRadius.circular(22),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            title,

            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            value,

            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required Color color,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 48,

      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: color,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),

        onPressed: onTap,

        icon: Icon(icon, size: 18, color: Colors.white),

        label: Text(
          label,

          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
