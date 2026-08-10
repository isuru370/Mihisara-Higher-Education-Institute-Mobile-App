import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../student_classes/presentaion/bloc/class_room/class_room_bloc.dart';
import '../../data/models/attendance_report/attendance_report_response_model.dart';
import '../../services/pdf_service.dart';
import '../bloc/attendance/attendance_bloc.dart';
import '../widgets/attendance_summary_card.dart';
import '../widgets/student_attendance_card.dart';

class AttendanceReportPage extends StatefulWidget {
  final int scheduleId;

  const AttendanceReportPage({super.key, required this.scheduleId});

  @override
  State<AttendanceReportPage> createState() => _AttendanceReportPageState();
}

class _AttendanceReportPageState extends State<AttendanceReportPage> {
  AttendanceReportResponseModel? _reportData;

  @override
  void initState() {
    super.initState();
    _fetchAttendanceReport();
  }

  void _fetchAttendanceReport() {
    context.read<AttendanceBloc>().add(
      AttendanceReportRequested(scheduleId: widget.scheduleId),
    );
  }

  void _sharePdf() async {
    if (_reportData == null) return;

    try {
      await PdfService.generateAndSharePdf(_reportData!);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text(
          'Attendance Report',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: _fetchAttendanceReport,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
          IconButton(
            onPressed: _sharePdf,
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Share PDF',
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          // ✅ Listen for ClassRoomBloc deactivation states
          BlocListener<ClassRoomBloc, ClassRoomState>(
            listenWhen: (previous, current) {
              return current is ClassRoomDeactivateLoading ||
                  current is ClassRoomDeactivateSuccess ||
                  current is ClassRoomDeactivateError;
            },
            listener: (context, state) {
              if (state is ClassRoomDeactivateLoading) {
                // Optional: Show loading indicator
              }

              if (state is ClassRoomDeactivateSuccess) {
                // ✅ Close any open bottom sheets
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }

                // ✅ Close any open dialogs
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }

                // ✅ Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.white),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            state.response.message.isNotEmpty
                                ? state.response.message
                                : 'Student removed from class successfully!',
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    duration: const Duration(seconds: 3),
                  ),
                );

                // ✅ Refresh the attendance report
                _fetchAttendanceReport();
              }

              if (state is ClassRoomDeactivateError) {
                // ✅ Show error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.white),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            state.message.isNotEmpty
                                ? state.message
                                : 'Failed to remove student from class',
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            },
          ),

          // ================================
          // ATTENDANCE BLOC
          // ================================
          BlocListener<AttendanceBloc, AttendanceState>(
            listenWhen: (previous, current) {
              return current is AttendanceDeleteLoading ||
                  current is AttendanceDeleteSuccess ||
                  current is AttendanceDeleteError;
            },
            listener: (context, state) {
              if (state is AttendanceDeleteSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.white),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            state.response.message.isNotEmpty
                                ? state.response.message
                                : 'Attendance deleted successfully!',
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    duration: const Duration(seconds: 3),
                  ),
                );

                // Refresh report
                _fetchAttendanceReport();
              }

              if (state is AttendanceDeleteError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.white),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            state.message.isNotEmpty
                                ? state.message
                                : 'Failed to delete attendance.',
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<AttendanceBloc, AttendanceState>(
          builder: (context, state) {
            if (state is AttendanceReportLoading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Loading attendance report...',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            if (state is AttendanceReportError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text(
                      'Error Loading Report',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        state.message,
                        style: TextStyle(color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _fetchAttendanceReport,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state is AttendanceReportLoaded) {
              _reportData = state.response;
              return _buildContent(state.response);
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildContent(AttendanceReportResponseModel data) {
    final presentStudents = data.data.students
        .where((s) => s.attendance.isPresent)
        .toList();

    final absentStudents = data.data.students
        .where((s) => !s.attendance.isPresent)
        .toList();

    presentStudents.sort((a, b) {
      if (a.payment.isPaid == b.payment.isPaid) return 0;
      return a.payment.isPaid ? -1 : 1;
    });

    absentStudents.sort((a, b) {
      if (a.payment.isPaid == b.payment.isPaid) return 0;
      return a.payment.isPaid ? -1 : 1;
    });

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildHeaderSection(data)),
        SliverToBoxAdapter(
          child: AttendanceSummaryCard(summary: data.data.summary),
        ),
        if (presentStudents.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: _buildSectionTitle(
              'Present Students',
              presentStudents.length,
              Colors.green,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return StudentAttendanceCard(
                key: ValueKey(presentStudents[index].student.id),
                student: presentStudents[index],
                index: index,
              );
            }, childCount: presentStudents.length),
          ),
        ],
        if (absentStudents.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: _buildSectionTitle(
              'Absent Students',
              absentStudents.length,
              Colors.red,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return StudentAttendanceCard(
                key: ValueKey(absentStudents[index].student.id),
                student: absentStudents[index],
                index: index,
              );
            }, childCount: absentStudents.length),
          ),
        ],
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }

  Widget _buildSectionTitle(String title, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Row(
        children: [
          Icon(Icons.people, color: color),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$count',
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(AttendanceReportResponseModel data) {
    final schedule = data.data.schedule;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, Color(0xff1D4ED8)],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            schedule.studentClass.className,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.category,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      schedule
                                          .classCategoryFee
                                          .category
                                          .categoryName,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(
                                    schedule.status,
                                  ).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _getStatusColor(
                                      schedule.status,
                                    ).withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _getStatusIcon(schedule.status),
                                      size: 12,
                                      color: _getStatusColor(schedule.status),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      schedule.status.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: _getStatusColor(schedule.status),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 11,
                                color: Colors.white70,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${_formatTime(schedule.startTime)} - ${_formatTime(schedule.endTime)}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Icon(
                                Icons.calendar_today,
                                size: 11,
                                color: Colors.white70,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatDate(schedule.classDate),
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.people,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Student attendance summary',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'ongoing':
        return Colors.orange;
      case 'upcoming':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons.check_circle;
      case 'ongoing':
        return Icons.play_circle;
      case 'upcoming':
        return Icons.schedule;
      default:
        return Icons.help;
    }
  }

  String _formatTime(String time) {
    try {
      final parts = time.split(':');
      final hour = int.parse(parts[0]);
      final minute = parts[1];
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:$minute $period';
    } catch (e) {
      return time;
    }
  }

  String _formatDate(String dateTime) {
    try {
      final date = DateTime.parse(dateTime);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return dateTime;
    }
  }
}
