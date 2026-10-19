class Job {
  final String id;
  final String jobNumber;
  final String category;
  final String status;
  final String priority;
  final String customerName;
  final String building;
  final String siteAddress;
  final String elevatorId;
  final String elevatorModel;
  final String description;
  final DateTime scheduledDate;
  final DateTime? slaDeadline;
  final DateTime? createdAt;
  final String? assignedTechnician;
  final String? contactPerson;
  final String? contactPhone;
  final String? notes;
  final List<String>? documents;

  Job({
    required this.id,
    required this.jobNumber,
    required this.category,
    required this.status,
    required this.priority,
    required this.customerName,
    required this.building,
    required this.siteAddress,
    required this.elevatorId,
    required this.elevatorModel,
    required this.description,
    required this.scheduledDate,
    this.slaDeadline,
    this.createdAt,
    this.assignedTechnician,
    this.contactPerson,
    this.contactPhone,
    this.notes,
    this.documents,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['_id'] ?? json['id'] ?? '',
      jobNumber: json['jobNumber'] ?? '',
      category: json['category'] ?? '',
      status: json['status'] ?? 'Assigned',
      priority: json['priority'] ?? 'Medium',
      customerName: json['customerName'] ?? '',
      building: json['building'] ?? '',
      siteAddress: json['siteAddress'] ?? '',
      elevatorId: json['elevatorId'] ?? '',
      elevatorModel: json['elevatorModel'] ?? '',
      description: json['description'] ?? '',
      scheduledDate: DateTime.tryParse(json['scheduledDate'] ?? '') ?? DateTime.now(),
      slaDeadline: json['slaDeadline'] != null ? DateTime.tryParse(json['slaDeadline']) : null,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      assignedTechnician: json['assignedTechnician'],
      contactPerson: json['contactPerson'],
      contactPhone: json['contactPhone'],
      notes: json['notes'],
      documents: List<String>.from(json['documents'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'jobNumber': jobNumber,
    'category': category,
    'status': status,
    'priority': priority,
    'customerName': customerName,
    'building': building,
    'siteAddress': siteAddress,
    'elevatorId': elevatorId,
    'elevatorModel': elevatorModel,
    'description': description,
    'scheduledDate': scheduledDate.toIso8601String(),
    'slaDeadline': slaDeadline?.toIso8601String(),
    'createdAt': createdAt?.toIso8601String(),
    'assignedTechnician': assignedTechnician,
    'contactPerson': contactPerson,
    'contactPhone': contactPhone,
    'notes': notes,
    'documents': documents,
  };

  bool get isOverdue => slaDeadline != null && DateTime.now().isAfter(slaDeadline!);
  bool get isUrgent => priority == 'Critical' || priority == 'Emergency';
  bool get isPending => status == 'Assigned';
  bool get isInProgress => status == 'In Progress' || status == 'On Site';
  bool get isCompleted => status == 'Resolved' || status == 'Closed';
}
