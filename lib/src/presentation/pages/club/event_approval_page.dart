// lib/src/presentation/pages/club/event_approval_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/text_styles.dart';
import '../../../data/models/event/event_proposal_model.dart';
import '../../providers/event_provider.dart';

class EventApprovalPage extends StatefulWidget {
  final Map<String, dynamic> club;

  const EventApprovalPage({super.key, required this.club});

  @override
  State<EventApprovalPage> createState() => _EventApprovalPageState();
}

class _EventApprovalPageState extends State<EventApprovalPage> {
  @override
  void initState() {
    super.initState();
    // Load pending proposals for this club when the page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<EventProvider>();
      provider.loadPendingProposalsForClub(widget.club['id']?.toString() ?? widget.club['id'].toString());
    });
  }
  @override
  Widget build(BuildContext context) {
    final eventProvider = context.watch<EventProvider>();
    final pendingProposals = eventProvider.getPendingProposalsForClub(widget.club['id']);

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppColors.darkGray,
        title: Text('Pending Approvals - ${widget.club['name']}'),
      ),
      body: pendingProposals.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pendingProposals.length,
              itemBuilder: (context, index) {
                final proposal = pendingProposals[index];
                return _ProposalCard(proposal: proposal);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 64,
            color: AppColors.mediumGray,
          ),
          const SizedBox(height: 16),
          Text(
            'No Pending Approvals',
            style: AppTextStyles.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'All event proposals have been reviewed',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.mediumGray,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ProposalCard extends StatelessWidget {
  final EventProposalModel proposal;

  const _ProposalCard({required this.proposal});

  @override
  Widget build(BuildContext context) {
    final eventProvider = context.read<EventProvider>();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withAlpha((0.3 * 255).round())),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  proposal.title,
                  style: AppTextStyles.headlineSmall.copyWith(fontSize: 18),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withAlpha((0.2 * 255).round()),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Pending Review',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            proposal.description ?? '',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
            _buildDetailRow(Icons.calendar_today_rounded,
              'Date: ${_formatDate(proposal.eventDate)}'),
            _buildDetailRow(Icons.location_on_rounded,
              'Venue: ${proposal.venue ?? 'TBD'}'),
          _buildDetailRow(Icons.people_rounded, 
              'Expected: ${proposal.expectedParticipants} participants'),
            _buildDetailRow(Icons.attach_money_rounded,
              'Budget: ₹${proposal.budget?.toStringAsFixed(2) ?? 'N/A'}'),
          if (proposal.requiredResources.isNotEmpty) ...[
            _buildDetailRow(Icons.build_rounded, 
                'Resources: ${proposal.requiredResources.join(', ')}'),
          ],
          _buildDetailRow(Icons.person_rounded, 
              'Proposed by: ${proposal.proposedBy}'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showRejectDialog(context, eventProvider),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                  child: const Text('Reject'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _approveProposal(context, eventProvider),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: AppColors.pureWhite,
                  ),
                  child: const Text('Approve'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.mediumGray),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'TBD';
    return '${date.day}/${date.month}/${date.year}';
  }

  void _approveProposal(BuildContext context, EventProvider eventProvider) {
    eventProvider.approveProposal(proposal.id);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Event proposal approved and forwarded to admin'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showRejectDialog(BuildContext context, EventProvider eventProvider) {
    final reasonController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkGray,
        title: Text(
          'Reject Event Proposal',
          style: AppTextStyles.headlineSmall.copyWith(color: AppColors.pureWhite),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please provide a reason for rejection:',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.pureWhite),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              maxLines: 3,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.pureWhite),
              decoration: InputDecoration(
                hintText: 'Enter rejection reason...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.lightGray),
                ),
                filled: true,
                fillColor: AppColors.primaryBlack,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTextStyles.buttonMedium.copyWith(color: AppColors.accentYellow),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.trim().isNotEmpty) {
                eventProvider.rejectProposal(proposal.id, reasonController.text.trim());
                Navigator.pop(context);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Event proposal rejected'),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: AppColors.pureWhite,
            ),
            child: const Text('Reject Proposal'),
          ),
        ],
      ),
    );
  }
}