import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_datetime.dart';
import '../../../institute_hall/presentaion/bloc/institute_hall/institute_hall_bloc.dart';
import '../../data/model/class_schedule_model.dart';
import '../../data/model/update/update_class_schedule_request_model.dart';
import '../bloc/class_schedule/class_schedule_bloc.dart';

class ClassScheduleUpdatePage extends StatefulWidget {
  final ClassScheduleModel schedule;
  final String className;
  final int classId;
  final int classCategoryFeeId;

  const ClassScheduleUpdatePage({
    super.key,
    required this.schedule,
    required this.className,
    required this.classId,
    required this.classCategoryFeeId,
  });

  @override
  State<ClassScheduleUpdatePage> createState() =>
      _ClassScheduleUpdatePageState();
}

class _ClassScheduleUpdatePageState extends State<ClassScheduleUpdatePage> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  late TextEditingController _dateController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  late TextEditingController _noteController;

  int? _selectedHallId;
  late DateTime _selectedDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  String _dayOfWeek = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Initialize dates in initState
    _selectedDate = AppDateTime.parseToLocal(widget.schedule.classDate);
    _startTime = _parseTimeOfDay(widget.schedule.startTime);
    _endTime = _parseTimeOfDay(widget.schedule.endTime);

    _initializeControllers();
    _updateDayOfWeek(_selectedDate);
    _selectedHallId = widget.schedule.hall.id;
    // Load halls
    context.read<InstituteHallBloc>().add(const LoadInstituteHalls());
  }

  // Helper method to parse time string to TimeOfDay
  TimeOfDay _parseTimeOfDay(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize time texts here after context is available
    if (_startTimeController.text.isEmpty) {
      _updateStartTimeText(_startTime);
      _updateEndTimeText(_endTime);
    }
  }

  void _initializeControllers() {
    _dateController = TextEditingController();
    _startTimeController = TextEditingController();
    _endTimeController = TextEditingController();
    _noteController = TextEditingController(text: widget.schedule.note);

    _updateDateText(_selectedDate);
  }

  void _updateDateText(DateTime date) {
    _dateController.text = AppDateTime.formatForDisplay(date);
  }

  void _updateStartTimeText(TimeOfDay time) {
    if (mounted) {
      _startTimeController.text = time.format(context);
    }
  }

  void _updateEndTimeText(TimeOfDay time) {
    if (mounted) {
      _endTimeController.text = time.format(context);
    }
  }

  void _updateDayOfWeek(DateTime date) {
    setState(() {
      _dayOfWeek = AppDateTime.getDayOfWeekForApi(date);
    });
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: AppDateTime.today(),
      lastDate: AppDateTime.today().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Color(0xff1F2937),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && !AppDateTime.isSameDay(picked, _selectedDate)) {
      setState(() {
        _selectedDate = picked;
        _updateDateText(picked);
        _updateDayOfWeek(picked);
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _startTime) {
      setState(() {
        _startTime = picked;
        _updateStartTimeText(picked);

        // Auto adjust end time if end time is before start time
        if (_endTime.hour < _startTime.hour ||
            (_endTime.hour == _startTime.hour &&
                _endTime.minute <= _startTime.minute)) {
          int newHour = _startTime.hour + 1;
          if (newHour >= 24) {
            newHour = 0;
          }
          _endTime = TimeOfDay(hour: newHour, minute: _startTime.minute);
          _updateEndTimeText(_endTime);
        }
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _endTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _endTime) {
      // Validate end time is after start time
      bool isValid = false;

      if (picked.hour > _startTime.hour) {
        isValid = true;
      } else if (picked.hour == _startTime.hour) {
        isValid = picked.minute > _startTime.minute;
      } else {
        isValid = false;
      }

      if (!isValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('End time must be after start time'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _endTime = picked;
        _updateEndTimeText(picked);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Validate hall is selected
      if (_selectedHallId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a hall'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      final request = UpdateClassScheduleRequestModel(
        scheduleId: widget.schedule.id,
        classCategoryFeeId: widget.classCategoryFeeId,
        classHallId: _selectedHallId!,
        classDate: AppDateTime.formatForApi(_selectedDate),
        startTime: _formatTimeOfDay(_startTime),
        endTime: _formatTimeOfDay(_endTime),
        dayOfWeek: _dayOfWeek,
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
      );

      // Add debug print
      print('=== UPDATE REQUEST ===');
      print('schedule_id: ${widget.schedule.id}');
      print('class_category_fee_id: ${widget.classCategoryFeeId}');
      print('class_hall_id: $_selectedHallId');
      print('class_date: ${AppDateTime.formatForApi(_selectedDate)}');
      print('start_time: ${_formatTimeOfDay(_startTime)}');
      print('end_time: ${_formatTimeOfDay(_endTime)}');
      print('day_of_week: $_dayOfWeek');
      print(
        'note: ${_noteController.text.trim().isEmpty ? null : _noteController.text.trim()}',
      );
      print('======================');

      context.read<ClassScheduleBloc>().add(UpdateClassScheduleEvent(request));
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: Text(
          'Update Schedule - ${widget.className}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: BlocListener<ClassScheduleBloc, ClassScheduleState>(
        listener: (context, state) {
          if (state is UpdateClassScheduleSuccess) {
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.response.message),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
            // Pop with success result to refresh the list
            Navigator.pop(context, true);
          } else if (state is ClassScheduleError) {
            setState(() {
              _isLoading = false;
            });

            // Show user-friendly error message
            String errorMessage = state.message;
            if (errorMessage.contains('cannot be updated')) {
              errorMessage =
                  'This schedule cannot be updated because it is already ${widget.schedule.status}.';
            } else if (errorMessage.contains(
              'Past class schedules cannot be updated',
            )) {
              errorMessage = 'Past class schedules cannot be updated.';
            } else if (errorMessage.contains('schedule already exists')) {
              errorMessage = 'Another schedule already exists for this date.';
            } else if (errorMessage.contains('class date should be between')) {
              errorMessage = 'Selected date is outside the allowed date range.';
            } else if (errorMessage.contains(
              'No active schedule pattern found',
            )) {
              errorMessage =
                  'No active schedule pattern found for this class. Please contact administrator.';
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card
                _buildHeaderCard(),
                const SizedBox(height: 24),

                // Hall Selection
                _buildSectionTitle('Hall Information'),
                const SizedBox(height: 16),
                _buildHallDropdown(),
                const SizedBox(height: 24),

                // Schedule Information
                _buildSectionTitle('Schedule Information'),
                const SizedBox(height: 16),
                _buildDateField(),
                const SizedBox(height: 16),
                _buildStartTimeField(),
                const SizedBox(height: 16),
                _buildEndTimeField(),
                const SizedBox(height: 16),
                _buildDayOfWeekDisplay(),
                const SizedBox(height: 24),

                // Additional Information
                _buildSectionTitle('Additional Information'),
                const SizedBox(height: 16),
                _buildNoteField(),
                const SizedBox(height: 32),

                // Submit Button
                _buildSubmitButton(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    final scheduleDate = AppDateTime.parseToLocal(widget.schedule.classDate);
    final statusColor = _getStatusColor(widget.schedule.status);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, Color(0xff1D4ED8)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.edit_calendar,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Update Schedule',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Update schedule for ${widget.className}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Schedule',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${AppDateTime.formatForDisplay(scheduleDate)} • ${widget.schedule.startTime} - ${widget.schedule.endTime}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.schedule.status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return Colors.blue;
      case 'ongoing':
        return Colors.green;
      case 'completed':
        return Colors.purple;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildHallDropdown() {
    return _buildFormField(
      label: 'Class Hall',
      icon: Icons.meeting_room,
      child: BlocBuilder<InstituteHallBloc, InstituteHallState>(
        builder: (context, state) {
          if (state is InstituteHallLoading) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          }

          if (state is InstituteHallLoaded) {
            if (state.halls.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  border: Border.all(color: Colors.orange[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'No halls available. Please add a hall first.',
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              );
            }

            return DropdownButtonFormField<int>(
              value: _selectedHallId,
              hint: const Text('Select Hall'),
              isExpanded: true,
              decoration: InputDecoration(
                hintText: 'Select Hall',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              items: state.halls.map((hall) {
                String displayText = hall.hallName;
                return DropdownMenuItem<int>(
                  value: hall.id,
                  child: Text(
                    displayText,
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedHallId = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a hall';
                }
                return null;
              },
            );
          }

          if (state is InstituteHallError) {
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                border: Border.all(color: Colors.red[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildDateField() {
    return _buildFormField(
      label: 'Class Date',
      icon: Icons.calendar_today,
      child: TextFormField(
        controller: _dateController,
        readOnly: true,
        decoration: InputDecoration(
          hintText: 'Select date',
          suffixIcon: const Icon(Icons.arrow_drop_down),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        onTap: () => _selectDate(context),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a date';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildStartTimeField() {
    return _buildFormField(
      label: 'Start Time',
      icon: Icons.access_time,
      child: TextFormField(
        controller: _startTimeController,
        readOnly: true,
        decoration: InputDecoration(
          hintText: 'Select start time',
          suffixIcon: const Icon(Icons.arrow_drop_down),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        onTap: () => _selectStartTime(context),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select start time';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildEndTimeField() {
    return _buildFormField(
      label: 'End Time',
      icon: Icons.access_time_filled,
      child: TextFormField(
        controller: _endTimeController,
        readOnly: true,
        decoration: InputDecoration(
          hintText: 'Select end time',
          suffixIcon: const Icon(Icons.arrow_drop_down),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        onTap: () => _selectEndTime(context),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select end time';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDayOfWeekDisplay() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.calendar_view_week,
            size: 20,
            color: AppColors.primary,
          ),
          const SizedBox(width: 12),
          const Text(
            'Day of Week:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 8),
          Text(
            _capitalizeFirstLetter(_dayOfWeek),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteField() {
    return _buildFormField(
      label: 'Note (Optional)',
      icon: Icons.note_outlined,
      child: TextFormField(
        controller: _noteController,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: 'Enter any additional notes...',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.all(12),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Update Schedule',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xff1F2937),
          ),
        ),
      ],
    );
  }

  Widget _buildFormField({
    required String label,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
