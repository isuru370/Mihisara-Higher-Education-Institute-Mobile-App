import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../class_schedule/data/model/attendance_schedule/attendance_schedule_request_model.dart';
import '../../../class_schedule/presentaion/bloc/class_schedule/class_schedule_bloc.dart';

class AttendanceSchedulePage extends StatefulWidget {
  final int studentClassId;
  final int classCategoryFeeId;
  final String className;
  final String categoryName;

  const AttendanceSchedulePage({
    super.key,
    required this.studentClassId,
    required this.classCategoryFeeId,
    required this.className,
    required this.categoryName,
  });

  @override
  State<AttendanceSchedulePage> createState() => _AttendanceSchedulePageState();
}

class _AttendanceSchedulePageState extends State<AttendanceSchedulePage> {
  @override
  void initState() {
    super.initState();
    context.read<ClassScheduleBloc>().add(
      FetchAttendanceScheduleEvent(
        AttendanceScheduleRequestModel(
          studentClassId: widget.studentClassId,
          classCategoryFeeId: widget.classCategoryFeeId,
        ),
      ),
    );
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
          'Attendance Schedules',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              context.read<ClassScheduleBloc>().add(
                FetchAttendanceScheduleEvent(
                  AttendanceScheduleRequestModel(
                    studentClassId: widget.studentClassId,
                    classCategoryFeeId: widget.classCategoryFeeId,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: BlocBuilder<ClassScheduleBloc, ClassScheduleState>(
        builder: (context, state) {
          if (state is ClassScheduleLoading) {
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
                    'Loading attendance schedules...',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          if (state is ClassScheduleError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading schedules',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: TextStyle(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<ClassScheduleBloc>().add(
                        FetchAttendanceScheduleEvent(
                          AttendanceScheduleRequestModel(
                            studentClassId: widget.studentClassId,
                            classCategoryFeeId: widget.classCategoryFeeId,
                          ),
                        ),
                      );
                    },
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

          if (state is AttendanceScheduleLoaded) {
            if (state.response.data.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No schedules found',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No attendance schedules available for this category',
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                // Header Section
                _buildHeaderSection(),
                // Schedule List
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.response.data.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = state.response.data[index];
                      return _buildScheduleCard(item);
                    },
                  ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildHeaderSection() {
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
              // Class Info Card
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
                        Icons.class_,
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
                            widget.className,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
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
                                      widget.categoryName,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
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
              // Selection Prompt
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Select a session to mark attendance',
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

  Widget _buildScheduleCard(dynamic item) {
    final isCompleted = item.isCompleted ?? false;
    final status = item.status ?? 'upcoming';
    final isUpcoming = status.toLowerCase() == 'upcoming';
    final isCompletedStatus = status.toLowerCase() == 'completed';
    final isOngoing = status.toLowerCase() == 'ongoing';

    Color getStatusColor() {
      if (isCompletedStatus) return Colors.green;
      if (isUpcoming) return Colors.blue;
      if (isOngoing) return Colors.orange;
      return Colors.grey;
    }

    String getStatusText() {
      if (isCompletedStatus) return 'Completed';
      if (isOngoing) return 'Ongoing';
      return status.toUpperCase();
    }

    IconData getStatusIcon() {
      if (isCompletedStatus) return Icons.check_circle;
      if (isUpcoming) return Icons.schedule;
      if (isOngoing) return Icons.play_circle;
      return Icons.help;
    }

    return Container(
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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () {
            // Navigate to attendance report page

            Navigator.pushNamed(
              context,
              '/attendance_report',
              arguments: {'schedule_id': item.scheduleId},
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Date and Status
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            getStatusColor(),
                            getStatusColor().withOpacity(0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        getStatusIcon(),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.classDate ?? 'No Date',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1F2937),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.day ?? '',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: getStatusColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: getStatusColor().withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        getStatusText(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: getStatusColor(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Divider
                Divider(color: Colors.grey[200], height: 1),
                const SizedBox(height: 12),
                // Time Information
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      '${item.startTime ?? ''} - ${item.endTime ?? ''}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? Colors.green.withOpacity(0.1)
                            : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isCompleted ? Icons.check : Icons.pending,
                            size: 14,
                            color: isCompleted ? Colors.green : Colors.orange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isCompleted ? 'Completed' : 'Pending',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isCompleted ? Colors.green : Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
