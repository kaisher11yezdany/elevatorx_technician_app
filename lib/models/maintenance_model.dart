class MaintenanceVisit {
  final String id;
  final String jobId;
  final String elevatorId;
  final String elevatorModel;
  final String site;
  final String building;
  final DateTime scheduledDate;
  final String maintenanceType;
  final List<MaintenanceChecklistItem> checklist;
  final String status;
  final DateTime? completedAt;
  final String? technicianNotes;
  final List<String>? photographs;
  final List<PartsUsed>? partsUsed;
  final String? nextVisitDate;

  MaintenanceVisit({
    required this.id,
    required this.jobId,
    required this.elevatorId,
    required this.elevatorModel,
    required this.site,
    required this.building,
    required this.scheduledDate,
    required this.maintenanceType,
    required this.checklist,
    required this.status,
    this.completedAt,
    this.technicianNotes,
    this.photographs,
    this.partsUsed,
    this.nextVisitDate,
  });

  factory MaintenanceVisit.fromJson(Map<String, dynamic> json) {
    return MaintenanceVisit(
      id: json['_id'] ?? json['id'] ?? '',
      jobId: json['jobId'] ?? '',
      elevatorId: json['elevatorId'] ?? '',
      elevatorModel: json['elevatorModel'] ?? '',
      site: json['site'] ?? '',
      building: json['building'] ?? '',
      scheduledDate: DateTime.tryParse(json['scheduledDate'] ?? '') ?? DateTime.now(),
      maintenanceType: json['maintenanceType'] ?? 'Preventive',
      checklist: (json['checklist'] as List<dynamic>?)
          ?.map((item) => MaintenanceChecklistItem.fromJson(item))
          .toList() ?? [],
      status: json['status'] ?? 'Scheduled',
      completedAt: json['completedAt'] != null ? DateTime.tryParse(json['completedAt']) : null,
      technicianNotes: json['technicianNotes'],
      photographs: List<String>.from(json['photographs'] ?? []),
      partsUsed: (json['partsUsed'] as List<dynamic>?)
          ?.map((item) => PartsUsed.fromJson(item))
          .toList(),
      nextVisitDate: json['nextVisitDate'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'jobId': jobId,
    'elevatorId': elevatorId,
    'elevatorModel': elevatorModel,
    'site': site,
    'building': building,
    'scheduledDate': scheduledDate.toIso8601String(),
    'maintenanceType': maintenanceType,
    'checklist': checklist.map((item) => item.toJson()).toList(),
    'status': status,
    'completedAt': completedAt?.toIso8601String(),
    'technicianNotes': technicianNotes,
    'photographs': photographs,
    'partsUsed': partsUsed?.map((item) => item.toJson()).toList(),
    'nextVisitDate': nextVisitDate,
  };

  bool get isDue => scheduledDate.isBefore(DateTime.now()) && status == 'Scheduled';
  bool get isCompleted => status == 'Completed';
  int get completionPercentage {
    if (checklist.isEmpty) return 0;
    final completed = checklist.where((item) => item.completed).length;
    return ((completed / checklist.length) * 100).toInt();
  }
}

class MaintenanceChecklistItem {
  final String id;
  final String task;
  final String description;
  final bool completed;
  final String? notes;
  final bool isMandatory;

  MaintenanceChecklistItem({
    required this.id,
    required this.task,
    required this.description,
    required this.completed,
    this.notes,
    required this.isMandatory,
  });

  factory MaintenanceChecklistItem.fromJson(Map<String, dynamic> json) {
    return MaintenanceChecklistItem(
      id: json['_id'] ?? json['id'] ?? '',
      task: json['task'] ?? '',
      description: json['description'] ?? '',
      completed: json['completed'] ?? false,
      notes: json['notes'],
      isMandatory: json['isMandatory'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'task': task,
    'description': description,
    'completed': completed,
    'notes': notes,
    'isMandatory': isMandatory,
  };
}

class PartsUsed {
  final String partId;
  final String partName;
  final int quantity;
  final String? remarks;

  PartsUsed({
    required this.partId,
    required this.partName,
    required this.quantity,
    this.remarks,
  });

  factory PartsUsed.fromJson(Map<String, dynamic> json) {
    return PartsUsed(
      partId: json['partId'] ?? '',
      partName: json['partName'] ?? '',
      quantity: json['quantity'] ?? 0,
      remarks: json['remarks'],
    );
  }

  Map<String, dynamic> toJson() => {
    'partId': partId,
    'partName': partName,
    'quantity': quantity,
    'remarks': remarks,
  };
}

class BreakdownReport {
  final String id;
  final String jobId;
  final String elevatorId;
  final String site;
  final String building;
  final String faultCategory;
  final String reportedIssue;
  final String? customerDescription;
  final String status;
  final DateTime arrivedAt;
  final DateTime? departedAt;
  final String? diagnosis;
  final List<String> troubleshootingSteps;
  final String? resolution;
  final String? partsReplaced;
  final List<String>? photographs;
  final String? testingResults;
  final bool operationalAfterRepair;
  final String? furtherActionRequired;
  final DateTime? submittedAt;

  BreakdownReport({
    required this.id,
    required this.jobId,
    required this.elevatorId,
    required this.site,
    required this.building,
    required this.faultCategory,
    required this.reportedIssue,
    this.customerDescription,
    required this.status,
    required this.arrivedAt,
    this.departedAt,
    this.diagnosis,
    required this.troubleshootingSteps,
    this.resolution,
    this.partsReplaced,
    this.photographs,
    this.testingResults,
    required this.operationalAfterRepair,
    this.furtherActionRequired,
    this.submittedAt,
  });

  factory BreakdownReport.fromJson(Map<String, dynamic> json) {
    return BreakdownReport(
      id: json['_id'] ?? json['id'] ?? '',
      jobId: json['jobId'] ?? '',
      elevatorId: json['elevatorId'] ?? '',
      site: json['site'] ?? '',
      building: json['building'] ?? '',
      faultCategory: json['faultCategory'] ?? '',
      reportedIssue: json['reportedIssue'] ?? '',
      customerDescription: json['customerDescription'],
      status: json['status'] ?? 'In Progress',
      arrivedAt: DateTime.tryParse(json['arrivedAt'] ?? '') ?? DateTime.now(),
      departedAt: json['departedAt'] != null ? DateTime.tryParse(json['departedAt']) : null,
      diagnosis: json['diagnosis'],
      troubleshootingSteps: List<String>.from(json['troubleshootingSteps'] ?? []),
      resolution: json['resolution'],
      partsReplaced: json['partsReplaced'],
      photographs: List<String>.from(json['photographs'] ?? []),
      testingResults: json['testingResults'],
      operationalAfterRepair: json['operationalAfterRepair'] ?? false,
      furtherActionRequired: json['furtherActionRequired'],
      submittedAt: json['submittedAt'] != null ? DateTime.tryParse(json['submittedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'jobId': jobId,
    'elevatorId': elevatorId,
    'site': site,
    'building': building,
    'faultCategory': faultCategory,
    'reportedIssue': reportedIssue,
    'customerDescription': customerDescription,
    'status': status,
    'arrivedAt': arrivedAt.toIso8601String(),
    'departedAt': departedAt?.toIso8601String(),
    'diagnosis': diagnosis,
    'troubleshootingSteps': troubleshootingSteps,
    'resolution': resolution,
    'partsReplaced': partsReplaced,
    'photographs': photographs,
    'testingResults': testingResults,
    'operationalAfterRepair': operationalAfterRepair,
    'furtherActionRequired': furtherActionRequired,
    'submittedAt': submittedAt?.toIso8601String(),
  };

  int get visitDurationMinutes {
    if (departedAt == null) return 0;
    return departedAt!.difference(arrivedAt).inMinutes;
  }
}

class InstallationProject {
  final String id;
  final String projectId;
  final String site;
  final String building;
  final String elevatorModel;
  final List<InstallationStage> stages;
  final String overallStatus;
  final int progressPercentage;
  final DateTime startDate;
  final DateTime targetCompletionDate;
  final List<String> assignedTeam;
  final String? safetyOfficer;
  final List<String>? documentLinks;

  InstallationProject({
    required this.id,
    required this.projectId,
    required this.site,
    required this.building,
    required this.elevatorModel,
    required this.stages,
    required this.overallStatus,
    required this.progressPercentage,
    required this.startDate,
    required this.targetCompletionDate,
    required this.assignedTeam,
    this.safetyOfficer,
    this.documentLinks,
  });

  factory InstallationProject.fromJson(Map<String, dynamic> json) {
    return InstallationProject(
      id: json['_id'] ?? json['id'] ?? '',
      projectId: json['projectId'] ?? '',
      site: json['site'] ?? '',
      building: json['building'] ?? '',
      elevatorModel: json['elevatorModel'] ?? '',
      stages: (json['stages'] as List<dynamic>?)
          ?.map((stage) => InstallationStage.fromJson(stage))
          .toList() ?? [],
      overallStatus: json['overallStatus'] ?? 'Planning',
      progressPercentage: json['progressPercentage'] ?? 0,
      startDate: DateTime.tryParse(json['startDate'] ?? '') ?? DateTime.now(),
      targetCompletionDate: DateTime.tryParse(json['targetCompletionDate'] ?? '') ?? DateTime.now(),
      assignedTeam: List<String>.from(json['assignedTeam'] ?? []),
      safetyOfficer: json['safetyOfficer'],
      documentLinks: List<String>.from(json['documentLinks'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'projectId': projectId,
    'site': site,
    'building': building,
    'elevatorModel': elevatorModel,
    'stages': stages.map((stage) => stage.toJson()).toList(),
    'overallStatus': overallStatus,
    'progressPercentage': progressPercentage,
    'startDate': startDate.toIso8601String(),
    'targetCompletionDate': targetCompletionDate.toIso8601String(),
    'assignedTeam': assignedTeam,
    'safetyOfficer': safetyOfficer,
    'documentLinks': documentLinks,
  };
}

class InstallationStage {
  final String stageId;
  final String stageName;
  final String description;
  final String status;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final List<InstallationChecklistItem>? checklist;
  final String? technicianNotes;
  final List<String>? photographs;

  InstallationStage({
    required this.stageId,
    required this.stageName,
    required this.description,
    required this.status,
    this.startedAt,
    this.completedAt,
    this.checklist,
    this.technicianNotes,
    this.photographs,
  });

  factory InstallationStage.fromJson(Map<String, dynamic> json) {
    return InstallationStage(
      stageId: json['stageId'] ?? '',
      stageName: json['stageName'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'Pending',
      startedAt: json['startedAt'] != null ? DateTime.tryParse(json['startedAt']) : null,
      completedAt: json['completedAt'] != null ? DateTime.tryParse(json['completedAt']) : null,
      checklist: (json['checklist'] as List<dynamic>?)
          ?.map((item) => InstallationChecklistItem.fromJson(item))
          .toList(),
      technicianNotes: json['technicianNotes'],
      photographs: List<String>.from(json['photographs'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'stageId': stageId,
    'stageName': stageName,
    'description': description,
    'status': status,
    'startedAt': startedAt?.toIso8601String(),
    'completedAt': completedAt?.toIso8601String(),
    'checklist': checklist?.map((item) => item.toJson()).toList(),
    'technicianNotes': technicianNotes,
    'photographs': photographs,
  };
}

class InstallationChecklistItem {
  final String itemId;
  final String task;
  final bool completed;
  final String? notes;

  InstallationChecklistItem({
    required this.itemId,
    required this.task,
    required this.completed,
    this.notes,
  });

  factory InstallationChecklistItem.fromJson(Map<String, dynamic> json) {
    return InstallationChecklistItem(
      itemId: json['itemId'] ?? '',
      task: json['task'] ?? '',
      completed: json['completed'] ?? false,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() => {
    'itemId': itemId,
    'task': task,
    'completed': completed,
    'notes': notes,
  };
}
