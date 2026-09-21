class AssignmentModel {
  final String id;
  final String applicationId;
  final String businessName;
  final String instrumentId;
  final String instrumentType;
  final String status;
  final DateTime scheduledDate;

  AssignmentModel({
    required this.id,
    required this.applicationId,
    required this.businessName,
    required this.instrumentId,
    required this.instrumentType,
    required this.status,
    required this.scheduledDate,
  });

  factory AssignmentModel.fromMap(
    String id,
    Map<String, dynamic> data,
  ) {
    return AssignmentModel(
      id: id,
      applicationId: data['applicationId'] ?? '',
      businessName: data['businessName'] ?? '',
      instrumentId: data['instrumentId'] ?? '',
      instrumentType: data['instrumentType'] ?? '',
      status: data['status'] ?? '',
      scheduledDate:
          DateTime.parse(data['scheduledDate']),
    );
  }
}