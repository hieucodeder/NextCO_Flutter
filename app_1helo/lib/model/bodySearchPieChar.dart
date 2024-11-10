class Bodysearchpiechar {
  final String? customerId;
  final String? employeeId;
  final String? frCreatedDate;
  final String? toCreatedDate;

  Bodysearchpiechar({
    this.customerId,
    this.employeeId,
    DateTime? frCreatedDate,
    DateTime? toCreatedDate,
  })  : frCreatedDate = frCreatedDate?.toIso8601String(),
        toCreatedDate = toCreatedDate?.toIso8601String();

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'employeeId': employeeId,
      'frCreatedDate': frCreatedDate,
      'toCreatedDate': toCreatedDate,
    };
  }
}
