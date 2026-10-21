/// Drop-in replacement for `package:http/http.dart` that adds a time limit to
/// every request.
///
/// Import it with the same prefix the code already uses:
///
///   import '../../core/network/api_http.dart' as http;
///
/// `http.get`, `http.post`, ... then behave as before, except that a request
/// that gets no answer within [requestTimeout] fails with an
/// [http.ClientException] instead of waiting forever. Existing
/// `on http.ClientException` handlers therefore show their normal
/// "network error" message. Everything else from the http package
/// (`Response`, `MultipartRequest`, `ClientException`, ...) is re-exported.
library;

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as base;

export 'package:http/http.dart' hide get, post, put, patch, delete, head, read;

/// How long to wait for the server before giving up.
const Duration requestTimeout = Duration(seconds: 30);

/// Message used when a request times out.
const String timeoutMessage =
    'The server took too long to answer. Check the connection and try again.';

Future<base.Response> _withTimeout(Future<base.Response> request, Uri url) {
  return request.timeout(
    requestTimeout,
    onTimeout: () => throw base.ClientException(timeoutMessage, url),
  );
}

Future<base.Response> get(Uri url, {Map<String, String>? headers}) =>
    _withTimeout(base.get(url, headers: headers), url);

Future<base.Response> head(Uri url, {Map<String, String>? headers}) =>
    _withTimeout(base.head(url, headers: headers), url);

Future<base.Response> post(
  Uri url, {
  Map<String, String>? headers,
  Object? body,
  Encoding? encoding,
}) =>
    _withTimeout(
      base.post(url, headers: headers, body: body, encoding: encoding),
      url,
    );

Future<base.Response> put(
  Uri url, {
  Map<String, String>? headers,
  Object? body,
  Encoding? encoding,
}) =>
    _withTimeout(
      base.put(url, headers: headers, body: body, encoding: encoding),
      url,
    );

Future<base.Response> patch(
  Uri url, {
  Map<String, String>? headers,
  Object? body,
  Encoding? encoding,
}) =>
    _withTimeout(
      base.patch(url, headers: headers, body: body, encoding: encoding),
      url,
    );

Future<base.Response> delete(
  Uri url, {
  Map<String, String>? headers,
  Object? body,
  Encoding? encoding,
}) =>
    _withTimeout(
      base.delete(url, headers: headers, body: body, encoding: encoding),
      url,
    );

Future<String> read(Uri url, {Map<String, String>? headers}) => base
    .read(url, headers: headers)
    .timeout(
      requestTimeout,
      onTimeout: () => throw base.ClientException(timeoutMessage, url),
    );

/// Sends a multipart (file upload) request with a longer time limit.
Future<base.StreamedResponse> sendMultipart(
  base.MultipartRequest request, {
  Duration timeout = const Duration(seconds: 90),
}) {
  return request.send().timeout(
        timeout,
        onTimeout: () => throw base.ClientException(timeoutMessage, request.url),
      );
}
