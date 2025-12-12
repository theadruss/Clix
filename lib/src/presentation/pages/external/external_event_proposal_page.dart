import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/mock_data_service.dart';
import '../../providers/auth_provider.dart';

class ExternalEventProposalPage extends StatefulWidget {
  const ExternalEventProposalPage({super.key});

  @override
  State<ExternalEventProposalPage> createState() => _ExternalEventProposalPageState();
}

class _ExternalEventProposalPageState extends State<ExternalEventProposalPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _venueController = TextEditingController();
  final _capacityController = TextEditingController();
  final _budgetController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _contactPhoneController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedCategory = 'Other';
  bool _needsVolunteers = false;
  bool _requiresPayment = false;
  double _ticketPrice = 0.0;
  bool _isSubmitting = false;

  final List<String> _categories = [
    'Workshop',
    'Seminar',
    'Conference',
    'Competition',
    'Networking',
    'Cultural',
    'Sports',
    'Other',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _venueController.dispose();
    _capacityController.dispose();
    _budgetController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _contactPersonController.dispose();
    _contactPhoneController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.accentYellow,
              onPrimary: AppColors.primaryBlack,
              surface: AppColors.darkGray,
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

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.accentYellow,
              onPrimary: AppColors.primaryBlack,
              surface: AppColors.darkGray,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final timeString = picked.format(context);
      if (isStartTime) {
        setState(() => _startTimeController.text = timeString);
      } else {
        setState(() => _endTimeController.text = timeString);
      }
    }
  }

  void _submitProposal() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an event date')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    await Future.delayed(const Duration(seconds: 1));

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user!;

    final proposal = {
      'id': 'EXT-${DateTime.now().millisecondsSinceEpoch}',
      'title': _titleController.text,
      'description': _descriptionController.text,
      'club': 'External Organization',
      'submittedBy': user.name,
      'submittedByEmail': user.email,
      'submittedByPhone': _contactPhoneController.text,
      'submittedByRole': 'external',
      'date': _selectedDate!.toIso8601String(),
      'startTime': _startTimeController.text,
      'endTime': _endTimeController.text,
      'venue': _venueController.text,
      'capacity': int.tryParse(_capacityController.text) ?? 100,
      'budget': double.tryParse(_budgetController.text) ?? 0.0,
      'category': _selectedCategory,
      'needsVolunteers': _needsVolunteers,
      'volunteerRoles': [],
      'requiresPayment': _requiresPayment,
      'ticketPrice': _ticketPrice,
      'status': 'pending',
      'createdAt': DateTime.now().toIso8601String(),
    };

    // Add to mock data
    MockDataService.pendingApprovals.insert(0, proposal);
    setState(() => _isSubmitting = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Event proposal submitted successfully! Admin will review it shortly.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppColors.darkGray,
        title: Text('Submit Event Proposal', style: AppTextStyles.headlineSmall),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Event Information'),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _titleController,
                label: 'Event Title',
                hint: 'Enter event title',
                validator: (value) => value?.isEmpty ?? true ? 'Title is required' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _descriptionController,
                label: 'Event Description',
                hint: 'Describe your event',
                maxLines: 4,
                validator: (value) => value?.isEmpty ?? true ? 'Description is required' : null,
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: 'Event Category',
                value: _selectedCategory,
                items: _categories,
                onChanged: (value) => setState(() => _selectedCategory = value),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Event Details'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Event Date', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.darkGray,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.lightGray),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today_rounded, color: AppColors.mediumGray, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  _selectedDate == null
                                      ? 'Select date'
                                      : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: _selectedDate == null ? AppColors.mediumGray : AppColors.pureWhite,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectTime(context, true),
                      child: _buildTimeField('Start Time', _startTimeController),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectTime(context, false),
                      child: _buildTimeField('End Time', _endTimeController),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _venueController,
                label: 'Venue / Location',
                hint: 'Enter event venue',
                validator: (value) => value?.isEmpty ?? true ? 'Venue is required' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _capacityController,
                label: 'Expected Capacity',
                hint: 'Number of attendees',
                keyboardType: TextInputType.number,
                validator: (value) => value?.isEmpty ?? true ? 'Capacity is required' : null,
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Organizer Details'),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _contactPersonController,
                label: 'Contact Person Name',
                hint: 'Enter your name',
                validator: (value) => value?.isEmpty ?? true ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _contactPhoneController,
                label: 'Contact Phone',
                hint: 'Enter phone number',
                keyboardType: TextInputType.phone,
                validator: (value) => value?.isEmpty ?? true ? 'Phone is required' : null,
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Budget & Resources'),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _budgetController,
                label: 'Estimated Budget',
                hint: 'Enter budget amount',
                keyboardType: TextInputType.number,
                validator: (value) => value?.isEmpty ?? true ? 'Budget is required' : null,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.darkGray,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Needs Volunteers', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text('Do you need volunteer support?', style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray)),
                      ],
                    ),
                    Switch.adaptive(
                      value: _needsVolunteers,
                      onChanged: (value) => setState(() => _needsVolunteers = value),
                      activeColor: AppColors.accentYellow,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.darkGray,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Paid Event', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text('Charge for tickets?', style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray)),
                      ],
                    ),
                    Switch.adaptive(
                      value: _requiresPayment,
                      onChanged: (value) => setState(() => _requiresPayment = value),
                      activeColor: AppColors.accentYellow,
                    ),
                  ],
                ),
              ),
              if (_requiresPayment) ...[
                const SizedBox(height: 16),
                _buildTextField(
                  controller: TextEditingController(text: _ticketPrice.toString()),
                  label: 'Ticket Price',
                  hint: 'Enter ticket price',
                  keyboardType: TextInputType.number,
                  onChanged: (value) => setState(() => _ticketPrice = double.tryParse(value) ?? 0.0),
                ),
              ],
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitProposal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentYellow,
                    foregroundColor: AppColors.primaryBlack,
                    disabledBackgroundColor: AppColors.mediumGray,
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Submit Proposal'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accentYellow,
                    side: const BorderSide(color: AppColors.accentYellow),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: AppTextStyles.headlineSmall);
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          style: AppTextStyles.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
            filled: true,
            fillColor: AppColors.darkGray,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.lightGray),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.lightGray),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.accentYellow),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.darkGray,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.lightGray),
          ),
          child: Row(
            children: [
              Icon(Icons.access_time_rounded, color: AppColors.mediumGray, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  controller.text.isEmpty ? 'Select time' : controller.text,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: controller.text.isEmpty ? AppColors.mediumGray : AppColors.pureWhite,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.darkGray,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.lightGray),
          ),
          child: DropdownButton<String>(
            value: value,
            onChanged: onChanged,
            isExpanded: true,
            underline: const SizedBox(),
            dropdownColor: AppColors.darkGray,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.pureWhite),
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

