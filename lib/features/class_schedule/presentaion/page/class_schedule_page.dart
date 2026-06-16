import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_datetime.dart';
import '../../data/model/cancel/class_cancel_request_model.dart';
import '../../data/model/class_schedule_model.dart';
import '../../data/model/schedule/class_schedule_request_model.dart';
import '../bloc/class_schedule/class_schedule_bloc.dart';
import 'add_new_day_page.dart';
import 'class_schedule_update_page.dart';

// Define MonthType enum at the top level
enum MonthType { previous, current, next }

class ClassSchedulePage extends StatefulWidget {
  final String className;
  final int classId;
  final int classCategoryFeeId;
  final String categoryName;

  const ClassSchedulePage({
    super.key,
    required this.className,
    required this.classId,
    required this.classCategoryFeeId,
    required this.categoryName,
  });

  @override
  State<ClassSchedulePage> createState() => _ClassSchedulePageState();
}

class _ClassSchedulePageState extends State<ClassSchedulePage> {
  DateTime _selectedDate = AppDateTime.today();
  String _selectedStatusFilter = 'All';
  final List<String> _statusFilters = [
    'All',
    'scheduled',
    'ongoing',
    'completed',
    'cancelled',
  ];

  // Month selection for filtering
  MonthType _selectedMonthType = MonthType.current;

  @override
  void initState() {
    super.initState();
    _fetchSchedules();
  }

  void _fetchSchedules() {
    context.read<ClassScheduleBloc>().add(
      FetchClassScheduleEvent(
        ClassScheduleRequestModel(
          classCategoryFeeId: widget.classCategoryFeeId,
        ),
      ),
    );
  }

  // Filter schedules by selected month
  List<ClassScheduleModel> _filterByMonth(List<ClassScheduleModel> schedules) {
    final now = AppDateTime.now();

    switch (_selectedMonthType) {
      case MonthType.previous:
        final previousMonth = now.month == 1 ? 12 : now.month - 1;
        final previousYear = now.month == 1 ? now.year - 1 : now.year;
        return schedules.where((schedule) {
          final date = AppDateTime.parseToLocal(schedule.classDate);
          return date.month == previousMonth && date.year == previousYear;
        }).toList();

      case MonthType.current:
        return schedules.where((schedule) {
          final date = AppDateTime.parseToLocal(schedule.classDate);
          return date.month == now.month && date.year == now.year;
        }).toList();

      case MonthType.next:
        final nextMonth = now.month == 12 ? 1 : now.month + 1;
        final nextYear = now.month == 12 ? now.year + 1 : now.year;
        return schedules.where((schedule) {
          final date = AppDateTime.parseToLocal(schedule.classDate);
          return date.month == nextMonth && date.year == nextYear;
        }).toList();
    }
  }

