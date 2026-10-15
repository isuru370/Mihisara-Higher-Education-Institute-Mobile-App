import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../data/model/teacher_student_class_model.dart';
import '../../data/model/teacher_student_model.dart';
import '../bloc/teacher_students/teacher_students_bloc.dart';

class TeacherStudentsPage extends StatefulWidget {
  const TeacherStudentsPage({super.key});

  @override
  State<TeacherStudentsPage> createState() => _TeacherStudentsPageState();
}

class _TeacherStudentsPageState extends State<TeacherStudentsPage> {
  int _selectedClassIndex = 0;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TeacherStudentsBloc>().add(const FetchTeacherStudents());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<TeacherStudentsBloc, TeacherStudentsState>(
          builder: (context, state) {
            if (state is TeacherStudentsLoading ||
                state is TeacherStudentsInitial) {
              return _buildLoading();
            }

            if (state is TeacherStudentsError) {
              return _buildError(state.message);
            }

            if (state is TeacherStudentsLoaded) {
              return _buildLoaded(state);
            }

            return _buildLoading();
          },
        ),
      ),
    );
  }

  // ============================================================
  // LOADED
  // ============================================================

  Widget _buildLoaded(TeacherStudentsLoaded state) {
    final data = state.data;

    final classes = data.classes;

    if (classes.isEmpty) {
      return Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildNoClasses()),
        ],
      );
    }

    if (_selectedClassIndex >= classes.length) {
      _selectedClassIndex = 0;
    }

    final selectedClass = classes[_selectedClassIndex];

    return Column(
      children: [
        _buildHeader(),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCard(
                  totalStudents: data.summary.totalStudents,
                  totalClasses: data.summary.totalClasses,
                ),

                _buildSectionHeader(
                  title: 'My Classes',
                  trailing: '${classes.length} Classes',
                ),

                _buildClassSelector(classes),

                _buildStudentHeader(selectedClass),

                _buildSearch(),

                _buildStudentList(selectedClass.students),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppColors.paddingLarge,
        20,
        AppColors.paddingLarge,
        16,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Students',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'My Students',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppColors.radiusMedium,
              border: Border.all(color: AppColors.border),
            ),
            child: IconButton(
              onPressed: () {
                _showFilterInfo();
              },
              icon: const Icon(
                Icons.filter_list_rounded,
                color: AppColors.primary,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SUMMARY
  // ============================================================

  Widget _buildSummaryCard({
    required int totalStudents,
    required int totalClasses,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppColors.paddingLarge),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: AppColors.radiusLarge,
          boxShadow: AppColors.mediumShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.16),
                borderRadius: BorderRadius.circular(17),
              ),
              child: const Icon(
                Icons.groups_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Students',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '$totalStudents',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  Text(
                    '$totalClasses',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Text(
                    'Classes',
                    style: TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SECTION HEADER
  // ============================================================

  Widget _buildSectionHeader({
    required String title,
    required String trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppColors.paddingLarge,
        24,
        AppColors.paddingLarge,
        14,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            trailing,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CLASS SELECTOR
  // ============================================================

  Widget _buildClassSelector(List<TeacherStudentClassModel> classes) {
    return SizedBox(
      height: 112,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: AppColors.paddingLarge),
        scrollDirection: Axis.horizontal,
        itemCount: classes.length,
        itemBuilder: (context, index) {
          final item = classes[index];

          final isSelected = index == _selectedClassIndex;

          final gradeName = item.grade?.name ?? 'Grade';

          final categoryName = item.categories.isNotEmpty
              ? item.categories.first.name ?? 'Category'
              : 'Class';

          final subjectName = item.subject?.name ?? '';

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedClassIndex = index;
                _searchController.clear();
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 170,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: AppColors.radiusMedium,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                ),
                boxShadow: isSelected ? AppColors.softShadow : const [],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withOpacity(0.16)
                              : AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.menu_book_rounded,
                          size: 17,
                          color: isSelected ? Colors.white : AppColors.primary,
                        ),
                      ),

                      const Spacer(),

                      Text(
                        '${item.studentsCount}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  Text(
                    '$gradeName • $subjectName',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    categoryName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white70 : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // STUDENT HEADER
  // ============================================================

  Widget _buildStudentHeader(TeacherStudentClassModel selectedClass) {
    final gradeName = selectedClass.grade?.name ?? 'Grade';

    final subjectName = selectedClass.subject?.name ?? 'Class';

    final categoryName = selectedClass.categories.isNotEmpty
        ? selectedClass.categories.first.name ?? 'Category'
        : 'Category';

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppColors.paddingLarge,
        25,
        AppColors.paddingLarge,
        12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$gradeName • $subjectName',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  '${selectedClass.studentsCount} students • $categoryName',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.successLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.circle, size: 7, color: AppColors.success),
                SizedBox(width: 5),
                Text(
                  'Active',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SEARCH
  // ============================================================

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppColors.paddingLarge),
      child: TextField(
        controller: _searchController,
        onChanged: (_) {
          setState(() {});
        },
        decoration: InputDecoration(
          hintText: 'Search student name or ID...',
          hintStyle: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.iconSecondary,
            size: 21,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: AppColors.iconSecondary,
                  ),
                )
              : null,
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(
            borderRadius: AppColors.radiusMedium,
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppColors.radiusMedium,
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppColors.radiusMedium,
            borderSide: const BorderSide(color: AppColors.primary, width: 1.3),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // STUDENT LIST
  // ============================================================

  Widget _buildStudentList(List<TeacherStudentModel> students) {
    final filteredStudents = _filterStudents(students);

    if (filteredStudents.isEmpty) {
      return _buildEmptyState(
        isSearching: _searchController.text.trim().isNotEmpty,
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppColors.paddingLarge,
        14,
        AppColors.paddingLarge,
        0,
      ),
      child: Column(
        children: [
          ...filteredStudents.map(
            (student) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildStudentCard(student),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FILTER
  // ============================================================

  List<TeacherStudentModel> _filterStudents(
    List<TeacherStudentModel> students,
  ) {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      return students;
    }

    return students.where((student) {
      final name = student.fullName?.toLowerCase() ?? '';

      final id = student.customId?.toLowerCase() ?? '';

      final mobile = student.mobile?.toLowerCase() ?? '';

      return name.contains(query) ||
          id.contains(query) ||
          mobile.contains(query);
    }).toList();
  }

  // ============================================================
  // STUDENT CARD
  // ============================================================

  Widget _buildStudentCard(TeacherStudentModel student) {
    final fullName = student.fullName?.trim().isNotEmpty == true
        ? student.fullName!.trim()
        : 'Unknown Student';

    final customId = student.customId?.trim().isNotEmpty == true
        ? student.customId!.trim()
        : 'No ID';

    final mobile = student.mobile?.trim().isNotEmpty == true
        ? student.mobile!.trim()
        : 'No phone number';

    return Material(
      color: AppColors.surface,
      borderRadius: AppColors.radiusMedium,
      child: InkWell(
        onTap: () {
          // TODO:
          // Navigate to student details
        },
        borderRadius: AppColors.radiusMedium,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: AppColors.radiusMedium,
            border: Border.all(color: AppColors.border),
            boxShadow: AppColors.softShadow,
          ),
          child: Row(
            children: [
              // ==================================================
              // AVATAR
              // ==================================================
              _buildStudentAvatar(student, fullName),

              const SizedBox(width: 13),

              // ==================================================
              // STUDENT DETAILS
              // ==================================================
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            customId,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        Container(
                          width: 3,
                          height: 3,
                          decoration: const BoxDecoration(
                            color: AppColors.textMuted,
                            shape: BoxShape.circle,
                          ),
                        ),

                        const SizedBox(width: 8),

                        Flexible(
                          child: Text(
                            mobile,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // ==================================================
              // STATUS + ARROW
              // ==================================================
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: student.isActive
                          ? AppColors.successLight
                          : AppColors.surfaceSecondary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      student.isActive ? 'ACTIVE' : 'INACTIVE',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        color: student.isActive
                            ? AppColors.success
                            : AppColors.textMuted,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: AppColors.iconSecondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // STUDENT AVATAR
  // ============================================================

  Widget _buildStudentAvatar(TeacherStudentModel student, String fullName) {
    final imagePath = student.imgUrl;

    final initials = _getInitials(fullName);

    if (imagePath == null || imagePath.trim().isEmpty) {
      return _initialAvatar(initials);
    }

    final imageUrl = imagePath.startsWith('http')
        ? imagePath
        : '${ApiConstants.baseUrl}/storage/$imagePath';

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: SizedBox(
        width: 52,
        height: 52,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _initialAvatar(initials);
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }

            return Container(
              color: AppColors.primaryLight,
              child: const Center(
                child: SizedBox(
                  width: 17,
                  height: 17,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // INITIAL AVATAR
  // ============================================================

  Widget _initialAvatar(String initials) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // INITIALS
  // ============================================================

  String _getInitials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();

    if (parts.isEmpty) {
      return '?';
    }

    if (parts.length == 1) {
      final value = parts.first;

      return value.length >= 2
          ? value.substring(0, 2).toUpperCase()
          : value.toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  // ============================================================
  // LOADING
  // ============================================================

  Widget _buildLoading() {
    return Column(
      children: [
        _buildHeader(),

        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.primary,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Loading students...',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  'Please wait a moment',
                  style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _buildError(String message) {
    return Column(
      children: [
        _buildHeader(),

        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppColors.paddingLarge),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppColors.radiusLarge,
                  border: Border.all(color: AppColors.border),
                  boxShadow: AppColors.softShadow,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: AppColors.dangerLight,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.error_outline_rounded,
                        color: AppColors.danger,
                        size: 30,
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Unable to load students',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 11,
                        height: 1.5,
                        color: AppColors.textMuted,
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      height: 42,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.read<TeacherStudentsBloc>().add(
                            const FetchTeacherStudents(),
                          );
                        },
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        label: const Text('Try Again'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // NO CLASSES
  // ============================================================

  Widget _buildNoClasses() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppColors.paddingLarge),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppColors.radiusLarge,
            border: Border.all(color: AppColors.border),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.menu_book_outlined,
                size: 45,
                color: AppColors.textMuted,
              ),

              SizedBox(height: 12),

              Text(
                'No classes found',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),

              SizedBox(height: 5),

              Text(
                'You currently have no active classes assigned.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY STUDENTS
  // ============================================================

  Widget _buildEmptyState({required bool isSearching}) {
    return Padding(
      padding: const EdgeInsets.all(AppColors.paddingLarge),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppColors.radiusLarge,
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(
              isSearching
                  ? Icons.search_off_rounded
                  : Icons.person_search_rounded,
              size: 45,
              color: AppColors.textMuted,
            ),

            const SizedBox(height: 12),

            Text(
              isSearching ? 'No students found' : 'No students enrolled',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              isSearching
                  ? 'Try searching with another name or student ID.'
                  : 'There are no students enrolled in this class.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // FILTER INFO
  // ============================================================

  void _showFilterInfo() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                const Text(
                  'Student Filters',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Use the class selector above to view students from a specific class.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.5,
                    color: AppColors.textMuted,
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
