import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/re_assign/re_assign_request_model.dart';
import '../bloc/student_card/student_card_bloc.dart';

class ReAssignCardPage extends StatefulWidget {
  final String oldQrCode;

  const ReAssignCardPage({super.key, required this.oldQrCode});

  @override
  State<ReAssignCardPage> createState() => _ReAssignCardPageState();
}

class _ReAssignCardPageState extends State<ReAssignCardPage> {
  final TextEditingController _newQrController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  final List<Map<String, dynamic>> _reasonList = [
    {
      'value': 'lost',
      'label': 'Lost',
      'color': Colors.red,
      'icon': Icons.search_off,
    },
    {
      'value': 'damaged',
      'label': 'Damaged',
      'color': Colors.orange,
      'icon': Icons.broken_image_outlined,
    },
    {
      'value': 'worn_out',
      'label': 'Worn Out',
      'color': Colors.deepOrange,
      'icon': Icons.auto_fix_off,
    },
    {
      'value': 'other',
      'label': 'Other',
      'color': Colors.grey,
      'icon': Icons.more_horiz,
    },
  ];

  String _selectedReason = 'damaged';

  @override
  void dispose() {
    _newQrController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  void _submitReAssign() {
    // Card QR codes are upper case (the server also upper-cases them).
    final newQrCode = _newQrController.text.trim().toUpperCase();

    if (newQrCode.isEmpty) {
      _showError('Please enter the new QR code.');
      return;
    }

    if (newQrCode == widget.oldQrCode.trim().toUpperCase()) {
      _showError('New QR code cannot be the same as the old QR code.');
      return;
    }

    final remarks = _remarksController.text.trim();

    context.read<StudentCardBloc>().add(
      ReAssignStudentCardEvent(
        request: ReAssignRequestModel(
          oldQrCode: widget.oldQrCode.trim().toUpperCase(),
          newQrCode: newQrCode,
          reason: _selectedReason,
          remarks: remarks.isEmpty ? null : remarks,
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _getReasonLabel() {
    final selected = _reasonList.firstWhere(
      (item) => item['value'] == _selectedReason,
      orElse: () => _reasonList.first,
    );

    return selected['label'] as String;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StudentCardBloc, StudentCardState>(
      listener: (context, state) {
        if (state is ReAssignStudentCardLoaded) {
          final newCode = state.response.data?.qrCode ?? '';

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                newCode.isNotEmpty
                    ? '${state.response.message} New card: $newCode. '
                        'Old card ${widget.oldQrCode} is now inactive.'
                    : state.response.message,
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );

          // true = re-assigned; the details page behind this one shows the
          // old card, so it closes too (see RegisterDetailsPage).
          Navigator.pop(context, true);
        }

        if (state is StudentCardError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: BlocBuilder<StudentCardBloc, StudentCardState>(
        builder: (context, state) {
          final isLoading = state is StudentCardLoading;

          return Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: AppBar(
              title: const Text(
                'Re-Assign Card',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: isLoading ? null : () => Navigator.pop(context),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(height: 1, color: Colors.grey[200]),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------------------------------------------------------
                  // HEADER
                  // ---------------------------------------------------------
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.blue.shade700, Colors.blue.shade500],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade200,
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
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.credit_card,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Card Re-Assignment',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Old QR Code:',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    widget.oldQrCode,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.blue.shade700,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ---------------------------------------------------------
                  // NEW QR CODE
                  // ---------------------------------------------------------
                  const Text(
                    'New Card',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade100,
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: TextFormField(
                        controller: _newQrController,
                        enabled: !isLoading,
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          labelText: 'New QR Code',
                          labelStyle: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: const Icon(
                            Icons.qr_code_2,
                            color: Colors.blue,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                          hintText: 'Enter new available QR code',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Enter the QR code of an available card.',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 20),

                  // ---------------------------------------------------------
                  // REPLACEMENT REASON
                  // ---------------------------------------------------------
                  const Text(
                    'Replacement Reason',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade100,
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: DropdownButtonFormField<String>(
                        value: _selectedReason,
                        decoration: InputDecoration(
                          labelText: 'Reason',
                          labelStyle: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: Icon(
                            Icons.label_important_outline,
                            color: Colors.blue.shade600,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        items: _reasonList.map((reason) {
                          return DropdownMenuItem<String>(
                            value: reason['value'] as String,
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: reason['color'] as Color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  reason['label'] as String,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: isLoading
                            ? null
                            : (value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedReason = value;
                                  });
                                }
                              },
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.grey.shade600,
                          size: 30,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ---------------------------------------------------------
                  // REMARKS
                  // ---------------------------------------------------------
                  const Text(
                    'Remarks',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade100,
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: TextFormField(
                        controller: _remarksController,
                        enabled: !isLoading,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: 'Remarks',
                          labelStyle: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: const Icon(
                            Icons.comment_outlined,
                            color: Colors.blue,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                          hintText: 'Add any remarks or notes...',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ---------------------------------------------------------
                  // SUMMARY
                  // ---------------------------------------------------------
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade700),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'The current card will be deactivated and the new card will be assigned to this student. '
                            'Reason: ${_getReasonLabel()}.',
                            style: TextStyle(
                              color: Colors.blue.shade800,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ---------------------------------------------------------
                  // RE-ASSIGN BUTTON
                  // ---------------------------------------------------------
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submitReAssign,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.blue.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'RE-ASSIGN CARD',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ---------------------------------------------------------
                  // CANCEL BUTTON
                  // ---------------------------------------------------------
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: isLoading
                          ? null
                          : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'CANCEL',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
