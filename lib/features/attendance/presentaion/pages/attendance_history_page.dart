import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/attendance_history/attendance_history_request_model.dart';
import '../bloc/attendance/attendance_bloc.dart';

class AttendanceHistoryPage extends StatefulWidget {
  final int studentId;
  final int enrollmentId;

  const AttendanceHistoryPage({
    super.key,
    required this.studentId,
    required this.enrollmentId,
  });

  @override
  State<AttendanceHistoryPage> createState() => _AttendanceHistoryPageState();
}

class _AttendanceHistoryPageState extends State<AttendanceHistoryPage> {
  @override
  void initState() {
    super.initState();

    context.read<AttendanceBloc>().add(
      AttendanceHistoryRequested(
        request: AttendanceHistoryRequestModel(
          studentId: widget.studentId,
          enrollmentId: widget.enrollmentId,
        ),
      ),
    );
  }

  String _formatDate(String value) {
    try {
      return DateFormat('yyyy MMM dd').format(DateTime.parse(value));
    } catch (_) {
      return value;
    }
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return Colors.green;

      case 'absent':
        return Colors.red;

      case 'today':
        return Colors.orange;

      case 'upcoming':
        return Colors.blue;

      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return Icons.check_circle_rounded;

      case 'absent':
        return Icons.cancel_rounded;

      case 'today':
        return Icons.today_rounded;

      case 'upcoming':
        return Icons.schedule_rounded;

      default:
        return Icons.help_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,

        title: const Text(
          'Attendance History',

          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),

      body: BlocBuilder<AttendanceBloc, AttendanceState>(
        builder: (context, state) {
          // =========================
          // LOADING
          // =========================

          if (state is AttendanceHistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // =========================
          // ERROR
          // =========================

          if (state is AttendanceHistoryError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),

                child: Container(
                  padding: const EdgeInsets.all(28),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(30),

                    boxShadow: AppColors.softShadow,
                  ),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 80,
                        color: Colors.red.shade400,
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        'Unable To Load Attendance',

                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        state.message,

                        textAlign: TextAlign.center,

                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // =========================
          // SUCCESS
          // =========================

          if (state is AttendanceHistoryLoaded) {
            final response = state.response;
            final data = response.data;

            final summary = data.summary;
            final history = data.history;

            // =========================
            // EMPTY STATE
            // =========================

            if (history.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),

                  child: Container(
                    padding: const EdgeInsets.all(30),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(30),

                      boxShadow: AppColors.softShadow,
                    ),

                    child: Column(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        Icon(
                          Icons.history_toggle_off_rounded,
                          size: 90,
                          color: Colors.grey.shade400,
                        ),

                        const SizedBox(height: 18),

                        Text(
                          'No Attendance History',

                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.grey.shade800,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'Attendance records are not available yet.',

                          textAlign: TextAlign.center,

                          style: TextStyle(
                            color: Colors.grey.shade600,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return Column(
              children: [
                // =========================
                // HERO SECTION
                // =========================
                Container(
                  margin: const EdgeInsets.all(16),

                  padding: const EdgeInsets.all(22),

                  decoration: BoxDecoration(
                    gradient: AppColors.heroGradient,

                    borderRadius: BorderRadius.circular(32),

                    boxShadow: AppColors.largeShadow,
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Row(
                        children: [
                          Container(
                            width: 62,
                            height: 62,

                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.14),

                              borderRadius: BorderRadius.circular(18),
                            ),

                            child: const Icon(
                              Icons.fact_check_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                const Text(
                                  'Attendance Analytics',

                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                Text(
                                  '${summary.presentCount}/${summary.totalSchedules} Present',

                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      GridView.count(
                        crossAxisCount: 2,

                        shrinkWrap: true,

                        physics: const NeverScrollableScrollPhysics(),

                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,

                        childAspectRatio: 1.5,

                        children: [
                          _heroStatCard(
                            'Total',
                            summary.totalSchedules.toString(),
                            Icons.calendar_month_rounded,
                            Colors.white,
                          ),

                          _heroStatCard(
                            'Present',
                            summary.presentCount.toString(),
                            Icons.check_circle_rounded,
                            Colors.greenAccent,
                          ),

                          _heroStatCard(
                            'Absent',
                            summary.absentCount.toString(),
                            Icons.cancel_rounded,
                            Colors.redAccent,
                          ),

                          _heroStatCard(
                            'Upcoming',
                            summary.upcomingCount.toString(),
                            Icons.schedule_rounded,
                            Colors.orangeAccent,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // =========================
                // ATTENDANCE LIST
                // =========================
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),

                    itemCount: history.length,

                    separatorBuilder: (_, __) => const SizedBox(height: 14),

                    itemBuilder: (context, index) {
                      final item = history[index];

                      final statusColor = _statusColor(item.attendanceStatus);

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(30),

                          border: Border.all(color: AppColors.border),

                          boxShadow: AppColors.softShadow,
                        ),

                        child: Padding(
                          padding: const EdgeInsets.all(18),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              // =========================
                              // TOP ROW
                              // =========================
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Container(
                                    width: 58,
                                    height: 58,

                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(.12),

                                      borderRadius: BorderRadius.circular(18),
                                    ),

                                    child: Icon(
                                      _statusIcon(item.attendanceStatus),

                                      color: statusColor,

                                      size: 28,
                                    ),
                                  ),

                                  const SizedBox(width: 14),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,

                                      children: [
                                        Text(
                                          item.day,

                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),

                                        const SizedBox(height: 5),

                                        Text(
                                          _formatDate(item.classDate),

                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),

                                        const SizedBox(height: 8),

                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: [
                                            _badge(
                                              icon: Icons.access_time_rounded,
                                              text:
                                                  '${item.startTime} - ${item.endTime}',
                                              color: AppColors.primary,
                                            ),
                                            _badge(
                                              icon:
                                                  Icons.event_available_rounded,
                                              text: item.scheduleStatus,
                                              color: Colors.purple,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),

                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(.12),

                                      borderRadius: BorderRadius.circular(999),
                                    ),

                                    child: Text(
                                      item.attendanceStatus.toUpperCase(),

                                      style: TextStyle(
                                        color: statusColor,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // =========================
                              // DETAILS
                              // =========================
                              const SizedBox(height: 18),

                              Container(
                                width: double.infinity,

                                padding: const EdgeInsets.all(16),

                                decoration: BoxDecoration(
                                  color: const Color(0xfff8fafc),

                                  borderRadius: BorderRadius.circular(22),

                                  border: Border.all(color: AppColors.border),
                                ),

                                child: Column(
                                  children: [
                                    if (item.markMethod != null)
                                      _detailRow('Method', item.markMethod!),

                                    if (item.attendedAt != null)
                                      _detailRow('Marked At', item.attendedAt!),

                                    if (item.note != null)
                                      _detailRow('Note', item.note!),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _heroStatCard(
    String title,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.12),

        borderRadius: BorderRadius.circular(22),

        border: Border.all(color: Colors.white.withOpacity(.12)),
      ),

      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.10),

              borderRadius: BorderRadius.circular(14),
            ),

            child: Icon(icon, color: iconColor, size: 22),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Text(
                  value,

                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  title,

                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 180),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(.10),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Expanded(
            child: Text(
              title,

              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              value,

              textAlign: TextAlign.end,

              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.dark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
