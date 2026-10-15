import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/app_datetime.dart';
import '../../../classess/presentaion/pages/teacher_classes_page.dart';
import '../../../navigation/teacher_bottom_navigation.dart';
import '../../../profile/presentaion/pages/teacher_profile_page.dart';
import '../../../students/presentaion/pages/teacher_students_page.dart';
import '../../../timetable/presentaion/pages/teacher_timetable_page.dart';
import '../../data/models/teacher_dashboard_model.dart';
import '../../data/models/teacher_dashboard_summary_model.dart';
import '../../data/models/teacher_dashboard_teacher_model.dart';
import '../../data/models/today_class_model.dart';
import '../bloc/teacher_dashboard/teacher_dashboard_bloc.dart';

class TeacherDashboardPage extends StatefulWidget {
  const TeacherDashboardPage({super.key});

  @override
  State<TeacherDashboardPage> createState() => _TeacherDashboardPageState();
}

class _TeacherDashboardPageState extends State<TeacherDashboardPage> {
  int _currentIndex = 0;

  late final List<Widget> _pages = [
    const _TeacherHomePage(),
    const TeacherClassesPage(),
    const TeacherTimetablePage(),
    const TeacherStudentsPage(),
    const TeacherProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: TeacherBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

// ============================================================================
// TEACHER HOME
// ============================================================================

class _TeacherHomePage extends StatefulWidget {
  const _TeacherHomePage();

  @override
  State<_TeacherHomePage> createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<_TeacherHomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<TeacherDashboardBloc>().add(const FetchTeacherDashboard());
    });
  }

  Future<void> _refreshDashboard() async {
    context.read<TeacherDashboardBloc>().add(const FetchTeacherDashboard());
  }

  @override
  Widget build(BuildContext context) {
    final today = AppDateTime.today();

    return BlocBuilder<TeacherDashboardBloc, TeacherDashboardState>(
      builder: (context, state) {
        if (state is TeacherDashboardLoading) {
          return _buildLoadingState();
        }

        if (state is TeacherDashboardFailure) {
          return _buildErrorState(message: state.message);
        }

        if (state is TeacherDashboardSuccess) {
          return RefreshIndicator(
            onRefresh: _refreshDashboard,
            color: AppColors.primary,
            backgroundColor: AppColors.surface,
            child: _buildDashboard(dashboard: state.dashboard, today: today),
          );
        }

        return _buildInitialState();
      },
    );
  }

  // ==========================================================================
  // DASHBOARD
  // ==========================================================================

  Widget _buildDashboard({
    required TeacherDashboardModel dashboard,
    required DateTime today,
  }) {
    final teacher = dashboard.teacher;
    final summary = dashboard.summary;

    return SafeArea(
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
            _buildHeader(date: today, teacher: teacher),

            const SizedBox(height: 24),

            _buildWelcomeCard(teacher: teacher, summary: summary),

            const SizedBox(height: 28),

            _buildSectionHeader(title: "Today's Overview"),

            const SizedBox(height: 14),

            _buildStatistics(summary: summary),

            const SizedBox(height: 28),

            _buildSectionHeader(
              title: "Today's Classes",
              actionText: "See All",
              onActionTap: () {
                // Bottom navigation -> Classes
                // Can be connected later through parent callback.
              },
            ),

            const SizedBox(height: 14),

            _buildTodayClasses(classes: dashboard.todayClasses),

            const SizedBox(height: 28),

            _buildSectionHeader(title: "Quick Access"),

            const SizedBox(height: 14),

            _buildQuickActions(),

            const SizedBox(height: 28),

            _buildSectionHeader(
              title: "Attendance Overview",
              actionText: "View",
              onActionTap: () {},
            ),

            const SizedBox(height: 14),

            _buildAttendanceCard(summary: summary),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // LOADING
  // ==========================================================================

  Widget _buildLoadingState() {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppColors.paddingLarge,
          18,
          AppColors.paddingLarge,
          30,
        ),
        child: Column(
          children: [
            _shimmerBox(
              width: double.infinity,
              height: 55,
              radius: AppColors.radiusMedium,
            ),

            const SizedBox(height: 24),

            _shimmerBox(
              width: double.infinity,
              height: 210,
              radius: AppColors.radiusLarge,
            ),

            const SizedBox(height: 28),

            Row(
              children: [
                Expanded(
                  child: _shimmerBox(
                    width: double.infinity,
                    height: 155,
                    radius: AppColors.radiusMedium,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _shimmerBox(
                    width: double.infinity,
                    height: 155,
                    radius: AppColors.radiusMedium,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _shimmerBox(
                    width: double.infinity,
                    height: 155,
                    radius: AppColors.radiusMedium,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _shimmerBox(
                    width: double.infinity,
                    height: 155,
                    radius: AppColors.radiusMedium,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            _shimmerBox(
              width: double.infinity,
              height: 140,
              radius: AppColors.radiusMedium,
            ),

            const SizedBox(height: 14),

            _shimmerBox(
              width: double.infinity,
              height: 140,
              radius: AppColors.radiusMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _shimmerBox({
    required double width,
    required double height,
    BorderRadius? radius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary,
        borderRadius: radius ?? BorderRadius.circular(12),
      ),
    );
  }

  // ==========================================================================
  // ERROR
  // ==========================================================================

  Widget _buildErrorState({required String message}) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppColors.paddingLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.dangerLight,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(
                  Icons.cloud_off_rounded,
                  size: 34,
                  color: AppColors.danger,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Unable to load dashboard',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                _cleanErrorMessage(message),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 22),

              ElevatedButton.icon(
                onPressed: () {
                  context.read<TeacherDashboardBloc>().add(
                    const FetchTeacherDashboard(),
                  );
                },
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _cleanErrorMessage(String message) {
    if (message.startsWith('Exception: ')) {
      return message.replaceFirst('Exception: ', '');
    }

    return message;
  }

  Widget _buildInitialState() {
    return const SizedBox.shrink();
  }

  // ==========================================================================
  // HEADER
  // ==========================================================================

  Widget _buildHeader({
    required DateTime date,
    required TeacherDashboardTeacherModel teacher,
  }) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            boxShadow: AppColors.softShadow,
          ),
          child: _buildTeacherAvatar(teacher: teacher),
        ),

        const SizedBox(width: 13),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getGreeting(),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                teacher.fullName.isNotEmpty ? teacher.fullName : 'Teacher',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                AppDateTime.formatForDisplay(date),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),

        _buildNotificationButton(),
      ],
    );
  }

  Widget _buildTeacherAvatar({required TeacherDashboardTeacherModel teacher}) {
    final initials = teacher.initials.trim();

    if (initials.isNotEmpty) {
      return Center(
        child: Text(
          initials
              .substring(0, initials.length > 2 ? 2 : initials.length)
              .toUpperCase(),
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      );
    }

    return const Icon(Icons.person_rounded, size: 27, color: AppColors.primary);
  }

  Widget _buildNotificationButton() {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.softShadow,
      ),
      child: Stack(
        children: [
          const Center(
            child: Icon(
              Icons.notifications_none_rounded,
              size: 24,
              color: AppColors.iconPrimary,
            ),
          ),

          Positioned(
            top: 9,
            right: 9,
            child: Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                color: AppColors.danger,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good Morning 👋';
    }

    if (hour < 17) {
      return 'Good Afternoon 👋';
    }

    return 'Good Evening 👋';
  }

  // ==========================================================================
  // WELCOME CARD
  // ==========================================================================

  Widget _buildWelcomeCard({
    required TeacherDashboardTeacherModel teacher,
    required TeacherDashboardSummaryModel summary,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: AppColors.radiusLarge,
        boxShadow: AppColors.mediumShadow,
      ),
      child: Stack(
        children: [
          Positioned(
            right: -25,
            top: -35,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            right: 35,
            bottom: -55,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'TEACHER PORTAL',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Text(
                'Welcome back, ${teacher.fullName}!',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'Here is your teaching overview for today.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.82),
                  fontSize: 12,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 18),

              Row(
                children: [
                  _welcomeMiniStat(
                    icon: Icons.menu_book_rounded,
                    value: summary.totalClasses.toString(),
                    label: 'Classes',
                  ),

                  const SizedBox(width: 25),

                  _welcomeMiniStat(
                    icon: Icons.groups_rounded,
                    value: summary.totalStudents.toString(),
                    label: 'Students',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _welcomeMiniStat({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Row(
      children: [
        Icon(icon, size: 19, color: Colors.white.withOpacity(0.9)),

        const SizedBox(width: 7),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),

            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.72),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================================================
  // SECTION HEADER
  // ==========================================================================

  Widget _buildSectionHeader({
    required String title,
    String? actionText,
    VoidCallback? onActionTap,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),

        const Spacer(),

        if (actionText != null)
          GestureDetector(
            onTap: onActionTap,
            child: Row(
              children: [
                Text(
                  actionText,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(width: 3),

                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 10,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
      ],
    );
  }

  // ==========================================================================
  // STATISTICS
  // ==========================================================================

  Widget _buildStatistics({required TeacherDashboardSummaryModel summary}) {
    final attendance = summary.attendancePercentage;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1,
      children: [
        _statCard(
          title: 'My Classes',
          value: summary.totalClasses.toString(),
          subtitle: 'Assigned classes',
          icon: Icons.menu_book_rounded,
          iconColor: AppColors.primary,
          iconBackground: AppColors.primaryLight,
        ),

        _statCard(
          title: 'Students',
          value: summary.totalStudents.toString(),
          subtitle: 'Total students',
          icon: Icons.groups_rounded,
          iconColor: AppColors.info,
          iconBackground: AppColors.infoLight,
        ),

        _statCard(
          title: 'Present Today',
          value: summary.todayAttendance.toString(),
          subtitle: 'Students present',
          icon: Icons.how_to_reg_rounded,
          iconColor: AppColors.success,
          iconBackground: AppColors.successLight,
        ),

        _statCard(
          title: 'Attendance',
          value: '${attendance.toStringAsFixed(1)}%',
          subtitle: "Today's average",
          icon: Icons.bar_chart_rounded,
          iconColor: AppColors.warning,
          iconBackground: AppColors.warningLight,
        ),
      ],
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color iconBackground,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppColors.radiusMedium,
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),

          const Spacer(),

          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 1),

          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            subtitle,
            style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // TODAY'S CLASSES
  // ==========================================================================

  Widget _buildTodayClasses({required List<TodayClassModel> classes}) {
    if (classes.isEmpty) {
      return _buildEmptyTodayClasses();
    }

    return Column(
      children: [
        for (int i = 0; i < classes.length; i++) ...[
          _classCard(classData: classes[i]),

          if (i != classes.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _buildEmptyTodayClasses() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppColors.radiusMedium,
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(17),
            ),
            child: const Icon(
              Icons.event_available_rounded,
              color: AppColors.primary,
              size: 27,
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'No classes today',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'You have no scheduled classes for today.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _classCard({required TodayClassModel classData}) {
    final status = (classData.status ?? 'scheduled').toLowerCase();

    final statusInfo = _getStatusInfo(status);

    final subjectName =
        classData.subject?.name ?? classData.className ?? 'Class';

    final gradeName = classData.grade?.name ?? '';

    final categoryName = classData.category?.name ?? '';

    final time = _formatTimeRange(
      classData.startTime ?? '',
      classData.endTime ?? '',
    );

    final icon = _getClassIcon(subject: subjectName, category: categoryName);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppColors.radiusMedium,
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSecondary,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  time,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),

              const Spacer(),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: statusInfo.background,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(statusInfo.icon, size: 13, color: statusInfo.color),

                    const SizedBox(width: 4),

                    Text(
                      status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: statusInfo.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, size: 23, color: AppColors.primary),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subjectName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      _buildClassSubtitle(
                        grade: gradeName,
                        category: categoryName,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Row(
                      children: [
                        const Icon(
                          Icons.groups_outlined,
                          size: 14,
                          color: AppColors.textMuted,
                        ),

                        const SizedBox(width: 4),

                        Text(
                          '${classData.studentCount} Students',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),

                        if (classData.hall != null) ...[
                          const SizedBox(width: 10),

                          const Icon(
                            Icons.location_on_outlined,
                            size: 13,
                            color: AppColors.textMuted,
                          ),

                          const SizedBox(width: 3),

                          Flexible(
                            child: Text(
                              classData.hall!.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _buildClassSubtitle({
    required String grade,
    required String category,
  }) {
    if (grade.isNotEmpty && category.isNotEmpty) {
      return '$grade • $category';
    }

    if (grade.isNotEmpty) {
      return grade;
    }

    if (category.isNotEmpty) {
      return category;
    }

    return 'Class';
  }

  // ==========================================================================
  // STATUS
  // ==========================================================================

  _ClassStatusInfo _getStatusInfo(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const _ClassStatusInfo(
          icon: Icons.check_circle_rounded,
          color: AppColors.success,
          background: AppColors.successLight,
        );

      case 'ongoing':
        return const _ClassStatusInfo(
          icon: Icons.play_circle_fill_rounded,
          color: AppColors.primary,
          background: AppColors.primaryLight,
        );

      case 'cancelled':
      case 'canceled':
        return const _ClassStatusInfo(
          icon: Icons.cancel_rounded,
          color: AppColors.danger,
          background: AppColors.dangerLight,
        );

      case 'scheduled':
      default:
        return const _ClassStatusInfo(
          icon: Icons.schedule_rounded,
          color: AppColors.info,
          background: AppColors.infoLight,
        );
    }
  }

  // ==========================================================================
  // TIME
  // ==========================================================================

  String _formatTimeRange(String startTime, String endTime) {
    final start = _formatTime(startTime);
    final end = _formatTime(endTime);

    if (end.isEmpty) {
      return start;
    }

    if (start.isEmpty) {
      return end;
    }

    return '$start - $end';
  }

  String _formatTime(String value) {
    if (value.trim().isEmpty) {
      return '';
    }

    try {
      final parts = value.split(':');

      if (parts.length < 2) {
        return value;
      }

      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      final period = hour >= 12 ? 'PM' : 'AM';

      final displayHour = hour % 12 == 0 ? 12 : hour % 12;

      return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
    } catch (_) {
      return value;
    }
  }

  // ==========================================================================
  // CLASS ICON
  // ==========================================================================

  IconData _getClassIcon({required String subject, required String category}) {
    final value = '${subject.toLowerCase()} ${category.toLowerCase()}';

    if (value.contains('math')) {
      return Icons.calculate_rounded;
    }

    if (value.contains('science')) {
      return Icons.science_rounded;
    }

    if (value.contains('english')) {
      return Icons.language_rounded;
    }

    if (value.contains('physics')) {
      return Icons.bolt_rounded;
    }

    if (value.contains('chemistry')) {
      return Icons.biotech_rounded;
    }

    if (value.contains('biology')) {
      return Icons.eco_rounded;
    }

    if (value.contains('paper')) {
      return Icons.description_rounded;
    }

    if (value.contains('revision')) {
      return Icons.replay_rounded;
    }

    return Icons.menu_book_rounded;
  }

  // ==========================================================================
  // QUICK ACCESS
  // ==========================================================================

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _quickAction(
            icon: Icons.menu_book_rounded,
            title: 'My Classes',
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _quickAction(
            icon: Icons.calendar_month_rounded,
            title: 'Timetable',
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _quickAction(icon: Icons.groups_rounded, title: 'Students'),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _quickAction(
            icon: Icons.fact_check_outlined,
            title: 'Attendance',
          ),
        ),
      ],
    );
  }

  Widget _quickAction({required IconData icon, required String title}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppColors.radiusMedium,
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),

          const SizedBox(height: 8),

          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // ATTENDANCE
  // ==========================================================================

  Widget _buildAttendanceCard({required TeacherDashboardSummaryModel summary}) {
    final percentage = (summary.attendancePercentage / 100).clamp(0.0, 1.0);

    final present = summary.todayAttendance;

    final total = summary.todayExpectedStudents;

    final absent = total > present ? total - present : 0;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppColors.radiusMedium,
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.fact_check_outlined,
                  color: AppColors.success,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Today's Attendance",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    SizedBox(height: 3),

                    Text(
                      'Based on your assigned classes',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                '${summary.attendancePercentage.toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: AppColors.success,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 9,
              backgroundColor: AppColors.surfaceSecondary,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.success,
              ),
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _attendanceValue(
                  title: 'Present',
                  value: present.toString(),
                  valueColor: AppColors.success,
                ),
              ),

              _verticalDivider(),

              Expanded(
                child: _attendanceValue(
                  title: 'Absent',
                  value: absent.toString(),
                  valueColor: AppColors.danger,
                ),
              ),

              _verticalDivider(),

              Expanded(
                child: _attendanceValue(
                  title: 'Total',
                  value: total.toString(),
                  valueColor: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _attendanceValue({
    required String title,
    required String value,
    required Color valueColor,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),

        const SizedBox(height: 3),

        Text(
          title,
          style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
        ),
      ],
    );
  }

  Widget _verticalDivider() {
    return Container(width: 1, height: 30, color: AppColors.divider);
  }
}

// ============================================================================
// CLASS STATUS INFO
// ============================================================================

class _ClassStatusInfo {
  final IconData icon;
  final Color color;
  final Color background;

  const _ClassStatusInfo({
    required this.icon,
    required this.color,
    required this.background,
  });
}
