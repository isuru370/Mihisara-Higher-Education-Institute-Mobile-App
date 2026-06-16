import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';

class AppDateTime {
  AppDateTime._();

  /// Get current date and time in local timezone (Asia/Colombo)
  static DateTime now() {
    return tz.TZDateTime.now(tz.local);
  }

  /// Get current date only (without time) in local timezone
  static DateTime today() {
    final now = tz.TZDateTime.now(tz.local);
    return DateTime(now.year, now.month, now.day);
  }

  /// Convert UTC DateTime to local DateTime
  static DateTime toLocal(DateTime utcDateTime) {
    return tz.TZDateTime.from(utcDateTime, tz.local);
  }

  /// Convert local DateTime to UTC
  static DateTime toUtc(DateTime localDateTime) {
    return tz.TZDateTime.from(localDateTime, tz.UTC);
  }

  /// Parse ISO string to local DateTime (handles UTC from API)
  static DateTime parseToLocal(String isoString) {
    try {
      final utcDateTime = DateTime.parse(isoString);
      return toLocal(utcDateTime);
    } catch (e) {
      return DateTime.now();
    }
  }

  /// Format date for API (YYYY-MM-DD)
  static String formatForApi(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// Format date for display (e.g., "15 Jan 2024")
  static String formatForDisplay(DateTime date) {
    return DateFormat('d MMM yyyy').format(date);
  }

  /// Format date with time for display
  static String formatForDisplayWithTime(DateTime date) {
    return DateFormat('d MMM yyyy, hh:mm a').format(date);
  }

  /// Get day of week name (e.g., "Monday")
  static String getDayOfWeek(DateTime date, {bool lowerCase = false}) {
    final dayName = DateFormat('EEEE').format(date);
    return lowerCase ? dayName.toLowerCase() : dayName;
  }

  /// Get short day of week name (e.g., "Mon")
  static String getShortDayOfWeek(DateTime date) {
    return DateFormat('EEE').format(date);
  }

  /// Get day of week for API (lowercase)
  static String getDayOfWeekForApi(DateTime date) {
    return getDayOfWeek(date, lowerCase: true);
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final today = AppDateTime.today();
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  /// Check if date is tomorrow
  static bool isTomorrow(DateTime date) {
    final tomorrow = AppDateTime.today().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  /// Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = AppDateTime.today().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// Check if date is in the past
  static bool isPast(DateTime date) {
    final today = AppDateTime.today();
    final compareDate = DateTime(date.year, date.month, date.day);
    return compareDate.isBefore(today);
  }

  /// Check if date is in the future
  static bool isFuture(DateTime date) {
    final today = AppDateTime.today();
    final compareDate = DateTime(date.year, date.month, date.day);
    return compareDate.isAfter(today);
  }

  /// Get start of day (00:00:00)
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get end of day (23:59:59.999)
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// Get start of week (Monday)
  static DateTime startOfWeek(DateTime date) {
    final daysToSubtract = date.weekday - 1;
    return date.subtract(Duration(days: daysToSubtract));
  }

  /// Get end of week (Sunday)
  static DateTime endOfWeek(DateTime date) {
    final daysToAdd = 7 - date.weekday;
    return date.add(Duration(days: daysToAdd));
  }

  /// Get start of month
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Get end of month
  static DateTime endOfMonth(DateTime date) {
    final nextMonth = date.month == 12 ? 1 : date.month + 1;
    final nextMonthYear = date.month == 12 ? date.year + 1 : date.year;
    final firstDayNextMonth = DateTime(nextMonthYear, nextMonth, 1);
    return firstDayNextMonth.subtract(const Duration(days: 1));
  }

  /// Get previous month
  static DateTime previousMonth(DateTime date) {
    if (date.month == 1) {
      return DateTime(date.year - 1, 12, 1);
    }
    return DateTime(date.year, date.month - 1, 1);
  }

  /// Get next month
  static DateTime nextMonth(DateTime date) {
    if (date.month == 12) {
      return DateTime(date.year + 1, 1, 1);
    }
    return DateTime(date.year, date.month + 1, 1);
  }

  /// Get month name (e.g., "January")
  static String getMonthName(DateTime date) {
    return DateFormat('MMMM').format(date);
  }

  /// Get short month name (e.g., "Jan")
  static String getShortMonthName(DateTime date) {
    return DateFormat('MMM').format(date);
  }

  /// Get date range for past N days
  static List<DateTime> getPastDays(int days) {
    final today = AppDateTime.today();
    return List.generate(
      days,
      (index) => today.subtract(Duration(days: index + 1)),
    );
  }

  /// Get date range for future N days
  static List<DateTime> getFutureDays(int days) {
    final today = AppDateTime.today();
    return List.generate(days, (index) => today.add(Duration(days: index + 1)));
  }

  /// Get date range between two dates
  static List<DateTime> getDateRange(DateTime start, DateTime end) {
    final List<DateTime> dates = [];
    DateTime current = startOfDay(start);
    final endDate = startOfDay(end);

    while (current.isBefore(endDate) || current.isAtSameMomentAs(endDate)) {
      dates.add(current);
      current = current.add(const Duration(days: 1));
    }
    return dates;
  }

  /// Check if two dates are the same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Get difference in days between two dates
  static int daysBetween(DateTime from, DateTime to) {
    final fromDate = DateTime(from.year, from.month, from.day);
    final toDate = DateTime(to.year, to.month, to.day);
    return toDate.difference(fromDate).inDays;
  }

  /// Add days to date
  static DateTime addDays(DateTime date, int days) {
    return date.add(Duration(days: days));
  }

  /// Subtract days from date
  static DateTime subtractDays(DateTime date, int days) {
    return date.subtract(Duration(days: days));
  }

  /// Parse date string with format
  static DateTime? parseDate(
    String dateString, {
    String format = 'yyyy-MM-dd',
  }) {
    try {
      return DateFormat(format).parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Get human readable time ago (e.g., "2 days ago")
  static String timeAgo(DateTime dateTime) {
    final now = AppDateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 7) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'just now';
    }
  }
}
