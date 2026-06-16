import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/students_model.dart';
import '../bloc/student_classes/student_classes_bloc.dart';
import 'student_view_classes.dart';

class SingleStudentViewPage extends StatelessWidget {
  final StudentModel student;

  const SingleStudentViewPage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return BlocListener<StudentClassesBloc, StudentClassesState>(
      listener: (context, state) {
        if (state is StudentClassesLoaded) {
          final classes = state.response.data;

          if (classes.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No classes found for this student'),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StudentViewClasses(
                  studentId: student.id!,
                  studentName: student.initialName,
                  customId: student.permanentQrActive == true
                      ? student.customId ?? "N/A"
                      : student.temporaryQrCode ?? "N/A",
                ),
              ),
            );
          }
        } else if (state is StudentClassesError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },

      child: Scaffold(
        backgroundColor: AppColors.background,

        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,

          title: const Text(
            'Student Profile',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),

        floatingActionButton: FloatingActionButton.extended(
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,

          onPressed: () {
            if (student.id != null) {
              context.read<StudentClassesBloc>().add(
                FetchStudentClasses(studentId: student.id!),
              );
            }
          },

          icon: const Icon(Icons.class_rounded),

          label: const Text(
            'View Classes',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            children: [
              // HERO CARD
              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(24),

                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: AppColors.mediumShadow,
                ),

                child: Column(
                  children: [
                    // IMAGE
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,

                      backgroundImage:
                          (student.imgUrl != null && student.imgUrl!.isNotEmpty)
                          ? NetworkImage(student.imgUrl!)
                          : null,

                      child: (student.imgUrl == null || student.imgUrl!.isEmpty)
                          ? const Icon(
                              Icons.person_rounded,
                              size: 60,
                              color: AppColors.primary,
                            )
                          : null,
                    ),

                    const SizedBox(height: 18),

                    // NAME
                    Text(
                      student.initialName,
                      textAlign: TextAlign.center,

                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      student.fullName ?? '',
                      textAlign: TextAlign.center,

                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 18),

                    // CHIPS
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,

                      children: [
                        _buildChip(
                          icon: Icons.school_rounded,
                          text: student.grade?.gradeName ?? 'N/A',
                        ),

                        _buildChip(
                          icon: Icons.category_rounded,
                          text: student.classType ?? 'N/A',
                        ),

                        _buildChip(
                          icon: Icons.qr_code_rounded,
                          text: student.customId ?? 'N/A',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // STATUS CARDS
              Row(
                children: [
                  Expanded(
                    child: _buildStatusCard(
                      title: 'Status',
                      value: student.isActive == true ? 'Active' : 'Inactive',

                      icon: student.isActive == true
                          ? Icons.verified_rounded
                          : Icons.cancel_rounded,

                      color: student.isActive == true
                          ? AppColors.success
                          : AppColors.danger,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _buildStatusCard(
                      title: 'Admission',
                      value: student.admission == true
                          ? 'Completed'
                          : 'Pending',

                      icon: student.admission == true
                          ? Icons.payments_rounded
                          : Icons.pending_rounded,

                      color: student.admission == true
                          ? AppColors.primary
                          : AppColors.warning,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              _buildSection(
                title: 'Contact Information',
                icon: Icons.call_rounded,

                children: [
                  _infoRow('Mobile', student.mobile ?? 'N/A'),

                  _infoRow('WhatsApp', student.whatsappMobile ?? 'N/A'),

                  _infoRow('Email', student.email ?? 'N/A'),
                ],
              ),

              _buildSection(
                title: 'Personal Details',
                icon: Icons.badge_rounded,

                children: [
                  _infoRow('Full Name', student.fullName ?? 'N/A'),

                  _infoRow('Gender', student.gender),

                  _infoRow('NIC', student.nic ?? 'N/A'),

                  _infoRow('School', student.studentSchool ?? 'N/A'),
                ],
              ),

              _buildSection(
                title: 'Address',
                icon: Icons.location_on_rounded,

                children: [
                  _infoRow('Address 1', student.address1 ?? 'N/A'),

                  _infoRow('Address 2', student.address2 ?? 'N/A'),

                  _infoRow('Address 3', student.address3 ?? 'N/A'),
                ],
              ),

              _buildSection(
                title: 'Guardian Information',
                icon: Icons.family_restroom_rounded,

                children: [
                  _infoRow(
                    'Guardian',
                    '${student.guardianFname ?? ''} ${student.guardianLname ?? ''}',
                  ),

                  _infoRow('Mobile', student.guardianMobile),

                  _infoRow('NIC', student.guardianNic ?? 'N/A'),
                ],
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.15),

        borderRadius: BorderRadius.circular(100),

        border: Border.all(color: Colors.white.withOpacity(.2)),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Icon(icon, color: Colors.white, size: 16),

          const SizedBox(width: 6),

          Text(
            text,

            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.softShadow,
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(
              color: color.withOpacity(.1),
              borderRadius: BorderRadius.circular(14),
            ),

            child: Icon(icon, color: color),
          ),

          const SizedBox(height: 14),

          Text(
            title,

            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            value,

            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: AppColors.softShadow,
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),

                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(.08),
                  borderRadius: BorderRadius.circular(14),
                ),

                child: Icon(icon, color: AppColors.primary),
              ),

              const SizedBox(width: 12),

              Text(
                title,

                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          SizedBox(
            width: 110,

            child: Text(
              title,

              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              value,

              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
