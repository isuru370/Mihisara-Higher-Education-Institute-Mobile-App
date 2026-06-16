import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  /// Pick + Crop image for ID card (18:22 ratio)
  Future<File?> pickImage({required ImageSource source}) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 90,
        maxWidth: 1200,
        maxHeight: 1600,
      );

      if (pickedFile == null) return null;

      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 18, ratioY: 22),
        compressQuality: 90,
        maxWidth: 600,
        maxHeight: 750,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop ID Photo',
            lockAspectRatio: true,
            hideBottomControls: false,
          ),
          IOSUiSettings(
            title: 'Crop ID Photo',
            aspectRatioLockEnabled: true,
          ),
        ],
      );

      if (croppedFile == null) return null;

      return File(croppedFile.path);
    } catch (e) {
      throw Exception('Failed to pick image: $e');
    }
  }
}