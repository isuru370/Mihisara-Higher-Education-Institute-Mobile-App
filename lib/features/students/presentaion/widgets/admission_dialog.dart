import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../admission/presentaion/bloc/admission/admission_bloc.dart';
import '../pages/create_student_page.dart';

class AdmissionDialog extends StatefulWidget {
  const AdmissionDialog({super.key});

  @override
  State<AdmissionDialog> createState() => _AdmissionDialogState();
}

class _AdmissionDialogState extends State<AdmissionDialog> {
  int? selectedAdmissionId;

  @override
  void initState() {
    super.initState();

    context.read<AdmissionBloc>().add(FetchAdmissionDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Admission'),

      content: BlocBuilder<AdmissionBloc, AdmissionState>(
        builder: (context, state) {
          if (state is AdmissionLoading) {
            return const SizedBox(
              height: 350,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is AdmissionLoaded) {
            final admissions = state.admissionData.data;

            return SizedBox(
              width: 350,
              height: 400,
              child: ListView.separated(
                itemCount: admissions.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, thickness: 1),
                itemBuilder: (context, index) {
                  final admission = admissions[index];

                  return ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(
                      admission.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text('Rs. ${admission.amount}'),
                    trailing: selectedAdmissionId == admission.id
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : null,
                    onTap: () {
                      setState(() {
                        selectedAdmissionId = admission.id;
                      });
                    },
                  );
                },
              ),
            );
          }

          if (state is AdmissionError) {
            return Text(state.message);
          }

          return const SizedBox();
        },
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
            Navigator.pop(
              context,
              AdmissionDialogResult(
                submitted: true,
                admissionId: selectedAdmissionId,
              ),
            );
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