  String _getMonthNameFromType(MonthType type) {
    final now = AppDateTime.now();
    switch (type) {
      case MonthType.previous:
        final previousMonth = now.month == 1 ? 12 : now.month - 1;
        return _getMonthName(previousMonth);
      case MonthType.current:
        return _getMonthName(now.month);
      case MonthType.next:
        final nextMonth = now.month == 12 ? 1 : now.month + 1;
        return _getMonthName(nextMonth);
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  String _getFormattedDateForDisplay(String dateStr) {
    if (dateStr.isEmpty) return 'Date not available';
    try {
      final date = AppDateTime.parseToLocal(dateStr);
      if (AppDateTime.isToday(date)) {
        return 'Today';
      } else if (AppDateTime.isTomorrow(date)) {
        return 'Tomorrow';
      } else {
        return AppDateTime.formatForDisplay(date);
      }
    } catch (e) {
      return dateStr;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return Colors.blue;
      case 'ongoing':
        return Colors.green;
      case 'completed':
        return Colors.purple;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return '📅';
      case 'ongoing':
        return '▶️';
      case 'completed':
        return '✅';
      case 'cancelled':
        return '❌';
      default:
        return '📌';
    }
  }

  bool _isDateLocked(DateTime scheduleDate) {
    final today = AppDateTime.today();
    final scheduleDateOnly = AppDateTime.startOfDay(scheduleDate);
    return scheduleDateOnly.isBefore(today);
  }

  bool _canEditOrCancel(String status, DateTime scheduleDate) {
    if (status.toLowerCase() == 'completed' ||
        status.toLowerCase() == 'cancelled' ||
        status.toLowerCase() == 'ongoing') {
      return false;
    }

    if (_isDateLocked(scheduleDate)) {
      return false;
    }

    return true;
  }

  bool _shouldShowSchedule(ClassScheduleModel schedule) {
    final scheduleDate = AppDateTime.parseToLocal(schedule.classDate);
    final scheduleDateOnly = AppDateTime.startOfDay(scheduleDate);
    final selectedDateOnly = AppDateTime.startOfDay(_selectedDate);

    if (!AppDateTime.isSameDay(scheduleDateOnly, selectedDateOnly)) {
      return false;
    }

    if (_selectedStatusFilter != 'All' &&
        schedule.status.toLowerCase() != _selectedStatusFilter.toLowerCase()) {
      return false;
    }

    return true;
  }

  List<DateTime> _getAvailableDates(List<ClassScheduleModel> schedules) {
    final Set<DateTime> uniqueDates = {};

    for (var schedule in schedules) {
      try {
        final date = AppDateTime.parseToLocal(schedule.classDate);
        final dateOnly = AppDateTime.startOfDay(date);
        uniqueDates.add(dateOnly);
      } catch (e) {
        continue;
      }
    }

    final sortedDates = uniqueDates.toList()..sort();
    return sortedDates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: Text(
          widget.className,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchSchedules,
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
                    'Loading schedules...',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          if (state is ClassScheduleLoaded) {
            final allResponseSchedules = state.response.data;

            if (allResponseSchedules.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.schedule_outlined,
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
                      'No schedules available for this class',
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                  ],
                ),
              );
            }

            // Filter by selected month (previous, current, or next)
            final monthFilteredSchedules = _filterByMonth(allResponseSchedules);

            if (monthFilteredSchedules.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No schedules for ${_getMonthNameFromType(_selectedMonthType)}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Try selecting a different month',
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                  ],
                ),
              );
            }

            final availableDates = _getAvailableDates(monthFilteredSchedules);

            // Reset selected date if current selected date has no schedules
            if (availableDates.isNotEmpty &&
                !availableDates.any(
                  (date) => AppDateTime.isSameDay(date, _selectedDate),
                )) {
              _selectedDate = availableDates.first;
            }

            final filteredSchedules = monthFilteredSchedules
                .where(_shouldShowSchedule)
                .toList();

            return Column(
              children: [
                // Hero Banner
                _buildHeroBanner(monthFilteredSchedules),
                // Month Selection Tabs
                _buildMonthTabs(),
                // Horizontal Date Picker
                if (availableDates.isNotEmpty)
                  _buildHorizontalDatePicker(availableDates),
                // Status Filter Chips
                _buildStatusFilter(),
                // Schedule List
                Expanded(
                  child: filteredSchedules.isEmpty
                      ? _buildEmptyState()
                      : RefreshIndicator(
                          onRefresh: () async {
                            _fetchSchedules();
                          },
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: filteredSchedules.length,
                            itemBuilder: (context, index) {
                              final item = filteredSchedules[index];
                              return _buildScheduleCard(item);
                            },
                          ),
                        ),
                ),
              ],
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
                    onPressed: _fetchSchedules,
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

          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Navigate to AddNewDayPage and wait for result
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNewDayPage(
                className: widget.className,
                classId: widget.classId,
                classFeeId: widget.classCategoryFeeId,
              ),
            ),
          );

          // Refresh if new schedule was added
          if (result == true) {
            _fetchSchedules();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Schedule added successfully!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Add New Day'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

  Widget _buildMonthTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _buildMonthTab(MonthType.previous, 'Previous'),
          _buildMonthTab(MonthType.current, 'Current'),
          _buildMonthTab(MonthType.next, 'Next'),
        ],
      ),
    );
  }

  Widget _buildMonthTab(MonthType type, String label) {
    final isSelected = _selectedMonthType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedMonthType = type;
            // Reset selected date when changing months
            _selectedDate = AppDateTime.today();
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            children: [
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[600],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
              if (isSelected)
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  width: 20,
                  height: 2,
                  color: Colors.white,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroBanner(List<ClassScheduleModel> schedules) {
    final todaySchedules = schedules.where((schedule) {
      final date = AppDateTime.parseToLocal(schedule.classDate);
      return AppDateTime.isToday(date);
    }).toList();

    final ongoingSchedules = todaySchedules
        .where((schedule) => schedule.status.toLowerCase() == 'ongoing')
        .toList();

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Container(
              height: 130,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, Color(0xff1D4ED8)],
                ),
              ),
            ),
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: -20,
              bottom: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.schedule,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.categoryName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${schedules.length} sessions in ${_getMonthNameFromType(_selectedMonthType)}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 12,
                          ),
                        ),
                        if (ongoingSchedules.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${ongoingSchedules.length} Ongoing Today',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.event,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalDatePicker(List<DateTime> availableDates) {
    return Container(
      height: 90,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: availableDates.length,
        itemBuilder: (context, index) {
          final date = availableDates[index];
          final isSelected = AppDateTime.isSameDay(date, _selectedDate);
          final isToday = AppDateTime.isToday(date);

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = date;
              });
            },
            child: Container(
              width: 65,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey[200]!,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppDateTime.getShortDayOfWeek(date),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 2),
                  if (isToday)
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusFilter() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _statusFilters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = _statusFilters[index];
          final isSelected = _selectedStatusFilter == filter;
          return FilterChip(
            label: Text(filter.toUpperCase()),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                _selectedStatusFilter = filter;
              });
            },
            backgroundColor: Colors.white,
            selectedColor: AppColors.primary.withOpacity(0.1),
            checkmarkColor: AppColors.primary,
            labelStyle: TextStyle(
              color: isSelected ? AppColors.primary : Colors.grey[700],
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              fontSize: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isSelected ? AppColors.primary : Colors.grey[300]!,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.schedule_outlined, size: 80, color: Colors.grey[400]),
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
            'No class schedules available for this date',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(ClassScheduleModel item) {
    final scheduleDate = AppDateTime.parseToLocal(item.classDate);
    final isLocked = _isDateLocked(scheduleDate);
    final canEditCancel = _canEditOrCancel(item.status, scheduleDate);
    final statusColor = _getStatusColor(item.status);
    final statusIcon = _getStatusIcon(item.status);
    final formattedDate = _getFormattedDateForDisplay(item.classDate);
    final isToday = formattedDate == 'Today';
    final isCancelled = item.status.toLowerCase() == 'cancelled';
    final cancelReason = item.cancelReason;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isLocked ? Colors.grey[50] : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: isLocked ? Border.all(color: Colors.grey[200]!) : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: isToday
                          ? const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.orange, Colors.deepOrange],
                            )
                          : LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.primary,
                                const Color(0xff1D4ED8),
                              ],
                            ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      isToday ? Icons.today : Icons.calendar_month,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isToday
                                ? Colors.orange
                                : const Color(0xff1F2937),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${AppDateTime.getDayOfWeek(scheduleDate)} • ${item.startTime} - ${item.endTime}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: statusColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(statusIcon, style: const TextStyle(fontSize: 12)),
                        const SizedBox(width: 4),
                        Text(
                          item.status.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(color: Colors.grey[200], height: 1),
              const SizedBox(height: 12),
              _buildInfoRow(
                Icons.category_outlined,
                'Category',
                item.classCategoryFee.category.categoryName,
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.location_on_outlined,
                'Hall',
                item.hall.hallName,
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.access_time,
                'Time',
                '${item.startTime} - ${item.endTime}',
              ),
              // Show cancellation reason if status is cancelled and reason exists
              if (isCancelled &&
                  cancelReason != null &&
                  cancelReason.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.withOpacity(0.2)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info_outline,
                          size: 16,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Cancellation Reason:',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                cancelReason,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff374151),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              if (canEditCancel)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ClassScheduleUpdatePage(
                                schedule: item,
                                className: widget.className,
                                classId: widget.classId,
                                classCategoryFeeId: widget.classCategoryFeeId,
                              ),
                            ),
                          );

                          if (result == true) {
                            _fetchSchedules();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Schedule updated successfully!'),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text('Edit'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: Colors.blue.withOpacity(0.5)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _showCancelDialog(context, item);
                        },
                        icon: const Icon(Icons.cancel, size: 18),
                        label: const Text('Cancel'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: Colors.red.withOpacity(0.5)),
                        ),
                      ),
                    ),
                  ],
                )
              else if (isLocked)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: 16,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Past sessions cannot be modified',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                )
              else if (item.status.toLowerCase() == 'completed')
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(statusIcon, style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 8),
                      Text(
                        'This session is completed',
                        style: TextStyle(
                          fontSize: 12,
                          color: statusColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[500]),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xff374151),
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _showCancelDialog(BuildContext context, ClassScheduleModel item) {
    final TextEditingController reasonController = TextEditingController();
    final FocusNode focusNode = FocusNode();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                'Cancel Schedule',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Are you sure you want to cancel the schedule for ${AppDateTime.formatForDisplay(AppDateTime.parseToLocal(item.classDate))}?',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.red,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'This action cannot be undone',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Cancellation Reason (Optional)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff374151),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.25,
                      ),
                      child: TextFormField(
                        controller: reasonController,
                        focusNode: focusNode,
                        maxLines: null,
                        expands: false,
                        decoration: InputDecoration(
                          hintText: 'Enter reason for cancellation...',
                          hintStyle: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[400],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    focusNode.dispose();
                    reasonController.dispose();
                    Navigator.pop(dialogContext);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[600],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('No, Keep'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final cancelReason = reasonController.text.trim();

                    focusNode.dispose();
                    reasonController.dispose();
                    Navigator.pop(dialogContext);

                    context.read<ClassScheduleBloc>().add(
                      CancelClassScheduleEvent(
                        ClassCancelRequestModel(
                          scheduleId: item.id,
                          cancelReason: cancelReason.isEmpty
                              ? null
                              : cancelReason,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Yes, Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
