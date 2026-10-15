import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../data/model/teacher_classes_model.dart';
import '../bloc/teacher_classes/teacher_classes_bloc.dart';
import 'teacher_class_details_page.dart';

class TeacherClassesPage extends StatefulWidget {
  const TeacherClassesPage({super.key});

  @override
  State<TeacherClassesPage> createState() => _TeacherClassesPageState();
}

class _TeacherClassesPageState extends State<TeacherClassesPage> {
  @override
  void initState() {
    super.initState();

    context.read<TeacherClassesBloc>().add(const FetchTeacherClasses());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: BlocBuilder<TeacherClassesBloc, TeacherClassesState>(
          builder: (context, state) {
            if (state is TeacherClassesLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (state is TeacherClassesError) {
              return _buildError(state.message);
            }

            if (state is TeacherClassesLoaded) {
              return _buildContent(state.classes);
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  // ============================================================
  // CONTENT
  // ============================================================

  Widget _buildContent(List<TeacherClassModel> classes) {
    final totalClasses = classes.length;

    final activeClasses = classes.where((element) => element.isActive).length;

    final totalStudents = classes.fold<int>(
      0,
      (sum, item) => sum + item.studentCount,
    );

    return RefreshIndicator(
      color: AppColors.primary,

      onRefresh: () async {
        context.read<TeacherClassesBloc>().add(const FetchTeacherClasses());
      },

      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),

        padding: const EdgeInsets.fromLTRB(
          AppColors.paddingLarge,
          18,
          AppColors.paddingLarge,
          30,
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),

            const SizedBox(height: 24),

            _buildOverviewCard(
              totalClasses: totalClasses,
              activeClasses: activeClasses,
              totalStudents: totalStudents,
            ),

            const SizedBox(height: 28),

            _buildSectionHeader(totalClasses),

            const SizedBox(height: 14),

            if (classes.isEmpty)
              _buildEmptyState()
            else
              _buildClassList(classes),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,

          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.border),
            boxShadow: AppColors.softShadow,
          ),

          child: const Icon(
            Icons.menu_book_rounded,
            color: AppColors.primary,
            size: 24,
          ),
        ),

        const SizedBox(width: 13),

        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Teaching',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),

              SizedBox(height: 2),

              Text(
                'My Classes',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),

        Container(
          width: 44,
          height: 44,

          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),

          child: const Icon(
            Icons.filter_list_rounded,
            color: AppColors.iconPrimary,
            size: 22,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // OVERVIEW
  // ============================================================

  Widget _buildOverviewCard({
    required int totalClasses,
    required int activeClasses,
    required int totalStudents,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: AppColors.radiusLarge,
        boxShadow: AppColors.mediumShadow,
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,

                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),

                child: const Icon(
                  Icons.school_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Text(
                  'Your Teaching Overview',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              _overviewItem(value: '$totalClasses', label: 'Total Classes'),

              _overviewDivider(),

              _overviewItem(value: '$activeClasses', label: 'Active'),

              _overviewDivider(),

              _overviewItem(value: '$totalStudents', label: 'Students'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _overviewItem({required String value, required String label}) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.75),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _overviewDivider() {
    return Container(
      width: 1,
      height: 35,
      color: Colors.white.withOpacity(0.20),
    );
  }

  // ============================================================
  // SECTION HEADER
  // ============================================================

  Widget _buildSectionHeader(int totalClasses) {
    return Row(
      children: [
        const Text(
          'Assigned Classes',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),

        const Spacer(),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),

          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(20),
          ),

          child: Text(
            '$totalClasses ${totalClasses == 1 ? 'Class' : 'Classes'}',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CLASS LIST
  // ============================================================

  Widget _buildClassList(List<TeacherClassModel> classes) {
    return Column(
      children: [
        for (int i = 0; i < classes.length; i++) ...[
          _buildClassCard(classes[i]),

          if (i != classes.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }

  // ============================================================
  // CLASS CARD
  // ============================================================

  Widget _buildClassCard(TeacherClassModel teacherClass) {
    final subject = teacherClass.subject?.name ?? 'Subject';

    final grade = teacherClass.grade?.name ?? 'Grade';

    final category = teacherClass.categories.isNotEmpty
        ? teacherClass.categories.map((e) => e.name).join(', ')
        : 'General';

    final isActive = teacherClass.isActive;

    final schedule = teacherClass.schedules.isNotEmpty
        ? teacherClass.schedules.first
        : null;

    return InkWell(
      borderRadius: AppColors.radiusMedium,

      onTap: () {
        _openClassDetails(teacherClass);
      },

      child: Container(
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppColors.radiusMedium,
          border: Border.all(color: AppColors.border),
          boxShadow: AppColors.softShadow,
        ),

        child: Column(
          children: [
            // ----------------------------------------------------
            // TOP
            // ----------------------------------------------------
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,

                  decoration: BoxDecoration(
                    color: _iconBackground(teacherClass),
                    borderRadius: BorderRadius.circular(13),
                  ),

                  child: Icon(
                    _classIcon(teacherClass),
                    color: _iconColor(teacherClass),
                    size: 24,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject,

                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        '$grade • $category',

                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),

                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.successLight
                        : AppColors.surfaceSecondary,
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Text(
                    isActive ? 'ACTIVE' : 'INACTIVE',

                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: isActive ? AppColors.success : AppColors.textMuted,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Container(height: 1, color: AppColors.divider),

            const SizedBox(height: 14),

            // ----------------------------------------------------
            // SCHEDULE
            // ----------------------------------------------------
            if (schedule != null) ...[
              Row(
                children: [
                  _infoItem(
                    icon: Icons.calendar_today_rounded,
                    text: schedule.formattedDay.isNotEmpty
                        ? schedule.formattedDay
                        : '-',
                  ),

                  const SizedBox(width: 18),

                  Expanded(
                    child: _infoItem(
                      icon: Icons.access_time_rounded,
                      text: schedule.formattedTime.isNotEmpty
                          ? schedule.formattedTime
                          : '-',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 11),

              _buildScheduleStatus(schedule),
            ],

            // ----------------------------------------------------
            // STUDENTS
            // ----------------------------------------------------
            const SizedBox(height: 11),

            Row(
              children: [
                _infoItem(
                  icon: Icons.groups_outlined,
                  text: '${teacherClass.studentCount} Students',
                ),

                const Spacer(),

                Container(
                  width: 32,
                  height: 32,

                  decoration: BoxDecoration(
                    color: AppColors.surfaceSecondary,
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: const Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: AppColors.iconSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SCHEDULE STATUS
  // ============================================================

  Widget _buildScheduleStatus(dynamic schedule) {
    final status = (schedule.status ?? 'scheduled').toString().toLowerCase();

    final info = _getScheduleStatusInfo(status);

    return Row(
      children: [
        Icon(info.icon, size: 14, color: info.color),

        const SizedBox(width: 5),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

          decoration: BoxDecoration(
            color: info.background,
            borderRadius: BorderRadius.circular(20),
          ),

          child: Text(
            _formatScheduleStatus(status),

            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w700,
              color: info.color,
            ),
          ),
        ),
      ],
    );
  }

  _ScheduleStatusInfo _getScheduleStatusInfo(String status) {
    switch (status) {
      case 'ongoing':
        return const _ScheduleStatusInfo(
          icon: Icons.play_circle_fill_rounded,
          color: AppColors.primary,
          background: AppColors.primaryLight,
        );

      case 'completed':
        return const _ScheduleStatusInfo(
          icon: Icons.check_circle_rounded,
          color: AppColors.success,
          background: AppColors.successLight,
        );

      case 'cancelled':
      case 'canceled':
        return const _ScheduleStatusInfo(
          icon: Icons.cancel_rounded,
          color: AppColors.danger,
          background: AppColors.dangerLight,
        );

      case 'scheduled':
      default:
        return const _ScheduleStatusInfo(
          icon: Icons.schedule_rounded,
          color: AppColors.info,
          background: AppColors.infoLight,
        );
    }
  }

  String _formatScheduleStatus(String status) {
    switch (status) {
      case 'ongoing':
        return 'ONGOING';

      case 'completed':
        return 'COMPLETED';

      case 'cancelled':
      case 'canceled':
        return 'CANCELLED';

      case 'scheduled':
      default:
        return 'SCHEDULED';
    }
  }

  // ============================================================
  // ICON
  // ============================================================

  IconData _classIcon(TeacherClassModel teacherClass) {
    final subject = teacherClass.subject?.name.toLowerCase() ?? '';

    if (subject.contains('math')) {
      return Icons.calculate_rounded;
    }

    if (subject.contains('english')) {
      return Icons.menu_book_rounded;
    }

    if (subject.contains('science')) {
      return Icons.science_rounded;
    }

    if (subject.contains('physics')) {
      return Icons.bolt_rounded;
    }

    if (subject.contains('chemistry')) {
      return Icons.biotech_rounded;
    }

    return Icons.school_rounded;
  }

  Color _iconColor(TeacherClassModel teacherClass) {
    final subject = teacherClass.subject?.name.toLowerCase() ?? '';

    if (subject.contains('math')) {
      return AppColors.primary;
    }

    if (subject.contains('english')) {
      return AppColors.info;
    }

    if (subject.contains('science')) {
      return AppColors.success;
    }

    if (subject.contains('physics')) {
      return AppColors.warning;
    }

    return AppColors.primary;
  }

  Color _iconBackground(TeacherClassModel teacherClass) {
    final subject = teacherClass.subject?.name.toLowerCase() ?? '';

    if (subject.contains('math')) {
      return AppColors.primaryLight;
    }

    if (subject.contains('english')) {
      return AppColors.infoLight;
    }

    if (subject.contains('science')) {
      return AppColors.successLight;
    }

    if (subject.contains('physics')) {
      return AppColors.warningLight;
    }

    return AppColors.primaryLight;
  }

  // ============================================================
  // INFO ITEM
  // ============================================================

  Widget _infoItem({required IconData icon, required String text}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: AppColors.textMuted),

        const SizedBox(width: 6),

        Flexible(
          child: Text(
            text,

            overflow: TextOverflow.ellipsis,

            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // EMPTY
  // ============================================================

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),

      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppColors.radiusMedium,
        border: Border.all(color: AppColors.border),
      ),

      child: const Column(
        children: [
          Icon(Icons.school_outlined, size: 48, color: AppColors.textMuted),

          SizedBox(height: 12),

          Text(
            'No Classes Assigned',

            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),

          SizedBox(height: 5),

          Text(
            'You currently have no classes assigned to you.',

            textAlign: TextAlign.center,

            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: AppColors.danger,
            ),

            const SizedBox(height: 12),

            const Text(
              'Unable to load classes',

              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              message,

              textAlign: TextAlign.center,

              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 18),

            ElevatedButton(
              onPressed: () {
                context.read<TeacherClassesBloc>().add(
                  const FetchTeacherClasses(),
                );
              },

              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CLASS DETAILS
  // ============================================================

  void _openClassDetails(TeacherClassModel teacherClass) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TeacherClassDetailsPage(teacherClass: teacherClass),
      ),
    );
  }
}

// ==================================================================
// SCHEDULE STATUS INFO
// ==================================================================

class _ScheduleStatusInfo {
  final IconData icon;
  final Color color;
  final Color background;

  const _ScheduleStatusInfo({
    required this.icon,
    required this.color,
    required this.background,
  });
}
