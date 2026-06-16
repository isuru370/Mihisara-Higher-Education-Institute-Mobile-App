import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/image_picker_service.dart';
import '../../../image_upload/data/models/image_upload/image_upload_request_model.dart';
import '../../../image_upload/presentation/bloc/image_upload/image_upload_bloc.dart';

class StudentImageCapturePage extends StatefulWidget {
  final bool registered;

  const StudentImageCapturePage({super.key, required this.registered});

  @override
  State<StudentImageCapturePage> createState() =>
      _StudentImageCapturePageState();
}

class _StudentImageCapturePageState extends State<StudentImageCapturePage> {
  File? _imageFile;

  final ImagePickerService _imageService = ImagePickerService();

  late final ImageUploadBloc _imageUploadBloc;

  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _imageUploadBloc = GetIt.instance<ImageUploadBloc>();
  }

  @override
  void dispose() {
    _imageUploadBloc.close();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final file = await _imageService.pickImage(source: source);

      if (!mounted) return;

      if (file != null) {
        setState(() {
          _imageFile = file;
        });
      }
    } catch (e) {
      debugPrint('Image picking error: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.danger,
          content: Text('Failed to pick image: $e'),
        ),
      );
    }
  }

  void _upload() {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first')),
      );
      return;
    }

    final request = ImageUploadRequestModel(image: _imageFile!);
    _imageUploadBloc.add(UploadImageEvent(request));
  }

  Widget _buildImagePreview() {
    if (_imageFile != null) {
      return Column(
        children: [
          Container(
            width: 180,
            height: 220,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppColors.radiusLarge,
              boxShadow: AppColors.mediumShadow,
              border: Border.all(color: AppColors.border),
            ),
            child: ClipRRect(
              borderRadius: AppColors.radiusLarge,
              child: Image.file(_imageFile!, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 14),
          TextButton.icon(
            onPressed: _isUploading
                ? null
                : () {
                    setState(() {
                      _imageFile = null;
                    });
                  },
            icon: const Icon(Icons.delete_outline_rounded),
            label: const Text('Remove Photo'),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
          ),
        ],
      );
    }

    return Container(
      width: 180,
      height: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppColors.radiusLarge,
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_rounded,
              size: 50,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Photo Selected',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.dark,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Capture or upload image',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _imageUploadBloc,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Student Image Upload'),
        ),
        body: BlocConsumer<ImageUploadBloc, ImageUploadState>(
          listener: (context, state) {
            if (state is ImageUploadLoading) {
              setState(() {
                _isUploading = true;
              });
              return;
            }

            setState(() {
              _isUploading = false;
            });

            if (state is ImageUploadSuccess) {
              final data = state.response.data;
              final quickImageId = data?.customId;

              if (widget.registered) {
                if (quickImageId != null && quickImageId.trim().isNotEmpty) {
                  Navigator.pop(context, quickImageId);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Upload success, but Quick Image ID not found'),
                    ),
                  );
                }
                return;
              }

              showDialog(
                context: context,
                builder: (dialogContext) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: AppColors.radiusLarge,
                    ),
                    title: const Text('Upload Successful'),
                    content: Text(
                      quickImageId == null
                          ? 'Image uploaded successfully.'
                          : 'Quick Image ID: $quickImageId',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();

                          setState(() {
                            _imageFile = null;
                            _isUploading = false;
                          });
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            }

            if (state is ImageUploadError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.danger,
                  content: Text(state.message),
                ),
              );
            }
          },
          builder: (context, uploadState) {
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(26),
                        decoration: BoxDecoration(
                          gradient: AppColors.heroGradient,
                          borderRadius: AppColors.radiusXLarge,
                          boxShadow: AppColors.largeShadow,
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Student Image Capture',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Capture or upload student image securely',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: AppColors.radiusXLarge,
                          boxShadow: AppColors.softShadow,
                        ),
                        child: Column(
                          children: [
                            _buildImagePreview(),
                            const SizedBox(height: 28),
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 14,
                              runSpacing: 14,
                              children: [
                                OutlinedButton.icon(
                                  onPressed: _isUploading
                                      ? null
                                      : () {
                                          _pickImage(ImageSource.camera);
                                        },
                                  icon: const Icon(Icons.camera_alt_rounded),
                                  label: const Text('Camera'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.primary,
                                    side: const BorderSide(
                                      color: AppColors.primary,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: AppColors.radiusMedium,
                                    ),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: _isUploading
                                      ? null
                                      : () {
                                          _pickImage(ImageSource.gallery);
                                        },
                                  icon: const Icon(Icons.photo_library_rounded),
                                  label: const Text('Gallery'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: AppColors.radiusMedium,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton.icon(
                                onPressed: _isUploading ? null : _upload,
                                icon: const Icon(Icons.cloud_upload_rounded),
                                label: const Text('Upload Image'),
                              ),
                            ),
                            const SizedBox(height: 24),
                            if (uploadState is ImageUploadSuccess &&
                                uploadState.response.data != null)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: AppColors.successLight,
                                  borderRadius: AppColors.radiusLarge,
                                  border: Border.all(
                                    color: AppColors.success.withOpacity(0.30),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: AppColors.radiusLarge,
                                      child: Image.network(
                                        uploadState.response.data!.imageUrl,
                                        height: 180,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(
                                            Icons.error,
                                            size: 60,
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Custom ID: ${uploadState.response.data!.customId}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.dark,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (_isUploading)
                  Container(
                    color: Colors.black.withOpacity(0.35),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: AppColors.radiusLarge,
                        ),
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 18),
                            Text('Uploading image...'),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}