import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../qr/data/model/read_student_classes/read_student_classes_response_model.dart';
import '../../../qr/data/model/read_student_classes/student_mini_model.dart';
import '../../../qr/presentation/bloc/read_student_classes/read_student_classes_bloc.dart';
import '../../../student_grade/presentation/bloc/student_grade/student_grade_bloc.dart';
import '../../../students/data/models/student_classes_model/student_class_model.dart';
import '../../data/models/get_class_with_grade_model/student_class_data_model.dart';
import '../../data/models/store_student_class_enrollment/create_student_class_enrollment_model.dart';
import '../../data/models/store_student_class_enrollment/create_student_request_class_model.dart';
import '../bloc/class_room/class_room_bloc.dart';

class CreateStudentClasses extends StatefulWidget {
  final ReadStudentClassesResponseModel readStudentClassesState;

  const CreateStudentClasses({
    super.key,
    required this.readStudentClassesState,
  });

  @override
  State<CreateStudentClasses> createState() => _CreateStudentClassesState();
}

class _CreateStudentClassesState extends State<CreateStudentClasses> {
  late ReadStudentClassesResponseModel _currentReadStudentClassesState;

  int? _selectedGradeId;
  int? _selectedClassId;
  int? _selectedCategoryFeeId;

  bool _isStudentFreeCard = false;
  String? _selectedCustomFeeReason;

  final TextEditingController _customFeeController = TextEditingController();
  final TextEditingController _discountPercentageController =
      TextEditingController();
  final TextEditingController _discountReasonController =
      TextEditingController();

  final List<String> _customFeeReasons = const [
    'Special request',
    'Scholarship',
    'Sibling discount',
    'Transport issue',
    'Other',
  ];

  List<dynamic> _availableClasses = [];
  List<dynamic> _availableCategoryFees = [];

  @override
  void initState() {
    super.initState();
    _currentReadStudentClassesState = widget.readStudentClassesState;
    context.read<StudentGradeBloc>().add(GetStudentGradesEvent());
  }

