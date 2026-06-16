import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/students_model.dart';
import '../bloc/students/students_bloc.dart';
import 'single_student_view_page.dart';

class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key});

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  final TextEditingController _searchController = TextEditingController();

  String? selectedGrade;

  List<StudentModel> filteredStudents = [];

  @override
  void initState() {
    super.initState();

    context.read<StudentsBloc>().add(FetchStudents(""));
  }

  void _filterStudents(List<StudentModel> students) {
    final query = _searchController.text.toLowerCase();

    setState(() {
      filteredStudents = students.where((student) {
        final matchesName = student.initialName.toLowerCase().contains(query);

        final matchesGrade =
            selectedGrade == null || student.grade?.gradeName == selectedGrade;

        return matchesName && matchesGrade;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text(
          'Students',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),

      body: BlocBuilder<StudentsBloc, StudentsState>(
        builder: (context, state) {
          if (state is StudentsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is StudentsLoaded) {
            final students = state.students;

            if (filteredStudents.isEmpty) {
              filteredStudents = students;
            }

            return Column(
              children: [
                // TOP SECTION
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                  ),

                  child: Column(
                    children: [
                      // SEARCH
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: AppColors.softShadow,
                        ),

                        child: TextField(
                          controller: _searchController,
                          onChanged: (_) => _filterStudents(students),

                          decoration: InputDecoration(
                            hintText: 'Search students...',
                            prefixIcon: const Icon(Icons.search),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // FILTER
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: AppColors.softShadow,
                        ),

                        child: DropdownButtonFormField<String>(
                          value: selectedGrade,

                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                          ),

                          hint: const Text('Filter by grade'),

                          items: [
                            const DropdownMenuItem<String>(
                              value: null,
                              child: Text('All Grades'),
                            ),

                            ...students
                                .map((s) => s.grade?.gradeName)
                                .toSet()
                                .map(
                                  (grade) => DropdownMenuItem<String>(
                                    value: grade,
                                    child: Text(grade ?? 'Unknown Grade'),
                                  ),
                                ),
                          ],

                          onChanged: (value) {
                            setState(() {
                              selectedGrade = value;
                            });

                            _filterStudents(students);
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // STUDENT COUNT
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),

                  child: Row(
                    children: [
                      Text(
                        "${filteredStudents.length} Students",
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // LIST
                Expanded(
                  child: filteredStudents.isEmpty
                      ? const Center(
                          child: Text(
                            'No students found',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),

                          itemCount: filteredStudents.length,

                          itemBuilder: (context, index) {
                            final student = filteredStudents[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        SingleStudentViewPage(student: student),
                                  ),
                                );
                              },

                              child: Container(
                                margin: const EdgeInsets.only(bottom: 14),

                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: AppColors.softShadow,
                                ),

                                child: Padding(
                                  padding: const EdgeInsets.all(16),

                                  child: Row(
                                    children: [
                                      // AVATAR
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundColor: AppColors.primary
                                            .withOpacity(.1),

                                        backgroundImage: student.imgUrl != null
                                            ? NetworkImage(student.imgUrl!)
                                            : null,

                                        child: student.imgUrl == null
                                            ? const Icon(
                                                Icons.person,
                                                color: AppColors.primary,
                                                size: 30,
                                              )
                                            : null,
                                      ),

                                      const SizedBox(width: 14),

                                      // DETAILS
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,

                                          children: [
                                            Text(
                                              student.initialName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                              ),
                                            ),

                                            const SizedBox(height: 4),

                                            Text(
                                              "Grade ${student.grade?.gradeName ?? 'N/A'}",
                                              style: TextStyle(
                                                color: Colors.grey.shade700,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),

                                            const SizedBox(height: 2),

                                            Text(
                                              student.mobile ?? "N/A",
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // QR / ID
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,

                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),

                                            decoration: BoxDecoration(
                                              color: AppColors.primary
                                                  .withOpacity(.08),

                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),

                                            child: Text(
                                              student.permanentQrActive == true
                                                  ? student.customId ?? 'N/A'
                                                  : student.temporaryQrCode ??
                                                        'N/A',

                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ),

                                          const SizedBox(height: 10),

                                          const Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 16,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          }

          if (state is StudentsError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
