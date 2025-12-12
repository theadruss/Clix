import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/mock_data_service.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class EventProposalPage extends StatefulWidget {
  const EventProposalPage({super.key});

  @override
  State<EventProposalPage> createState() => _EventProposalPageState();
}

class _EventProposalPageState extends State<EventProposalPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _venueController = TextEditingController();
  final _capacityController = TextEditingController();
  final _budgetController = TextEditingController();
  final _feeController = TextEditingController();
  
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String? _selectedClub;
  String _selectedCategory = 'Technology';
  bool _needsVolunteers = false;
  List<String> _volunteerRoles = [];
  final _volunteerRoleController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _venueController.dispose();
    _capacityController.dispose();
    _budgetController.dispose();
    _feeController.dispose();
    _volunteerRoleController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.accentYellow,
              onPrimary: AppColors.darkGray,
              surface: AppColors.darkGray,
              onSurface: AppColors.pureWhite,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.accentYellow,
              onPrimary: AppColors.darkGray,
              surface: AppColors.darkGray,
              onSurface: AppColors.pureWhite,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _startTime = picked);
    }
  }

  Future<void> _selectEndTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.accentYellow,
              onPrimary: AppColors.darkGray,
              surface: AppColors.darkGray,
              onSurface: AppColors.pureWhite,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _endTime = picked);
    }
  }

  void _addVolunteerRole() {
    if (_volunteerRoleController.text.trim().isNotEmpty) {
      setState(() {
        _volunteerRoles.add(_volunteerRoleController.text.trim());
        _volunteerRoleController.clear();
      });
    }
  }

  void _removeVolunteerRole(int index) {
    setState(() {
      _volunteerRoles.removeAt(index);
    });
  }

  Future<void> _submitProposal() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null || _startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select date and time'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    final authProvider = context.read<AuthProvider>();
    final user = authProvider.user!;

    // Create proposal
    final proposal = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'club': _selectedClub ?? 'Unknown Club',
      'clubId': _selectedClub ?? '1',
      'submittedBy': user.name,
      'submittedDate': DateTime.now().toIso8601String(),
      'date': _selectedDate!.toIso8601String(),
      'startTime': '${_startTime!.hour}:${_startTime!.minute.toString().padLeft(2, '0')}',
      'endTime': '${_endTime!.hour}:${_endTime!.minute.toString().padLeft(2, '0')}',
      'venue': _venueController.text.trim(),
      'capacity': int.tryParse(_capacityController.text) ?? 100,
      'budget': double.tryParse(_budgetController.text) ?? 0.0,
      'fee': double.tryParse(_feeController.text) ?? 0.0,
      'category': _selectedCategory,
      'needsVolunteers': _needsVolunteers,
      'volunteerRoles': _volunteerRoles,
      'status': 'pending_coordinator', // Will be reviewed by coordinator first
    };

    // Add to mock data
    MockDataService.pendingApprovals.insert(0, proposal);

    setState(() => _isSubmitting = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Event proposal submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Removed unused authProvider variable
    
    // Get user's clubs
    final userClubs = MockDataService.clubs.where((club) => 
      club['isMember'] == true && 
      (club['userRole'] == 'coordinator' || club['userRole'] == 'subgroup_head')
    ).toList();

    if (userClubs.isEmpty && _selectedClub == null) {
      _selectedClub = userClubs.isNotEmpty ? userClubs.first['name'] : null;
    }

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppColors.darkGray,
        title: Text('Propose Event', style: AppTextStyles.headlineSmall),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Event Details', style: AppTextStyles.headlineSmall),
              const SizedBox(height: 16),
              
              CustomTextField(
                label: 'Event Title',
                hintText: 'Enter event title',
                controller: _titleController,
                validator: (value) => value?.isEmpty ?? true ? 'Please enter event title' : null,
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                label: 'Description',
                hintText: 'Enter event description',
                controller: _descriptionController,
                maxLines: 4,
                validator: (value) => value?.isEmpty ?? true ? 'Please enter description' : null,
              ),
              const SizedBox(height: 16),
              
              // Club Selection
              if (userClubs.length > 1)
                DropdownButtonFormField<String>(
                  value: _selectedClub,
                  decoration: InputDecoration(
                    labelText: 'Club',
                    labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
                    filled: true,
                    fillColor: AppColors.darkGray,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  dropdownColor: AppColors.darkGray,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.pureWhite),
                  items: userClubs.map((club) {
                    return DropdownMenuItem<String>(
                      value: club['name'],
                      child: Text(club['name']),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedClub = value),
                )
              else if (userClubs.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.darkGray,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.group_rounded, color: AppColors.accentYellow),
                      const SizedBox(width: 12),
                      Text('Club: ${userClubs.first['name']}', style: AppTextStyles.bodyMedium),
                    ],
                  ),
                ),
              
              const SizedBox(height: 16),
              
              // Category
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
                  filled: true,
                  fillColor: AppColors.darkGray,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                dropdownColor: AppColors.darkGray,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.pureWhite),
                items: ['Technology', 'Cultural', 'Business', 'Sports', 'Academic', 'Other']
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedCategory = value ?? 'Technology'),
              ),
              
              const SizedBox(height: 24),
              Text('Date & Time', style: AppTextStyles.headlineSmall),
              const SizedBox(height: 16),
              
              // Date Selection
              GestureDetector(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.darkGray,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today_rounded, color: AppColors.accentYellow),
                      const SizedBox(width: 12),
                      Text(
                        _selectedDate == null
                            ? 'Select Date'
                            : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              // Time Selection
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _selectStartTime,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.darkGray,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.access_time_rounded, color: AppColors.accentYellow),
                            const SizedBox(width: 12),
                            Text(
                              _startTime == null
                                  ? 'Start Time'
                                  : _startTime!.format(context),
                              style: AppTextStyles.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: _selectEndTime,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.darkGray,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.access_time_rounded, color: AppColors.accentYellow),
                            const SizedBox(width: 12),
                            Text(
                              _endTime == null
                                  ? 'End Time'
                                  : _endTime!.format(context),
                              style: AppTextStyles.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              Text('Venue & Capacity', style: AppTextStyles.headlineSmall),
              const SizedBox(height: 16),
              
              CustomTextField(
                label: 'Venue',
                hintText: 'Enter venue name',
                controller: _venueController,
                validator: (value) => value?.isEmpty ?? true ? 'Please enter venue' : null,
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                label: 'Capacity',
                hintText: 'Enter maximum capacity',
                controller: _capacityController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Please enter capacity';
                  if (int.tryParse(value!) == null) return 'Please enter a valid number';
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              Text('Budget & Fees', style: AppTextStyles.headlineSmall),
              const SizedBox(height: 16),
              
              CustomTextField(
                label: 'Budget (Optional)',
                hintText: 'Enter estimated budget',
                controller: _budgetController,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.attach_money_rounded),
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                label: 'Registration Fee (Optional)',
                hintText: 'Enter fee amount',
                controller: _feeController,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.attach_money_rounded),
              ),
              
              const SizedBox(height: 24),
              Text('Volunteers', style: AppTextStyles.headlineSmall),
              const SizedBox(height: 16),
              
              SwitchListTile(
                title: Text('Needs Volunteers', style: AppTextStyles.bodyMedium),
                value: _needsVolunteers,
                activeColor: AppColors.accentYellow,
                onChanged: (value) => setState(() => _needsVolunteers = value),
              ),
              
              if (_needsVolunteers) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Volunteer Role',
                        hintText: 'e.g., Registration Desk',
                        controller: _volunteerRoleController,
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _addVolunteerRole,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentYellow,
                        foregroundColor: AppColors.darkGray,
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Icon(Icons.add_rounded),
                    ),
                  ],
                ),
                if (_volunteerRoles.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _volunteerRoles.asMap().entries.map((entry) {
                      return Chip(
                        label: Text(entry.value),
                        deleteIcon: const Icon(Icons.close_rounded, size: 18),
                        onDeleted: () => _removeVolunteerRole(entry.key),
                        backgroundColor: AppColors.darkGray,
                        labelStyle: AppTextStyles.bodySmall,
                      );
                    }).toList(),
                  ),
                ],
              ],
              
              const SizedBox(height: 32),
              CustomButton(
                text: 'Submit Proposal',
                onPressed: _submitProposal,
                isLoading: _isSubmitting,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}


