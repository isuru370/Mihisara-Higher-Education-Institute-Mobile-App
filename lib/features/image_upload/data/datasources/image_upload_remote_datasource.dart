import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/storage/session_storage.dart';
import '../models/image_upload/image_upload_request_model.dart';
import '../models/image_upload/image_upload_response_model.dart';

class ImageUploadRemoteDatasource {
  Future<ImageUploadResponseModel> uploadImage({
    required ImageUploadRequestModel request,
  }) async {
    final token = await SessionStorage.getToken();
    final uri = Uri.parse('${ApiConstants.apiUrl}/quick-photo/upload');

    final multipartRequest = http.MultipartRequest('POST', uri);

    if (token != null && token.isNotEmpty) {
      multipartRequest.headers['Authorization'] = 'Bearer $token';
    }

    multipartRequest.files.add(
      await http.MultipartFile.fromPath(
        'image',
        request.image.path,
        contentType: MediaType('image', 'jpeg'),
      ),
    );

    final streamedResponse = await multipartRequest.send();
    final response = await http.Response.fromStream(streamedResponse);

    final decoded = jsonDecode(response.body);

    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    if (response.statusCode == 201 || response.statusCode == 200) {
      return ImageUploadResponseModel.fromJson(decoded as Map<String, dynamic>);
    } else {
      throw Exception(
        decoded is Map<String, dynamic>
            ? (decoded['message'] ?? 'Upload failed')
            : 'Upload failed',
      );
    }
  }
}
