/// Error returned while scanning / marking attendance.
///
/// [statusCode] is the HTTP status from the server, or null when the server
/// could not be reached. [toString] returns only the message so it can be
/// shown to the user as it is (no "Exception:" prefix).
class ScanAttendanceException implements Exception {
  final String message;
  final int? statusCode;

  const ScanAttendanceException(this.message, {this.statusCode});

  @override
  String toString() => message;
}
