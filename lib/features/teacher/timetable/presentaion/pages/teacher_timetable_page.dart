import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/app_datetime.dart';
import '../../data/model/teacher_timetable_class_model.dart';
import '../bloc/teacher_timetable/teacher_timetable_bloc.dart';

class TeacherTimetablePage extends StatefulWidget {
  const TeacherTimetablePage({super.key});

  @override
  State<TeacherTimetablePage> createState() => _TeacherTimetablePageState();
}

class _TeacherTimetablePageState extends State<TeacherTimetablePage> {
  DateTime _selectedDate = AppDateTime.today();

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchTimetable();
    });
  }

  // ============================================================
  // FETCH TIMETABLE
  // ============================================================

  void _fetchTimetable() {
    if (!mounted) return;

    context.read<TeacherTimetableBloc>().add(
      FetchTeacherTimetable(date: _formatDate(_selectedDate)),
    );
  }

  // ============================================================
  // DATE FORMAT
  // ============================================================

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  // ============================================================
  // CHANGE DAY
  // ============================================================

  void _changeDay(int days) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: days));
    });

    _fetchTimetable();
  }

  // ============================================================
  // TODAY
  // ============================================================

  bool get _isToday {
    final today = AppDateTime.today();

    return _selectedDate.year == today.year &&
        _selectedDate.month == today.month &&
        _selectedDate.day == today.day;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<TeacherTimetableBloc, TeacherTimetableState>(
          builder: (context, state) {
            if (state is TeacherTimetableLoading) {
              return _buildLoading();
            }

            if (state is TeacherTimetableError) {
              return _buildError(state.message);
            }

            if (state is TeacherTimetableLoaded) {
              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async {
                  _fetchTimetable();
                },
                child: _buildContent(state),
              );
            }

            return _buildLoading();
          },
        ),
      ),
    );
  }

  // ============================================================
  // CONTENT
  // ============================================================

  Widget _buildContent(TeacherTimetableLoaded state) {
    final timetable = state.timetable;

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        // HEADER
        SliverToBoxAdapter(child: _buildHeader()),

        // DATE SELECTOR
        SliverToBoxAdapter(child: _buildDateSelector()),

        // SUMMARY
        SliverToBoxAdapter(
          child: _buildSummaryCard(
            totalClasses: timetable.summary.totalClasses,
            scheduled: timetable.summary.scheduled,
            ongoing: timetable.summary.ongoing,
            completed: timetable.summary.completed,
            cancelled: timetable.summary.cancelled,
            totalStudents: timetable.summary.totalStudents,
          ),
        ),

        // SECTION TITLE
        SliverToBoxAdapter(child: _buildSectionTitle()),

        // EMPTY
        if (timetable.classes.isEmpty)
          SliverToBoxAdapter(child: _buildEmptyState())
        else
          // CLASSES
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final item = timetable.classes[index];

              return Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppColors.spacingLarge,
                  0,
                  AppColors.spacingLarge,
                  14,
                ),
                child: _buildTimetableItem(item),
              );
            }, childCount: timetable.classes.length),
          ),

        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppColors.spacingLarge,
        20,
        AppColors.spacingLarge,
        16,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Schedule',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'My Timetable',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppColors.radiusMedium,
              border: Border.all(color: AppColors.border),
            ),
            child: IconButton(
              onPressed: _selectDate,
              icon: const Icon(
                Icons.calendar_month_rounded,
                color: AppColors.primary,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DATE PICKER
  // ============================================================

  Future<void> _selectDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (selected == null) return;

    setState(() {
      _selectedDate = selected;
    });

    _fetchTimetable();
  }

  // ============================================================
  // DATE SELECTOR
  // ============================================================

  Widget _buildDateSelector() {
    final dayName = _dayName(_selectedDate);
    final monthName = _monthName(_selectedDate);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppColors.spacingLarge),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppColors.radiusLarge,
          border: Border.all(color: AppColors.border),
          boxShadow: AppColors.softShadow,
        ),
        child: Row(
          children: [
            _dateButton(
              icon: Icons.chevron_left_rounded,
              onTap: () => _changeDay(-1),
            ),

            Expanded(
              child: Column(
                children: [
                  Text(
                    dayName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${_selectedDate.day} $monthName',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            _dateButton(
              icon: Icons.chevron_right_rounded,
              onTap: () => _changeDay(1),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // DATE BUTTON
  // ============================================================

  Widget _dateButton({required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: AppColors.surfaceSecondary,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: AppColors.textSecondary),
        ),
      ),
    );
  }

  // ============================================================
  // SUMMARY CARD
  // ============================================================

  Widget _buildSummaryCard({
    required int totalClasses,
    required int scheduled,
    required int ongoing,
    required int completed,
    required int cancelled,
    required int totalStudents,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppColors.spacingLarge,
        18,
        AppColors.spacingLarge,
        24,
      ),
      child: Container(
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
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.event_available_rounded,
                    color: Colors.white,
                    size: 27,
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isToday ? "Today's Schedule" : 'Daily Schedule',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '$totalClasses classes for this day',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$totalClasses',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Text(
                      'Classes',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 18),

            Container(height: 1, color: Colors.white.withOpacity(0.14)),

            const SizedBox(height: 15),

            // ACTUAL DB STATUS SUMMARY
            Row(
              children: [
                Expanded(
                  child: _summaryStatus(
                    label: 'Scheduled',
                    value: scheduled,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: _summaryStatus(
                    label: 'Ongoing',
                    value: ongoing,
                    color: AppColors.warningLight,
                  ),
                ),
                Expanded(
                  child: _summaryStatus(
                    label: 'Completed',
                    value: completed,
                    color: AppColors.successLight,
                  ),
                ),
                Expanded(
                  child: _summaryStatus(
                    label: 'Cancelled',
                    value: cancelled,
                    color: AppColors.dangerLight,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                const Icon(
                  Icons.groups_outlined,
                  size: 17,
                  color: Colors.white70,
                ),
                const SizedBox(width: 6),
                Text(
                  '$totalStudents Students',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
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
  // SUMMARY STATUS
  // ============================================================

  Widget _summaryStatus({
    required String label,
    required int value,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$value',
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 9,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _buildSectionTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppColors.spacingLarge,
        0,
        AppColors.spacingLarge,
        14,
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              "Today's Classes",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          if (_isToday)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Today',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ============================================================
  // TIMETABLE ITEM
  // ============================================================

  Widget _buildTimetableItem(TeacherTimetableClassModel item) {
    /*
     * IMPORTANT
     *
     * This status comes DIRECTLY from DB.
     *
     * scheduled
     * ongoing
     * completed
     * cancelled
     *
     * No time-based status calculation.
     */

    final status = (item.status ?? 'scheduled').toLowerCase();

    final statusColor = _statusColor(status);
    final statusBackground = _statusBackground(status);

    final startTime = _formatTime(item.startTime);

    final endTime = _formatTime(item.endTime);

    final hallName = item.hall?.name ?? 'No Hall';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ========================================================
        // TIME
        // ========================================================
        SizedBox(
          width: 72,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                startTime,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                endTime,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),

        // ========================================================
        // STATUS DOT
        // ========================================================
        Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(top: 4, right: 12),
          decoration: BoxDecoration(
            color: statusColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: statusColor.withOpacity(0.25),
                blurRadius: 0,
                spreadRadius: 4,
              ),
            ],
          ),
        ),

        // ========================================================
        // CARD
        // ========================================================
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppColors.radiusMedium,
              border: Border.all(
                color: item.isCancelled
                    ? AppColors.danger.withOpacity(0.35)
                    : AppColors.border,
              ),
              boxShadow: AppColors.softShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==================================================
                // TITLE + STATUS
                // ==================================================
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.subtitle,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // STATUS BADGE
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: statusBackground,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _statusText(status),
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),

                // ==================================================
                // CANCEL REASON
                // ==================================================
                if (item.isCancelled &&
                    item.cancelReason != null &&
                    item.cancelReason!.trim().isNotEmpty) ...[
                  const SizedBox(height: 12),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.dangerLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          size: 16,
                          color: AppColors.danger,
                        ),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            item.cancelReason!,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppColors.danger,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 15),

                const Divider(height: 1, color: AppColors.divider),

                const SizedBox(height: 13),

                // ==================================================
                // HALL + STUDENTS
                // ==================================================
                Row(
                  children: [
                    _infoItem(Icons.meeting_room_outlined, hallName),

                    const SizedBox(width: 18),

                    _infoItem(
                      Icons.groups_outlined,
                      '${item.students} Students',
                    ),
                  ],
                ),

                // ==================================================
                // SUBJECT / GRADE / CATEGORY
                // ==================================================
                if (item.subject != null ||
                    item.grade != null ||
                    item.category != null) ...[
                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 12,
                    runSpacing: 7,
                    children: [
                      if (item.subject != null)
                        _smallInfo(
                          Icons.menu_book_outlined,
                          item.subject!.name,
                        ),

                      if (item.grade != null)
                        _smallInfo(
                          Icons.school_outlined,
                          'Grade ${item.grade!.name}',
                        ),

                      if (item.category != null)
                        _smallInfo(
                          Icons.category_outlined,
                          item.category!.name,
                        ),
                    ],
                  ),
                ],

                // ==================================================
                // HALL PRICE
                // ==================================================
                if (item.hall != null && item.hall!.price > 0) ...[
                  const SizedBox(height: 10),

                  _smallInfo(
                    Icons.home_work_outlined,
                    'Hall ${_formatAmount(item.hall!.price)}',
                  ),
                ],

                // ==================================================
                // NOTE
                // ==================================================
                if (item.note != null && item.note!.trim().isNotEmpty) ...[
                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSecondary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.notes_rounded,
                          size: 15,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            item.note!,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
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
      ],
    );
  }

  // ============================================================
  // SMALL INFO
  // ============================================================

  Widget _smallInfo(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.iconSecondary),
        const SizedBox(width: 5),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 150),
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // INFO ITEM
  // ============================================================

  Widget _infoItem(IconData icon, String text) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.iconSecondary),
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
      ),
    );
  }

  // ============================================================
  // LOADING
  // ============================================================

  Widget _buildLoading() {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: _buildHeader()),
        SliverToBoxAdapter(child: _buildDateSelector()),
        const SliverFillRemaining(
          child: Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _buildError(String message) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: _buildHeader()),
        SliverToBoxAdapter(child: _buildDateSelector()),
        SliverFillRemaining(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.dangerLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.error_outline_rounded,
                      color: AppColors.danger,
                      size: 32,
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Unable to load timetable',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton.icon(
                    onPressed: _fetchTimetable,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Try Again'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppColors.spacingLarge,
        vertical: 40,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppColors.radiusLarge,
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.event_busy_rounded,
                color: AppColors.primary,
                size: 30,
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'No Classes',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              _isToday
                  ? 'You have no classes scheduled for today.'
                  : 'No classes are scheduled for this date.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TIME FORMAT
  // ============================================================

  String _formatTime(String? time) {
    if (time == null || time.isEmpty) {
      return '--:--';
    }

    final parts = time.split(':');

    if (parts.length < 2) {
      return time;
    }

    int hour = int.tryParse(parts[0]) ?? 0;

    final minute = parts[1];

    final period = hour >= 12 ? 'PM' : 'AM';

    if (hour == 0) {
      hour = 12;
    } else if (hour > 12) {
      hour -= 12;
    }

    return '$hour:$minute $period';
  }

  // ============================================================
  // AMOUNT FORMAT
  // ============================================================

  String _formatAmount(double amount) {
    if (amount == amount.roundToDouble()) {
      return amount.toInt().toString();
    }

    return amount.toStringAsFixed(2);
  }

  // ============================================================
  // STATUS COLOR
  // ============================================================

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'ongoing':
        return AppColors.warning;

      case 'completed':
        return AppColors.success;

      case 'cancelled':
        return AppColors.danger;

      case 'scheduled':
      default:
        return AppColors.primary;
    }
  }

  // ============================================================
  // STATUS BACKGROUND
  // ============================================================

  Color _statusBackground(String status) {
    switch (status.toLowerCase()) {
      case 'ongoing':
        return AppColors.warningLight;

      case 'completed':
        return AppColors.successLight;

      case 'cancelled':
        return AppColors.dangerLight;

      case 'scheduled':
      default:
        return AppColors.primaryLight;
    }
  }

  // ============================================================
  // STATUS TEXT
  // ============================================================

  String _statusText(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return 'SCHEDULED';

      case 'ongoing':
        return 'ONGOING';

      case 'completed':
        return 'COMPLETED';

      case 'cancelled':
        return 'CANCELLED';

      default:
        return status.toUpperCase();
    }
  }

  // ============================================================
  // DAY NAME
  // ============================================================

  String _dayName(DateTime date) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return days[date.weekday - 1];
  }

  // ============================================================
  // MONTH NAME
  // ============================================================

  String _monthName(DateTime date) {
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

    return months[date.month - 1];
  }
}
