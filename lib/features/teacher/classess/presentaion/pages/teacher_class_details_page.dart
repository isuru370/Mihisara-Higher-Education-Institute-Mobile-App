import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../data/model/teacher_class_category_model.dart';
import '../../data/model/teacher_class_schedule_model.dart';
import '../../data/model/teacher_classes_model.dart';

class TeacherClassDetailsPage extends StatelessWidget {
  final TeacherClassModel teacherClass;

  const TeacherClassDetailsPage({
    super.key,
    required this.teacherClass,
  });

  @override
  Widget build(BuildContext context) {
    final subject = teacherClass.subject?.name ?? 'Subject';

    final grade = teacherClass.grade?.name ?? 'Grade';

    final category = teacherClass.categories.isNotEmpty
        ? teacherClass.categories
            .map((e) => e.name)
            .join(', ')
        : 'General';

    return Scaffold(
      backgroundColor: AppColors.background,

      // ============================================================
      // APP BAR
      // ============================================================

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,

        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
          ),
        ),

        title: const Text(
          'Class Details',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // ============================================================
      // BODY
      // ============================================================

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),

        padding: const EdgeInsets.fromLTRB(
          AppColors.paddingLarge,
          8,
          AppColors.paddingLarge,
          30,
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ========================================================
            // HERO
            // ========================================================

            _buildHero(
              subject: subject,
              grade: grade,
              category: category,
            ),

            const SizedBox(height: 24),

            // ========================================================
            // CLASS INFORMATION
            // ========================================================

            _sectionTitle('Class Information'),

            const SizedBox(height: 12),

            _infoCard(
              icon: Icons.class_rounded,
              title: 'Class Name',
              value: teacherClass.className,
            ),

            _infoCard(
              icon: Icons.language_rounded,
              title: 'Medium',
              value: teacherClass.medium ?? '-',
            ),

            _infoCard(
              icon: Icons.groups_rounded,
              title: 'Students',
              value: '${teacherClass.studentCount}',
            ),

            _infoCard(
              icon: Icons.category_rounded,
              title: 'Class Type',
              value: _formatClassType(
                teacherClass.classType,
              ),
            ),

            _infoCard(
              icon: Icons.circle,
              title: 'Status',
              value: teacherClass.isActive
                  ? 'Active'
                  : 'Inactive',
              valueColor: teacherClass.isActive
                  ? AppColors.success
                  : AppColors.danger,
            ),

            const SizedBox(height: 24),

            // ========================================================
            // CLASS CATEGORIES
            // ========================================================

            _sectionTitle('Class Categories'),

            const SizedBox(height: 12),

            if (teacherClass.categories.isEmpty)
              _emptyCategory()
            else
              ...teacherClass.categories.map(
                (category) => _categoryCard(category),
              ),

            const SizedBox(height: 24),

            // ========================================================
            // SCHEDULES
            // ========================================================

            _sectionTitle('Schedules'),

            const SizedBox(height: 12),

            if (teacherClass.schedules.isEmpty)
              _emptySchedule()
            else
              ...teacherClass.schedules.map(
                (schedule) => _scheduleCard(schedule),
              ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // HERO
  // ================================================================

  Widget _buildHero({
    required String subject,
    required String grade,
    required String category,
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
          // ----------------------------------------------------------
          // ICON
          // ----------------------------------------------------------

          Container(
            width: 50,
            height: 50,

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.15),
              borderRadius: BorderRadius.circular(14),
            ),

            child: const Icon(
              Icons.school_rounded,
              color: Colors.white,
              size: 27,
            ),
          ),

          const SizedBox(height: 18),

          // ----------------------------------------------------------
          // SUBJECT
          // ----------------------------------------------------------

          Text(
            subject,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,

            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 7),

          // ----------------------------------------------------------
          // GRADE + CATEGORY
          // ----------------------------------------------------------

          Text(
            '$grade • $category',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,

            style: TextStyle(
              color: Colors.white.withOpacity(.80),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 16),

          // ----------------------------------------------------------
          // ACTIVE BADGE
          // ----------------------------------------------------------

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.14),
              borderRadius: BorderRadius.circular(20),
            ),

            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,

                  decoration: BoxDecoration(
                    color: teacherClass.isActive
                        ? AppColors.success
                        : AppColors.danger,
                    shape: BoxShape.circle,
                  ),
                ),

                const SizedBox(width: 6),

                Text(
                  teacherClass.isActive
                      ? 'ACTIVE CLASS'
                      : 'INACTIVE CLASS',

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // SECTION TITLE
  // ================================================================

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }

