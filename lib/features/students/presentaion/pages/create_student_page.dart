import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/printer_service.dart';
import '../../../student_grade/presentation/bloc/student_grade/student_grade_bloc.dart';
import '../../data/models/students_model.dart';
import '../bloc/students/students_bloc.dart';
import '../widgets/admission_dialog.dart';
import '../widgets/admission_receipt_print.dart';

class CreateStudentPage extends StatefulWidget {
  const CreateStudentPage({super.key});

  @override
  State<CreateStudentPage> createState() => _CreateStudentPageState();
}

class _CreateStudentPageState extends State<CreateStudentPage> {
  final PrinterService _printerService = PrinterService();
  final _formKey = GlobalKey<FormState>();

  final _temporaryQrCodeController = TextEditingController();
  final _quickImageIdController = TextEditingController();
  final _lnameController = TextEditingController();
  final _guardianMobileController = TextEditingController();

  int? _selectedGradeId;
  String _selectedGender = 'male';
  bool _isLoading = false;
  int? _selectedAdmissionId;

  @override
  void initState() {
    super.initState();
    context.read<StudentGradeBloc>().add(GetStudentGradesEvent());
  }

  @override
  void dispose() {
    _temporaryQrCodeController.dispose();
    _quickImageIdController.dispose();
    _lnameController.dispose();
    _guardianMobileController.dispose();
    super.dispose();
  }

  Future<void> _openImageCapture() async {
    final result = await Navigator.pushNamed(
      context,
      '/image_capture',
      arguments: {'registered': true},
    );

    if (!mounted) return;

    if (result is String && result.trim().isNotEmpty) {
      setState(() {
        _quickImageIdController.text = result.trim();
      });
    }
  }

  Future<void> _showAdmissionDialog() async {
    final result = await showDialog<AdmissionDialogResult>(
      context: context,
      builder: (_) => const AdmissionDialog(),
    );

    if (result == null) {
      return;
    }

    setState(() {
      _selectedAdmissionId = result.admissionId;
    });

    _submitStudent();
  }

  void _submitStudent() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedGradeId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select grade')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final quickImageText = _quickImageIdController.text.trim();

    final student = StudentModel(
      temporaryQrCode: 'TMP${_temporaryQrCodeController.text.trim()}',
      quickImageId: quickImageText.isEmpty ? null : quickImageText,
      initialName: _lnameController.text.trim(),
      gender: _selectedGender,
      guardianMobile: _guardianMobileController.text.trim(),
      gradeId: _selectedGradeId!,
      admission: _selectedAdmissionId,
    );

    context.read<StudentsBloc>().add(CreateStudentEvent(student: student));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentsBloc, StudentsState>(
      listener: (context, state) {
        if (state is StudentsLoading) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is StudentsCreated) {
          setState(() {
            _isLoading = false;
          });

          final payment = state.response.admissionPayment;

          if (payment != null) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return AlertDialog(
                  title: const Text('Admission Receipt'),

                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Receipt No : ${payment.receiptNumber}'),

                      const SizedBox(height: 8),

                      Text('Student ID : ${state.response.student.customId}'),

                      const SizedBox(height: 8),

                      Text('Admission : ${payment.admissionName}'),

                      const SizedBox(height: 8),

                      Text('Amount : Rs.${payment.amount}'),

                      const SizedBox(height: 8),

                      Text('Method : ${payment.paymentMethod}'),

                      const SizedBox(height: 8),

                      Text('Status : ${payment.status}'),
                    ],
                  ),

                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);

