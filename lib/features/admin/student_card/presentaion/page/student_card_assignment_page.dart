import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../data/model/assignment/assignment_card_request_model.dart';
import '../../data/model/assignment/assignment_current_card_model.dart';
import '../../data/model/assignment/assignment_search_student_response_model.dart';
import '../../data/model/re_assign/re_assign_request_model.dart';
import '../bloc/student_card/student_card_bloc.dart';

class StudentCardAssignmentPage extends StatefulWidget {
  final AssignmentSearchStudentResponseModel response;

  const StudentCardAssignmentPage({super.key, required this.response});

  @override
  State<StudentCardAssignmentPage> createState() =>
      _StudentCardAssignmentPageState();
}

class _StudentCardAssignmentPageState extends State<StudentCardAssignmentPage> {
  final TextEditingController _cardController = TextEditingController();

  final TextEditingController _remarksController = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  bool _isScanning = false;

  String _selectedReason = 'damaged';

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

  final MobileScannerController _scannerController = MobileScannerController(
    autoStart: false,
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _cardController.dispose();
    _remarksController.dispose();
    _focusNode.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _startScanner() async {
    setState(() {
      _isScanning = true;
    });

    try {
      await _scannerController.start();
    } catch (e) {
      setState(() {
        _isScanning = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to start camera'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _stopScanner() async {
    try {
      await _scannerController.stop();
    } catch (_) {
      // Handle silently
    }

    if (mounted) {
      setState(() {
        _isScanning = false;
      });
    }
  }

  void _handleScanResult(String value) {
    if (value.trim().isEmpty) return;

    _stopScanner();

    setState(() {
      _cardController.text = value.trim().toUpperCase();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('QR Code scanned: ${value.trim().toUpperCase()}'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _submitCardAction(AssignmentCurrentCardModel? currentCard) {
    final qrCode = _cardController.text.trim();

    if (qrCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please scan or enter card QR.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    /*
     * ------------------------------------------------------------
     * NO CURRENT CARD
     * ------------------------------------------------------------
     *
     * Normal assignment
     */
    if (currentCard == null) {
      context.read<StudentCardBloc>().add(
        AssignStudentCardEvent(
          request: AssignmentCardRequestModel(
            studentId: widget.response.data.student.id,
            cardQrCode: qrCode,
          ),
        ),
      );

      return;
    }

    /*
     * ------------------------------------------------------------
     * CURRENT CARD EXISTS
     * ------------------------------------------------------------
     *
     * Re-assignment
     */
    final oldQrCode = currentCard.qrCode.trim();

    if (oldQrCode.toUpperCase() == qrCode.toUpperCase()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'New card QR cannot be the same as the current card QR.',
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );

      return;
    }

    final remarks = _remarksController.text.trim();

    context.read<StudentCardBloc>().add(
      ReAssignStudentCardEvent(
        request: ReAssignRequestModel(
          oldQrCode: oldQrCode,
          newQrCode: qrCode,
          reason: _selectedReason,
          remarks: remarks.isEmpty ? null : remarks,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final student = widget.response.data.student;
    final currentCard = widget.response.data.currentCard;

    return BlocConsumer<StudentCardBloc, StudentCardState>(
      listener: (context, state) {
        /*
         * --------------------------------------------------------
         * NORMAL ASSIGN SUCCESS
         * --------------------------------------------------------
         */
        if (state is AssignStudentCardLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.response.message),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );

          Navigator.pop(context, true);
        }

        /*
         * --------------------------------------------------------
         * RE-ASSIGN SUCCESS
         * --------------------------------------------------------
         */
        if (state is ReAssignStudentCardLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.response.message),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );

          Navigator.pop(context, true);
        }

        /*
         * --------------------------------------------------------
         * ERROR
         * --------------------------------------------------------
         */
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
      builder: (context, state) {
        final loading = state is StudentCardLoading;

        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Student Card Assignment',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                elevation: 0,
                centerTitle: false,
              ),
              body: _buildBody(
                context,
                studentName: student.initialName,
                studentId: student.customId,
                grade: student.grade.gradeName,
                image: student.imgUrl ?? '',
                currentCard: currentCard,
              ),
            ),

            /*
             * ------------------------------------------------------
             * LOADING OVERLAY
             * ------------------------------------------------------
             */
            if (loading)
              Container(
                color: Colors.black.withOpacity(0.4),
                child: const Center(
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text(
                            'Processing...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            /*
             * ------------------------------------------------------
             * QR SCANNER
             * ------------------------------------------------------
             */
            if (_isScanning)
              Container(
                color: Colors.black.withOpacity(0.6),
                child: Center(
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: MobileScanner(
                              controller: _scannerController,
                              onDetect: (capture) {
                                if (capture.barcodes.isEmpty) {
                                  return;
                                }

                                final value = capture.barcodes.first.rawValue;

                                if (value == null || value.trim().isEmpty) {
                                  return;
                                }

                                _handleScanResult(value);
                              },
                            ),
                          ),

                          Center(
                            child: IgnorePointer(
                              child: Container(
                                width: 250,
                                height: 250,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.8),
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),

                          Positioned(
                            bottom: 40,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Column(
                                children: [
                                  const Text(
                                    'Scan QR Code',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Place the QR code inside the box',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton.icon(
                                    onPressed: _stopScanner,
                                    icon: const Icon(Icons.close),
                                    label: const Text('Cancel Scan'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ],
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
      },
    );
  }

  Widget _buildBody(
    BuildContext context, {
    required String studentName,
    required String studentId,
    required String grade,
    required String image,
    required AssignmentCurrentCardModel? currentCard,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _studentCard(
            context,
            studentName: studentName,
            studentId: studentId,
            grade: grade,
            image: image,
            currentCard: currentCard,
          ),

          const SizedBox(height: 20),

          _searchCardWidget(),

          /*
           * Replacement reason + remarks
           *
           * Only show when student already has an active card.
           */
          if (currentCard != null) ...[
            const SizedBox(height: 20),
            _buildReplacementReason(),
            const SizedBox(height: 16),
            _buildRemarks(),
          ],

          const SizedBox(height: 24),

          _buildAssignButton(currentCard),

          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _studentCard(
    BuildContext context, {
    required String studentName,
    required String studentId,
    required String grade,
    required String image,
    required AssignmentCurrentCardModel? currentCard,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer,
                  backgroundImage: image.isNotEmpty
                      ? NetworkImage(image)
                      : null,
                  child: image.isEmpty
                      ? Text(
                          studentName.isNotEmpty
                              ? studentName[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        )
                      : null,
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        studentName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),

                      Row(
                        children: [
                          Icon(
                            Icons.badge,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'ID: $studentId',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 2),

                      Row(
                        children: [
                          Icon(
                            Icons.school,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Grade: $grade',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            const Divider(height: 1),

            const SizedBox(height: 16),

            _buildCurrentCardWidget(currentCard),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentCardWidget(AssignmentCurrentCardModel? currentCard) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.credit_card,
              size: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Current Card Status',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        if (currentCard == null)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 18,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(width: 8),
                Text(
                  'No Active Card',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.credit_card,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Card #: ${currentCard.cardNumber}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    Icon(
                      Icons.qr_code,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'QR: ${currentCard.qrCode}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(currentCard.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    currentCard.status.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _searchCardWidget() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.search,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Search Available Card',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              'Scan or enter the QR code of the card you want to assign.',
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _cardController,
              focusNode: _focusNode,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                hintText: 'Scan or Enter Card QR',
                prefixIcon: Icon(
                  Icons.qr_code_scanner,
                  color: Theme.of(context).colorScheme.primary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.qr_code_scanner,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: _isScanning ? null : _startScanner,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReplacementReason() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.sync_alt,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Replacement Reason',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            DropdownButtonFormField<String>(
              value: _selectedReason,
              decoration: InputDecoration(
                labelText: 'Reason',
                prefixIcon: const Icon(Icons.label_important_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedReason = value;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRemarks() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.comment_outlined,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Remarks',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            TextField(
              controller: _remarksController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Add any remarks or notes...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignButton(AssignmentCurrentCardModel? currentCard) {
    final hasCurrentCard = currentCard != null;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          _submitCardAction(currentCard);
        },
        icon: Icon(hasCurrentCard ? Icons.sync_alt : Icons.credit_card),
        label: Text(
          hasCurrentCard ? 'Re-Assign Student Card' : 'Assign Student Card',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size(double.infinity, 56),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;

      case 'inactive':
        return Colors.orange;

      case 'assigned':
        return Colors.blue;

      case 'expired':
        return Colors.red;

      case 'lost':
        return Colors.grey;

      default:
        return Colors.grey;
    }
  }
}
