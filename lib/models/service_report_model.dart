class ServiceReport {
  final String id;
  final String jobId;
  final String jobNumber;
  final String elevatorId;
  final String customerName;
  final String building;
  final String technicianName;
  final DateTime arrivalTime;
  final DateTime? departureTime;
  final String workPerformed;
  final String findings;
  final List<String>? photographs;
  final List<String>? spartsUsed;
  final String? measurementsAndObservations;
  final String? recommendedFollowUp;
  final String equipmentStatus;
  final String status;
  final DateTime? submittedAt;
  final String? customerSignature;
  final String? customerComments;
  final bool? safetyChecksPassed;

  ServiceReport({
    required this.id,
    required this.jobId,
    required this.jobNumber,
    required this.elevatorId,
    required this.customerName,
    required this.building,
    required this.technicianName,
    required this.arrivalTime,
    this.departureTime,
    required this.workPerformed,
    required this.findings,
    this.photographs,
    this.spartsUsed,
    this.measurementsAndObservations,
    this.recommendedFollowUp,
    required this.equipmentStatus,
    required this.status,
    this.submittedAt,
    this.customerSignature,
    this.customerComments,
    this.safetyChecksPassed,
  });

  factory ServiceReport.fromJson(Map<String, dynamic> json) {
    return ServiceReport(
      id: json['_id'] ?? json['id'] ?? '',
      jobId: json['jobId'] ?? '',
      jobNumber: json['jobNumber'] ?? '',
      elevatorId: json['elevatorId'] ?? '',
      customerName: json['customerName'] ?? '',
      building: json['building'] ?? '',
      technicianName: json['technicianName'] ?? '',
      arrivalTime: DateTime.tryParse(json['arrivalTime'] ?? '') ?? DateTime.now(),
      departureTime: json['departureTime'] != null ? DateTime.tryParse(json['departureTime']) : null,
      workPerformed: json['workPerformed'] ?? '',
      findings: json['findings'] ?? '',
      photographs: List<String>.from(json['photographs'] ?? []),
      spartsUsed: List<String>.from(json['spartsUsed'] ?? []),
      measurementsAndObservations: json['measurementsAndObservations'],
      recommendedFollowUp: json['recommendedFollowUp'],
      equipmentStatus: json['equipmentStatus'] ?? 'Operational',
      status: json['status'] ?? 'Draft',
      submittedAt: json['submittedAt'] != null ? DateTime.tryParse(json['submittedAt']) : null,
      customerSignature: json['customerSignature'],
      customerComments: json['customerComments'],
      safetyChecksPassed: json['safetyChecksPassed'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'jobId': jobId,
    'jobNumber': jobNumber,
    'elevatorId': elevatorId,
    'customerName': customerName,
    'building': building,
    'technicianName': technicianName,
    'arrivalTime': arrivalTime.toIso8601String(),
    'departureTime': departureTime?.toIso8601String(),
    'workPerformed': workPerformed,
    'findings': findings,
    'photographs': photographs,
    'spartsUsed': spartsUsed,
    'measurementsAndObservations': measurementsAndObservations,
    'recommendedFollowUp': recommendedFollowUp,
    'equipmentStatus': equipmentStatus,
    'status': status,
    'submittedAt': submittedAt?.toIso8601String(),
    'customerSignature': customerSignature,
    'customerComments': customerComments,
    'safetyChecksPassed': safetyChecksPassed,
  };

  bool get isDraft => status == 'Draft';
  bool get isSubmitted => status == 'Submitted';
  bool get isApproved => status == 'Approved';
  bool get isRejected => status == 'Rejected';
  int get visitDurationMinutes {
    if (departureTime == null) return 0;
    return departureTime!.difference(arrivalTime).inMinutes;
  }
}
