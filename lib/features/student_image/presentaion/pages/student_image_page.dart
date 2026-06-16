import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../bloc/student_image/student_image_bloc.dart';

class StudentImagePage extends StatefulWidget {
  const StudentImagePage({super.key});

  @override
  State<StudentImagePage> createState() => _StudentImagePageState();
}

class _StudentImagePageState extends State<StudentImagePage> {
  final TextEditingController _searchController = TextEditingController();

  String _search = '';

  @override
  void initState() {
    super.initState();
    context.read<StudentImageBloc>().add(const FetchStudentImageEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshStudents() async {
    context.read<StudentImageBloc>().add(const FetchStudentImageEvent());
  }

  Future<void> _editStudentImage(int studentId) async {
    final controller = TextEditingController();

    final result = await showDialog<String>(
      context: context,

      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          title: const Text('Update Student Image'),

          content: TextField(
            controller: controller,

            textCapitalization: TextCapitalization.characters,

            decoration: InputDecoration(
              labelText: 'Quick Image ID',
              hintText: 'QP-001',

              prefixIcon: const Icon(Icons.image_rounded),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                final value = controller.text.trim().toUpperCase();

                if (value.isEmpty) {
                  return;
                }

                Navigator.pop(context, value);
              },

              child: const Text('Update'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    if (result != null && result.isNotEmpty) {
      context.read<StudentImageBloc>().add(
        UpdateStudentImageEvent(studentId: studentId, quickImageId: result),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentImageBloc, StudentImageState>(
      listener: (context, state) {
        if (state is StudentImageUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.success,
              content: Text(state.message),
            ),
          );
        }

        if (state is StudentImageError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.danger,
              content: Text(state.message),
            ),
          );
        }
      },
      builder: (context, state) {
        final isBusy =
            state is StudentImageLoading || state is StudentImageUpdating;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            title: const Text(
              'Student Images',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _search = value.toLowerCase().trim();
                        });
                      },
                      decoration: InputDecoration(
                        hintText:
                            'Search by QR Code, Custom ID or Initial Name',
                        prefixIcon: const Icon(Icons.search_rounded),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.4,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (state is StudentImageLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state is StudentImageError) {
                          return Center(child: Text(state.message));
                        }

                        if (state is StudentImageLoaded) {
                          final students = state.students.where((student) {
                            final query = _search;

                            return student.initialName.toLowerCase().contains(
                                  query,
                                ) ||
                                student.customId.toLowerCase().contains(
                                  query,
                                ) ||
                                student.qrCode.toLowerCase().contains(query);
                          }).toList();

                          if (students.isEmpty) {
                            return const Center(
                              child: Text('No students found'),
                            );
                          }

                          return RefreshIndicator(
                            onRefresh: _refreshStudents,
                            child: ListView.separated(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                              itemCount: students.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 14),
                              itemBuilder: (context, index) {
                                final student = students[index];

                                return Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: AppColors.softShadow,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 72,
                                        height: 72,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          color: AppColors.primaryLight,
                                        ),
                                        clipBehavior: Clip.antiAlias,
                                        child:
                                            student.imgUrl != null &&
                                                student.imgUrl!.isNotEmpty
                                            ? Image.network(
                                                student.imgUrl!,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      return const Icon(
                                                        Icons.person,
                                                        size: 40,
                                                      );
                                                    },
                                              )
                                            : const Icon(
                                                Icons.person,
                                                size: 40,
                                              ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              student.initialName,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: AppColors.primaryLight,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                student.qrCode,
                                                style: const TextStyle(
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              student.customId,
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              student.guardianMobile,
                                              style: const TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: isBusy
                                            ? null
                                            : () =>
                                                  _editStudentImage(student.id),
                                        icon: const Icon(
                                          Icons.edit_rounded,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        }

                        return const SizedBox();
                      },
                    ),
                  ),
                ],
              ),
              if (isBusy)
                Container(
                  color: Colors.black.withOpacity(0.18),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        );
      },
    );
  }
}
