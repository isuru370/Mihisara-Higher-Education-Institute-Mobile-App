import 'dart:async';

import '../network/api_http.dart' as http;
import 'app_exceptions.dart';

/// Turns any caught error into a short message that can be shown to staff.
///
/// Datasources often throw `Exception('...')` and re-wrap it
/// (`Exception('Unexpected error: $e')`), so `e.toString()` gave texts like
/// "Exception: Unexpected error: Exception: Student not found". This removes
/// those prefixes and replaces low-level network errors with plain wording.
String friendlyError(Object error) {
  if (error is AppException) {
    return _clean(error.message);
  }

  if (error is TimeoutException) {
    return http.timeoutMessage;
  }

  if (error is http.ClientException) {
    return error.message == http.timeoutMessage
        ? http.timeoutMessage
        : 'Cannot reach the server. Check the internet connection and try again.';
  }

  return _clean(error.toString());
}

final RegExp _prefixes = RegExp(
  r'^(\s*(Exception|Unexpected error|Network error|Error|ClientException)\s*:\s*)+',
  caseSensitive: false,
);

String _clean(String message) {
  var text = message.trim();

  // Strip repeated "Exception: Unexpected error: Exception: " style prefixes.
  var previous = '';
  while (previous != text) {
    previous = text;
    text = text.replaceFirst(_prefixes, '').trim();
  }

  final lower = text.toLowerCase();

  if (lower.contains('socketexception') ||
      lower.contains('failed host lookup') ||
      lower.contains('connection refused') ||
      lower.contains('connection reset') ||
      lower.contains('network is unreachable')) {
    return 'Cannot reach the server. Check the internet connection and try again.';
  }

  if (lower.contains('formatexception') || lower.contains('unexpected character')) {
    return 'Invalid response received from the server.';
  }

  if (text.isEmpty) {
    return 'Something went wrong. Please try again.';
  }

  return text;
}
