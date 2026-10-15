import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../bloc/students/students_bloc.dart';

class StudentCustomIdPage extends StatefulWidget {
  final String token;

  const StudentCustomIdPage({super.key, required this.token});

  @override
  State<StudentCustomIdPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentCustomIdPage> {
  final TextEditingController _searchController = TextEditingController();
  String? selectedMonth;

  @override
  void initState() {
    super.initState();
    // Initial load → current month data
    final now = DateTime.now();
    selectedMonth = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    _onSearch();
  }

  void _onSearch() {
    context.read<StudentsBloc>().add(
      FetchStudentCustomIds(
        token: widget.token,
        search: _searchController.text,
        month: selectedMonth,
      ),
    );
  }

  Future<void> _pickMonth() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 1),
      initialDatePickerMode: DatePickerMode.year,
    );

    if (picked != null) {
      // Only take year and month
      setState(() {
        selectedMonth =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}';
      });
      _onSearch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students Custom IDs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareStudentsPdf(
              context,
              selectedMonth,
            ), // <-- notice the () =>
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Search bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search by name or ID',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                  onSubmitted: (_) => _onSearch(),
                ),

                const SizedBox(height: 12),

                // Month Picker
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.blue.shade600,
                  ),
                  onPressed: _pickMonth,
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    selectedMonth != null
                        ? DateFormat.yMMM().format(
                            DateTime.parse('${selectedMonth!}-01'),
                          )
                        : 'Select Month',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: BlocBuilder<StudentsBloc, StudentsState>(
              builder: (context, state) {
                if (state is StudentsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is StudentCustomIdLoaded) {
                  final students = state.studentCustomIdModel;
                  if (students.isEmpty) {
                    return const Center(child: Text('No students found'));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final student = students[index];
                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundImage: NetworkImage(student.imgUrl),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${student.fname} ${student.lname}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Grade: ${student.gradeName}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  student.customId,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is StudentsError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _shareStudentsPdf(
    BuildContext context,
    String? selectedMonth,
  ) async {
    final state = context.read<StudentsBloc>().state;
    if (state is! StudentCustomIdLoaded || state.studentCustomIdModel.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No students to share')));
      return;
    }

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return [
            // Header
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'EDU NEXORA',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  'Student Custom IDs List',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 2),
                pw.Text(
                  selectedMonth != null
                      ? DateFormat.yMMMM().format(
                          DateTime.parse('$selectedMonth-01'),
                        )
                      : '',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontStyle: pw.FontStyle.italic,
                  ),
                ),
                pw.SizedBox(height: 12),
                pw.Divider(color: PdfColor.fromInt(0xFF000000)),
                pw.SizedBox(height: 12),
              ],
            ),

            // Table with students
            pw.TableHelper.fromTextArray(
              headers: ['ID', 'Name', 'Grade', 'Custom ID'],
              data: List<List<String>>.generate(
                state.studentCustomIdModel.length,
                (index) {
                  final student = state.studentCustomIdModel[index];
                  return [
                    '${index + 1}', // sequential ID
                    '${student.fname} ${student.lname}',
                    student.gradeName,
                    student.customId,
                  ];
                },
              ),
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 14,
              ),
              cellStyle: pw.TextStyle(fontSize: 12),
              headerDecoration: pw.BoxDecoration(
                color: PdfColor.fromInt(0xFFEEEEEE),
              ),
              cellAlignment: pw.Alignment.centerLeft,
              columnWidths: {
                0: const pw.FlexColumnWidth(1), // ID
                1: const pw.FlexColumnWidth(3), // Name
                2: const pw.FlexColumnWidth(1), // Grade
                3: const pw.FlexColumnWidth(2), // Custom ID
              },
              border: pw.TableBorder.all(
                width: 0.5,
                color: PdfColor.fromInt(0xFFCCCCCC),
              ),
            ),
          ];
        },
      ),
    );

    // Save PDF
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/students_custom_ids.pdf');
    await file.writeAsBytes(await pdf.save());

    // Share PDF via WhatsApp or other apps
    await SharePlus.instance.share(
      ShareParams(
        text: 'Here is the student custom IDs list for $selectedMonth',
        files: [XFile(file.path)],
      ),
    );
  }
}
