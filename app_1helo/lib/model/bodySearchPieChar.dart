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
  })  : frCreatedDate = _formatDate(frCreatedDate),
        toCreatedDate = _formatDate(toCreatedDate);

  /// Convert DateTime to 'yyyy-MM-dd' format or return null if input is null
  static String? _formatDate(DateTime? date) {
    return date != null ? DateFormat('yyyy-MM-dd').format(date) : null;
  }

  /// Convert the object to JSON
  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'employeeId': employeeId,
      'frCreatedDate': frCreatedDate,
      'toCreatedDate': toCreatedDate,
    };
  }
}