  @override
  void dispose() {
    _customFeeController.dispose();
    _discountPercentageController.dispose();
    _discountReasonController.dispose();
    super.dispose();
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  String _formatDate(DateTime? value) {
    if (value == null) return '-';
    return "${value.year.toString().padLeft(4, '0')}-"
        "${value.month.toString().padLeft(2, '0')}-"
        "${value.day.toString().padLeft(2, '0')}";
  }

  String _getRefreshKey() {
    final student = _currentReadStudentClassesState.student;
    final customId = student?.customId?.toString().trim();

    if (customId != null && customId.isNotEmpty) return customId;

    return '';
  }

  void _refreshStudentClasses() {
    final refreshKey = _getRefreshKey();

    if (refreshKey.isEmpty) {
      _showSnack('Student ID not found');
      return;
    }

    context.read<ReadStudentClassesBloc>().add(
      ReadStudentClassesRequested(qrCode: refreshKey),
    );
  }

  void _resetSelectionsAfterGradeChange(int? gradeId) {
    setState(() {
      _selectedGradeId = gradeId;
      _selectedClassId = null;
      _selectedCategoryFeeId = null;
      _availableClasses = [];
      _availableCategoryFees = [];
    });
  }

  void _clearCustomFeeFields() {
    _customFeeController.clear();
    _selectedCustomFeeReason = null;
  }

  void _clearDiscountFields() {
    _discountPercentageController.clear();
    _discountReasonController.clear();
  }

  void _onFreeCardChanged(bool value) {
    setState(() {
      _isStudentFreeCard = value;
      if (value) {
        _clearCustomFeeFields();
        _clearDiscountFields();
      }
    });
  }

  StudentClassDataModel? _getSelectedClassData() {
    try {
      return _availableClasses.firstWhere((e) => e.classId == _selectedClassId)
          as StudentClassDataModel;
    } catch (_) {
      return null;
    }
  }

  String? _getSelectedClassName() {
    final selectedClass = _getSelectedClassData();
    if (selectedClass == null) return null;
    final medium = selectedClass.medium;
    return medium.isEmpty
        ? selectedClass.className
        : '${selectedClass.className} ($medium)';
  }

  String? _getSelectedCategoryName() {
    try {
      final selectedFee = _availableCategoryFees.firstWhere(
        (e) => e.classCategoryFeeId == _selectedCategoryFeeId,
      );
      return selectedFee.categoryName?.toString();
    } catch (_) {
      return null;
    }
  }

  double? _tryParseDouble(String value) {
    final parsed = double.tryParse(value.trim());
    if (parsed == null) return null;
    return parsed;
  }

  String _generateAutoNote() {
    final student = _currentReadStudentClassesState.student;
    final studentName = student?.initialName?.trim().isNotEmpty == true
        ? student!.initialName!.trim()
        : 'Student';

    final className = _getSelectedClassName() ?? '-';
    final categoryName = _getSelectedCategoryName() ?? '-';
    final gradeName = student?.gradeName ?? '-';

    final noteParts = <String>[
      'Student: $studentName',
      'Grade: $gradeName',
      'Class: $className',
      'Category: $categoryName',
    ];

    if (_isStudentFreeCard) {
      noteParts.add('Free card enabled');
    } else {
      final customFee = _tryParseDouble(_customFeeController.text);
      final discount = _tryParseDouble(_discountPercentageController.text);

      if (customFee != null) {
        noteParts.add('Custom fee: LKR ${customFee.toStringAsFixed(2)}');
      }

      if (_selectedCustomFeeReason != null &&
          _selectedCustomFeeReason!.trim().isNotEmpty) {
        noteParts.add('Custom fee reason: ${_selectedCustomFeeReason!.trim()}');
      }

      if (discount != null) {
        noteParts.add('Discount: ${discount.toStringAsFixed(2)}%');
      }

      if (_discountReasonController.text.trim().isNotEmpty) {
        noteParts.add(
          'Discount reason: ${_discountReasonController.text.trim()}',
        );
      }
    }

    return noteParts.join(' | ');
  }

  void _loadClassesForGrade(int? gradeId) {
    if (gradeId == null) return;

    context.read<ClassRoomBloc>().add(
      LoadClassesByGradeEvent(gradeId: gradeId.toString()),
    );
  }

  void _showViewClassesSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.65,
          maxChildSize: 0.96,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Container(
                    width: 52,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Student Enrolled Classes',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                      child: _buildViewClassesSection(),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStudentHeader(StudentMiniModel? student) {
    final imgUrl = student?.imgUrl;
    final name = student?.initialName ?? '-';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: AppColors.mediumShadow,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: Colors.white,
            backgroundImage: (imgUrl != null && imgUrl.isNotEmpty)
                ? NetworkImage(imgUrl)
                : null,
            child: (imgUrl == null || imgUrl.isEmpty)
                ? const Icon(Icons.person_rounded, size: 34)
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'ID: ${student?.customId ?? '-'}',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 2),
                Text(
                  'Grade: ${student?.gradeName ?? '-'}',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddClassSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: AppColors.softShadow,
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.playlist_add_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Assign New Class',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            _label('Select Grade'),
            const SizedBox(height: 8),
            BlocBuilder<StudentGradeBloc, StudentGradeState>(
              builder: (context, state) {
                if (state is StudentGradeLoading) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (state is StudentGradeLoaded) {
                  return DropdownButtonFormField<int>(
                    initialValue: _selectedGradeId,
                    isExpanded: true,
                    decoration: _fieldDecoration('Choose a grade'),
                    items: state.grades.map((grade) {
                      return DropdownMenuItem<int>(
                        value: grade.gradeId,
                        child: Text('Grade ${grade.gradeName}'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      _resetSelectionsAfterGradeChange(value);
                      _loadClassesForGrade(value);
                    },
                  );
                }

                if (state is StudentGradeError) {
                  return _errorBox(state.message);
                }

                return const SizedBox();
              },
            ),

            const SizedBox(height: 16),
            _label('Select Class'),
            const SizedBox(height: 8),
            BlocBuilder<ClassRoomBloc, ClassRoomState>(
              builder: (context, state) {
                final classItems = state is ClassRoomLoaded
                    ? state.response.data
                    : _availableClasses;

                if (_selectedGradeId == null) {
                  return DropdownButtonFormField<int>(
                    initialValue: null,
                    isExpanded: true,
                    decoration: _fieldDecoration('Select grade first'),
                    items: const [],
                    onChanged: null,
                  );
                }

                if (state is ClassRoomLoading) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (state is ClassRoomError) {
                  return _errorBox(state.message);
                }

                return DropdownButtonFormField<int>(
                  initialValue: _selectedClassId,
                  isExpanded: true,
                  itemHeight: null,
                  decoration: _fieldDecoration(
                    classItems.isEmpty
                        ? 'No classes available'
                        : 'Choose a class',
                  ),
                  items: classItems.map<DropdownMenuItem<int>>((classItem) {
                    final teacher = (classItem.teacherName ?? '').toString();

                    return DropdownMenuItem<int>(
                      value: classItem.classId,
                      child: SizedBox(
                        width: double.infinity,
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              TextSpan(
                                text:
                                    '${classItem.className} (${classItem.medium})\n',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: teacher,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: classItems.isEmpty
                      ? null
                      : (value) {
                          StudentClassDataModel? selected;

                          try {
                            selected = classItems.firstWhere(
                              (e) => e.classId == value,
                            );
                          } catch (_) {
                            selected = null;
                          }

                          setState(() {
                            _selectedClassId = value;
                            _selectedCategoryFeeId = null;
                            _availableCategoryFees =
                                selected?.categoryFees ?? [];
                          });
                        },
                );
              },
            ),

            const SizedBox(height: 16),
            _label('Select Category Fee'),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              initialValue: _selectedCategoryFeeId,
              isExpanded: true,
              decoration: _fieldDecoration(
                _selectedClassId == null
                    ? 'Select class first'
                    : _availableCategoryFees.isEmpty
                    ? 'No category fees available'
                    : 'Choose category fee',
              ),
              items: _availableCategoryFees.map<DropdownMenuItem<int>>((
                feeRow,
              ) {
                return DropdownMenuItem<int>(
                  value: feeRow.classCategoryFeeId,
                  child: Text('${feeRow.categoryName} - LKR ${feeRow.fee}'),
                );
              }).toList(),
              onChanged: _availableCategoryFees.isEmpty
                  ? null
                  : (value) {
                      setState(() {
                        _selectedCategoryFeeId = value;
                      });
                    },
            ),

            const SizedBox(height: 16),
            _label('Student Free Card'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xfff8fafc),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _isStudentFreeCard ? 'Enabled' : 'Disabled',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: _isStudentFreeCard
                            ? Colors.green
                            : Colors.grey.shade700,
                      ),
                    ),
                  ),
                  Switch(
                    value: _isStudentFreeCard,
                    activeColor: AppColors.primary,
                    onChanged: _onFreeCardChanged,
                  ),
                ],
              ),
            ),

            if (!_isStudentFreeCard) ...[
              const SizedBox(height: 16),
              _textField(
                controller: _customFeeController,
                label: 'Custom Fee',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: (value) {
                  if (value.trim().isNotEmpty) {
                    setState(_clearDiscountFields);
                  }
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedCustomFeeReason,
                isExpanded: true,
                decoration: _fieldDecoration('Custom Fee Reason'),
                items: _customFeeReasons.map((reason) {
                  return DropdownMenuItem<String>(
                    value: reason,
                    child: Text(reason),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCustomFeeReason = value;
                    if (value != null && value.trim().isNotEmpty) {
                      _clearDiscountFields();
                    }
                  });
                },
              ),
              const SizedBox(height: 12),
              _textField(
                controller: _discountPercentageController,
                label: 'Discount Percentage',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: (value) {
                  if (value.trim().isNotEmpty) {
                    setState(_clearCustomFeeFields);
                  }
                },
              ),
              const SizedBox(height: 12),
              _textField(
                controller: _discountReasonController,
                label: 'Discount Reason',
                onChanged: (value) {
                  if (value.trim().isNotEmpty) {
                    setState(_clearCustomFeeFields);
                  }
                },
              ),
            ],

            const SizedBox(height: 20),
            BlocBuilder<ClassRoomBloc, ClassRoomState>(
              builder: (context, state) {
                final isLoading = state is ClassRoomCreateLoading;

                return SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: isLoading
                        ? null
                        : () {
                            final studentId =
                                _currentReadStudentClassesState.student?.id;

                            if (studentId == null) {
                              _showSnack('Student not found');
                              return;
                            }

                            if (_selectedGradeId == null) {
                              _showSnack('Please select a grade');
                              return;
                            }

                            if (_selectedClassId == null) {
                              _showSnack('Please select a class');
                              return;
                            }

                            if (_selectedCategoryFeeId == null) {
                              _showSnack('Please select a category fee');
                              return;
                            }

                            if (!_isStudentFreeCard) {
                              final customFeeText = _customFeeController.text
                                  .trim();
                              final discountText = _discountPercentageController
                                  .text
                                  .trim();

                              final hasCustomFee = customFeeText.isNotEmpty;
                              final hasDiscount = discountText.isNotEmpty;

                              if (hasCustomFee && hasDiscount) {
                                _showSnack(
                                  'Custom fee and discount cannot be used together',
                                );
                                return;
                              }

                              if (hasCustomFee &&
                                  (_selectedCustomFeeReason == null ||
                                      _selectedCustomFeeReason!
                                          .trim()
                                          .isEmpty)) {
                                _showSnack('Please select custom fee reason');
                                return;
                              }

                              if (hasDiscount &&
                                  _discountReasonController.text
                                      .trim()
                                      .isEmpty) {
                                _showSnack('Please enter discount reason');
                                return;
                              }

                              if (hasDiscount &&
                                  double.tryParse(discountText) == null) {
                                _showSnack('Invalid discount percentage');
                                return;
                              }

                              if (hasCustomFee &&
                                  double.tryParse(customFeeText) == null) {
                                _showSnack('Invalid custom fee');
                                return;
                              }
                            }

                            final autoNote = _generateAutoNote();

                            final enrollmentModel =
                                CreateStudentClassEnrollmentModel(
                                  studentId: studentId,
                                  studentClassId: _selectedClassId!,
                                  classCategoryFeeId: _selectedCategoryFeeId!,
                                  isFreeCard: _isStudentFreeCard,
                                  customFee: _isStudentFreeCard
                                      ? null
                                      : (_customFeeController.text
                                                .trim()
                                                .isEmpty
                                            ? null
                                            : double.tryParse(
                                                _customFeeController.text
                                                    .trim(),
                                              )),
                                  customFeeReason: _isStudentFreeCard
                                      ? null
                                      : _selectedCustomFeeReason,
                                  discountPercentage: _isStudentFreeCard
                                      ? null
                                      : (_discountPercentageController.text
                                                .trim()
                                                .isEmpty
                                            ? null
                                            : double.tryParse(
                                                _discountPercentageController
                                                    .text
                                                    .trim(),
                                              )),
                                  discountReason: _isStudentFreeCard
                                      ? null
                                      : (_discountReasonController.text
                                                .trim()
                                                .isEmpty
                                            ? null
                                            : _discountReasonController.text
                                                  .trim()),
                                  note: autoNote,
                                );

                            context.read<ClassRoomBloc>().add(
                              CreateStudentClassEnrollmentEvent(
                                request: CreateStudentClassRequestModel(
                                  classEnrollmentModel: enrollmentModel,
                                ),
                              ),
                            );
                          },
                    icon: isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.add),
                    label: Text(isLoading ? 'Adding...' : 'Add Class'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewClassesSection() {
    final classes = _currentReadStudentClassesState.data;
    final activeClasses = classes.where((e) => e.isActive == true).toList();
    final inactiveClasses = classes.where((e) => e.isActive == false).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          title: 'Active Classes',
          count: activeClasses.length,
          color: Colors.green,
        ),
        const SizedBox(height: 10),
        activeClasses.isEmpty
            ? _buildEmptyCard('No active classes')
            : Column(
                children: activeClasses
                    .map((item) => _buildClassCard(item, true))
                    .toList(),
              ),
        const SizedBox(height: 20),
        _buildSectionTitle(
          title: 'Inactive Classes',
          count: inactiveClasses.length,
          color: Colors.red,
        ),
        const SizedBox(height: 10),
        inactiveClasses.isEmpty
            ? _buildEmptyCard('No inactive classes')
            : Column(
                children: inactiveClasses
                    .map((item) => _buildClassCard(item, false))
                    .toList(),
              ),
      ],
    );
  }

  Widget _buildSectionTitle({
    required String title,
    required int count,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$title ($count)',
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildClassCard(StudentClassModel item, bool isActive) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isActive
              ? Colors.green.withOpacity(0.20)
              : Colors.red.withOpacity(0.20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.className,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.green.withOpacity(0.12)
                      : Colors.red.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isActive ? 'Active' : 'Inactive',
                  style: TextStyle(
                    color: isActive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  tooltip: 'Edit Class',
                  icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                  onPressed: () {
                    _showSnack('Edit screen is not connected yet');
                  },
                ),
              ),
              const SizedBox(width: 6),
              Container(
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.red.withOpacity(0.10)
                      : Colors.green.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  tooltip: isActive ? 'Deactivate Class' : 'Activate Class',
                  icon: Icon(
                    isActive
                        ? Icons.toggle_off_outlined
                        : Icons.toggle_on_outlined,
                    color: isActive ? Colors.red : Colors.green,
                    size: 28,
                  ),
                  onPressed: () {
                    context.read<ClassRoomBloc>().add(
                      ToggleClassStatusEvent(enrollmentId: item.enrollmentId),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _infoChip('Class', item.className),
              _infoChip('Grade', item.gradeName),
              _infoChip('Category', item.categoryName),
            ],
          ),
          const SizedBox(height: 12),
          _infoRow(Icons.person_outline, 'Teacher', item.teacherName),
          _infoRow(
            Icons.payments_outlined,
            'Default Fee',
            'LKR ${item.defultFee.toStringAsFixed(2)}',
          ),
          _infoRow(
            Icons.price_check_outlined,
            'Final Fee',
            'LKR ${item.finalFee.toStringAsFixed(2)}',
          ),
          _infoRow(
            Icons.calendar_month_outlined,
            'Registered Date',
            _formatDate(item.registeredDate),
          ),
          _infoRow(
            Icons.local_activity_outlined,
            'Free Card',
            item.isFreeCard ? 'Yes' : 'No',
          ),
        ],
      ),
    );
  }

  Widget _infoChip(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xfff8fafc),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        '$title: $value',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade700),
          const SizedBox(width: 8),
          Text('$title: ', style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey.shade700),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCard(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 14,
        color: AppColors.dark,
      ),
    );
  }

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xfff8fafc),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    ValueChanged<String>? onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: _fieldDecoration(label),
    );
  }

  Widget _errorBox(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
      ),
      child: Text(
        message,
        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final student = _currentReadStudentClassesState.student;

    return MultiBlocListener(
      listeners: [
        BlocListener<ClassRoomBloc, ClassRoomState>(
          listener: (context, state) {
            if (state is ClassRoomCreateSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Class enrolled successfully'),
                  backgroundColor: Colors.green,
                ),
              );
              _refreshStudentClasses();
            }

            if (state is ClassRoomCreateError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }

            if (state is ClassRoomStatusToggleSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.response.message),
                  backgroundColor: Colors.green,
                ),
              );
              _refreshStudentClasses();
            }

            if (state is ClassRoomStatusToggleError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
        BlocListener<ReadStudentClassesBloc, ReadStudentClassesState>(
          listener: (context, state) {
            if (state is ReadStudentClassesSuccess) {
              setState(() {
                _currentReadStudentClassesState = state.response;
              });
            }

            if (state is ReadStudentClassesError) {
              _showSnack(state.message);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            'Student Classes',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showViewClassesSheet,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          icon: const Icon(Icons.visibility_rounded),
          label: const Text(
            'View Classes',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildStudentHeader(student),
              const SizedBox(height: 12),
              _buildAddClassSection(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
