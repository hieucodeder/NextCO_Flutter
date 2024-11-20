import 'package:intl/intl.dart';

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
  })  : frCreatedDate = frCreatedDate != null
             ? DateFormat('yyyy-MM-ddTHH:mm:ss').format(frCreatedDate)
            : null,
        toCreatedDate = toCreatedDate != null
            ? DateFormat('yyyy-MM-ddTHH:mm:ss').format(toCreatedDate)
            : null;

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'employeeId': employeeId,
      'frCreatedDate': frCreatedDate,
      'toCreatedDate': toCreatedDate,
    };
  }
}