                        _clearForm();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColors.success,
                            content: Text(
                              'Student created successfully (ID: ${state.response.student.customId})',
                            ),
                          ),
                        );
                      },
                      child: const Text('Close'),
                    ),

                    ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          await AdmissionReceiptPrint.printReceipt(
                            printerService: _printerService,

                            instituteName: 'Minipalasa Education Center',

                            receiptNumber: payment.receiptNumber,

                            studentName: state.response.student.initialName,

                            studentId: state.response.student.customId
                                .toString(),

                            admissionName: payment.admissionName,

                            amount: double.parse(payment.amount),

                            paymentMethod: payment.paymentMethod,

                            paidAt: payment.paidAt,
                          );

                          if (context.mounted) {
                            Navigator.pop(context);

                            _clearForm();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Receipt printed successfully'),
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Print failed: $e')),
                          );
                        }
                      },
                      icon: const Icon(Icons.print),
                      label: const Text('Print'),
                    ),
                  ],
                );
              },
            );
          } else {
            _clearForm();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: AppColors.success,
                content: Text(
                  'Student created successfully (ID: ${state.response.student.customId})',
                ),
              ),
            );
          }
        } else if (state is StudentsError) {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.danger,
              content: Text(state.message),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            title: const Text(
              'Create Student',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          body: Stack(
            children: [
              Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(26),
                      decoration: BoxDecoration(
                        gradient: AppColors.heroGradient,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: AppColors.largeShadow,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.14),
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: const Icon(
                              Icons.person_add_alt_1_rounded,
                              color: Colors.white,
                              size: 34,
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Student Registration',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Register and manage student records easily',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(.82),
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: AppColors.softShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 18),

                          _buildTextField(
                            controller: _temporaryQrCodeController,
                            label: 'Temporary QR Code',
                            icon: Icons.qr_code_scanner_rounded,
                            prefixText: 'TMP',
                          ),

                          const SizedBox(height: 18),

                          _buildTextField(
                            controller: _quickImageIdController,
                            label: 'QuickImage Id',
                            icon: Icons.image_rounded,
                            requiredField: false,
                            customValidator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return null;
                              }

                              final regex = RegExp(r'^QP-\d{3}$');
                              if (!regex.hasMatch(value.trim())) {
                                return 'Use format like QP-001';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 14),

                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: _isLoading ? null : _openImageCapture,
                              icon: const Icon(Icons.add_a_photo_rounded),
                              label: const Text('Add Image'),
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
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          _buildTextField(
                            controller: _lnameController,
                            label: 'Initial Name',
                            icon: Icons.badge_rounded,
                          ),

                          const SizedBox(height: 18),

                          DropdownButtonFormField<String>(
                            initialValue: _selectedGender,
                            decoration: _inputDecoration(
                              label: 'Gender',
                              icon: Icons.wc_rounded,
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'male',
                                child: Text('Male'),
                              ),
                              DropdownMenuItem(
                                value: 'female',
                                child: Text('Female'),
                              ),
                              DropdownMenuItem(
                                value: 'other',
                                child: Text('Other'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value == null) return;
                              setState(() {
                                _selectedGender = value;
                              });
                            },
                          ),

                          const SizedBox(height: 18),

                          _buildTextField(
                            controller: _guardianMobileController,
                            label: 'Guardian Mobile',
                            icon: Icons.phone_rounded,
                            keyboardType: TextInputType.phone,
                          ),

                          const SizedBox(height: 18),

                          BlocBuilder<StudentGradeBloc, StudentGradeState>(
                            builder: (context, state) {
                              if (state is StudentGradeLoading) {
                                return const Padding(
                                  padding: EdgeInsets.all(18),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              if (state is StudentGradeLoaded) {
                                return DropdownButtonFormField<int>(
                                  value: _selectedGradeId,
                                  decoration: _inputDecoration(
                                    label: 'Select Grade',
                                    icon: Icons.class_rounded,
                                  ),
                                  items: state.grades.map((g) {
                                    return DropdownMenuItem(
                                      value: g.gradeId,
                                      child: Text('Grade ${g.gradeName}'),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedGradeId = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please select grade';
                                    }
                                    return null;
                                  },
                                );
                              }

                              if (state is StudentGradeError) {
                                return Text(
                                  state.message,
                                  style: const TextStyle(
                                    color: AppColors.danger,
                                  ),
                                );
                              }

                              return const SizedBox();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                bottom: 18,
                left: 18,
                right: 18,
                child: SafeArea(
                  child: SizedBox(
                    height: 60,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _showAdmissionDialog,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.save_rounded),
                      label: Text(
                        _isLoading ? 'Creating Student...' : 'Create Student',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              if (_isLoading)
                Container(
                  color: Colors.black.withOpacity(.25),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    TextInputType? keyboardType,
    String? prefixText,
    bool requiredField = true,
    String? Function(String?)? customValidator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: TextCapitalization.words,
      onChanged: (value) {
        if (label == 'Initial Name') {
          final capitalized = value
              .split(' ')
              .map((word) {
                if (word.isEmpty) return '';
                return word[0].toUpperCase() + word.substring(1).toLowerCase();
              })
              .join(' ');

          if (value != capitalized) {
            controller.value = TextEditingValue(
              text: capitalized,
              selection: TextSelection.collapsed(offset: capitalized.length),
            );
          }
        }
      },
      decoration: _inputDecoration(
        label: label,
        icon: icon,
        prefixText: prefixText,
      ),
      validator:
          customValidator ??
          (value) {
            if (!requiredField) {
              return null;
            }

            if (value == null || value.trim().isEmpty) {
              return 'Required field';
            }

            return null;
          },
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    IconData? icon,
    String? prefixText,
  }) {
    return InputDecoration(
      labelText: label,
      prefixText: prefixText,
      filled: true,
      fillColor: AppColors.background,
      prefixIcon: icon != null ? Icon(icon) : null,
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
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
    );
  }

  void _clearForm() {
    _temporaryQrCodeController.clear();
    _lnameController.clear();
    _guardianMobileController.clear();
    _quickImageIdController.clear();

    setState(() {
      _selectedGradeId = null;
      _selectedAdmissionId = null;
      _selectedGender = 'male';
    });
  }
}

class AdmissionDialogResult {
  final bool submitted;
  final int? admissionId;

  AdmissionDialogResult({required this.submitted, this.admissionId});
}
