class EventProposalModel {
	final String id;
	final String title;
	final String? description;
	final String clubId;
	final String proposedBy;
	final DateTime? eventDate;
	final String? venue;
	final int? expectedParticipants;
	final double? budget;
	final List<String> requiredResources;
	String status;

	EventProposalModel({
		required this.id,
		required this.title,
		this.description,
		required this.clubId,
		required this.proposedBy,
		this.eventDate,
		this.venue,
		this.expectedParticipants,
		this.budget,
		this.requiredResources = const [],
		this.status = 'pending_review',
	});

	factory EventProposalModel.fromMap(Map<String, dynamic> map) {
		DateTime? parsedDate;
		if (map['submittedDate'] != null) {
			try {
				parsedDate = DateTime.tryParse(map['submittedDate'].toString());
			} catch (_) {
				parsedDate = null;
			}
		}

		return EventProposalModel(
			id: map['id']?.toString() ?? '',
			title: map['title']?.toString() ?? '',
			description: map['description']?.toString(),
			clubId: map['clubId']?.toString() ?? map['club']?.toString() ?? '',
			proposedBy: map['submittedBy']?.toString() ?? map['proposedBy']?.toString() ?? 'Unknown',
			eventDate: parsedDate,
			venue: map['venue']?.toString(),
			expectedParticipants: map['expectedParticipants'] is int ? map['expectedParticipants'] as int : (map['expectedParticipants'] != null ? int.tryParse(map['expectedParticipants'].toString()) : null),
			budget: map['budget'] is double ? map['budget'] as double : (map['budget'] != null ? double.tryParse(map['budget'].toString()) : null),
			requiredResources: (map['requiredResources'] is List) ? List<String>.from(map['requiredResources']) : [],
			status: map['status']?.toString() ?? 'pending_review',
		);
	}

	Map<String, dynamic> toMap() {
		return {
			'id': id,
			'title': title,
			'description': description,
			'clubId': clubId,
			'proposedBy': proposedBy,
			'eventDate': eventDate?.toIso8601String(),
			'venue': venue,
			'expectedParticipants': expectedParticipants,
			'budget': budget,
			'requiredResources': requiredResources,
			'status': status,
		};
	}
}
