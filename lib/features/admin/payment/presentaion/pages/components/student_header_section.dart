import 'package:flutter/material.dart';

import '../../../../qr/data/model/read_payment/read_student_payment_model.dart';

class StudentHeader extends StatelessWidget {
  final ReadStudentPaymentModel student;

  const StudentHeader({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    final imageUrl = student.imgUrl ?? '';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            offset: const Offset(0, 4),
            color: Colors.black.withOpacity(0.06),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: imageUrl.isNotEmpty
                ? NetworkImage(imageUrl)
                : null,
            child: imageUrl.isEmpty ? const Icon(Icons.person, size: 30) : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.initialName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text('Custom ID: ${student.customId}'),
                Text('Guardian: ${student.guardianMobile}'),
                if ((student.mobile ?? '').trim().isNotEmpty)
                  Text('Mobile: ${student.mobile}'),
                const SizedBox(height: 6),
                _qrTypeChip(student.qrType),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qrTypeChip(String value) {
    final isTemporary = value.toLowerCase() == 'temporary';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isTemporary ? Colors.amber.shade100 : Colors.blue.shade100,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        value.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: isTemporary ? Colors.amber.shade900 : Colors.blue.shade900,
        ),
      ),
    );
  }
}