  // ================================================================
  // INFO CARD
  // ================================================================

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),

      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppColors.radiusMedium,
        border: Border.all(
          color: AppColors.border,
        ),
      ),

      child: Row(
        children: [
          // ----------------------------------------------------------
          // ICON
          // ----------------------------------------------------------

          Container(
            width: 40,
            height: 40,

            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(11),
            ),

            child: Icon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          // ----------------------------------------------------------
          // CONTENT
          // ----------------------------------------------------------

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,

                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: valueColor ??
                        AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // CATEGORY CARD
  // ================================================================

  Widget _categoryCard(
    TeacherClassCategoryModel category,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppColors.radiusMedium,
        border: Border.all(
          color: AppColors.border,
        ),
        boxShadow: AppColors.softShadow,
      ),

      child: Row(
        children: [
          // ----------------------------------------------------------
          // CATEGORY ICON
          // ----------------------------------------------------------

          Container(
            width: 46,
            height: 46,

            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(13),
            ),

            child: const Icon(
              Icons.category_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),

          const SizedBox(width: 12),

          // ----------------------------------------------------------
          // CATEGORY INFO
          // ----------------------------------------------------------

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,

                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),

                if (category.code != null &&
                    category.code!.isNotEmpty) ...[
                  const SizedBox(height: 4),

                  Text(
                    category.code!,

                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(width: 10),

          // ----------------------------------------------------------
          // ACTIVE BADGE
          // ----------------------------------------------------------

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 5,
            ),

            decoration: BoxDecoration(
              color: AppColors.successLight,
              borderRadius: BorderRadius.circular(20),
            ),

            child: const Text(
              'ACTIVE',
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w700,
                color: AppColors.success,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // SCHEDULE CARD
  // ================================================================

  Widget _scheduleCard(
    TeacherClassScheduleModel schedule,
  ) {
    final status =
        (schedule.status ?? 'scheduled').toLowerCase();

    final statusInfo = _getScheduleStatusInfo(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppColors.radiusMedium,
        border: Border.all(
          color: AppColors.border,
        ),
        boxShadow: AppColors.softShadow,
      ),

      child: Row(
        children: [
          // ----------------------------------------------------------
          // CALENDAR ICON
          // ----------------------------------------------------------

          Container(
            width: 46,
            height: 46,

            decoration: BoxDecoration(
              color: statusInfo.background,
              borderRadius: BorderRadius.circular(13),
            ),

            child: Icon(
              statusInfo.icon,
              color: statusInfo.color,
              size: 22,
            ),
          ),

          const SizedBox(width: 12),

          // ----------------------------------------------------------
          // DAY + TIME
          // ----------------------------------------------------------

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  schedule.formattedDay.isNotEmpty
                      ? schedule.formattedDay
                      : 'Schedule',

                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: AppColors.textMuted,
                    ),

                    const SizedBox(width: 5),

                    Flexible(
                      child: Text(
                        schedule.formattedTime.isNotEmpty
                            ? schedule.formattedTime
                            : '-',

                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),

                if (schedule.classDate != null &&
                    schedule.classDate!.isNotEmpty) ...[
                  const SizedBox(height: 4),

                  Row(
                    children: [
                      const Icon(
                        Icons.event_rounded,
                        size: 13,
                        color: AppColors.textMuted,
                      ),

                      const SizedBox(width: 5),

                      Flexible(
                        child: Text(
                          _formatDate(
                            schedule.classDate!,
                          ),

                          overflow:
                              TextOverflow.ellipsis,

                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                if (schedule.note != null &&
                    schedule.note!.isNotEmpty) ...[
                  const SizedBox(height: 5),

                  Text(
                    schedule.note!,

                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(width: 8),

          // ----------------------------------------------------------
          // STATUS
          // ----------------------------------------------------------

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 5,
            ),

            decoration: BoxDecoration(
              color: statusInfo.background,
              borderRadius: BorderRadius.circular(20),
            ),

            child: Text(
              _formatScheduleStatus(status),

              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w700,
                color: statusInfo.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // SCHEDULE STATUS
  // ================================================================

  _ScheduleStatusInfo _getScheduleStatusInfo(
    String status,
  ) {
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

  // ================================================================
  // EMPTY CATEGORY
  // ================================================================

  Widget _emptyCategory() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(30),

      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppColors.radiusMedium,
        border: Border.all(
          color: AppColors.border,
        ),
      ),

      child: const Column(
        children: [
          Icon(
            Icons.category_outlined,
            size: 40,
            color: AppColors.textMuted,
          ),

          SizedBox(height: 10),

          Text(
            'No categories available',

            textAlign: TextAlign.center,

            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // EMPTY SCHEDULE
  // ================================================================

  Widget _emptySchedule() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(30),

      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppColors.radiusMedium,
        border: Border.all(
          color: AppColors.border,
        ),
      ),

      child: const Column(
        children: [
          Icon(
            Icons.event_busy_rounded,
            size: 40,
            color: AppColors.textMuted,
          ),

          SizedBox(height: 10),

          Text(
            'No schedules available',

            textAlign: TextAlign.center,

            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // CLASS TYPE
  // ================================================================

  String _formatClassType(String? type) {
    if (type == null || type.isEmpty) {
      return '-';
    }

    switch (type.toLowerCase()) {
      case 'offline':
        return 'Offline';

      case 'online':
        return 'Online';

      case 'hybrid':
        return 'Hybrid';

      default:
        return type[0].toUpperCase() +
            type.substring(1);
    }
  }

  // ================================================================
  // DATE FORMAT
  // ================================================================

  String _formatDate(String date) {
    try {
      final parsed = DateTime.parse(date);

      return '${parsed.day.toString().padLeft(2, '0')}/'
          '${parsed.month.toString().padLeft(2, '0')}/'
          '${parsed.year}';
    } catch (_) {
      return date;
    }
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