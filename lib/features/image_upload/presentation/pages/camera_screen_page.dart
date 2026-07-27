import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/utils/image_picker_service.dart';
import '../../data/models/image_upload/image_upload_request_model.dart';
import '../bloc/image_upload/image_upload_bloc.dart';

class CameraScreenPage extends StatefulWidget {
  final String studentId;

  const CameraScreenPage({super.key, required this.studentId});

  @override
  State<CameraScreenPage> createState() => _CameraScreenPageState();
}

class _CameraScreenPageState extends State<CameraScreenPage> {
  final ImagePickerService _imagePickerService = ImagePickerService();

  File? _image;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _captureImage();
    });
  }

  Future<void> _captureImage() async {
    final image = await _imagePickerService.pickImage(
      source: ImageSource.camera,
    );

    if (!mounted) return;

    if (image == null) {
      Navigator.pop(context);
      return;
    }

    setState(() {
      _image = image;
    });
  }

  void _uploadImage() {
    if (_image == null) return;

    context.read<ImageUploadBloc>().add(
      UpdateImageEvent(
        ImageUploadRequestModel(studentCode: widget.studentId, image: _image!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ImageUploadBloc, ImageUploadState>(
      listener: (context, state) {
        if (state is ImageUpdateSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.response.message)));

          Navigator.pop(context, true);
        }

        if (state is ImageUploadError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final isUploading = state is ImageUploadLoading;

        return Scaffold(
          appBar: AppBar(
            title: Text("Student : ${widget.studentId}"),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  Text(
                    "Capture Student Image",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(height: 30),

                  Center(
                    child: Container(
                      width: 180,
                      height: 220,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: _image == null
                            ? const Center(child: CircularProgressIndicator())
                            : Image.file(_image!, fit: BoxFit.cover),
                      ),
                    ),
                  ),

                  const Spacer(),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: isUploading ? null : _captureImage,
                          icon: const Icon(Icons.camera_alt),
                          label: const Text("Retake"),
                        ),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: (_image == null || isUploading)
                              ? null
                              : _uploadImage,
                          icon: isUploading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.cloud_upload),
                          label: Text(isUploading ? "Uploading..." : "Upload"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
