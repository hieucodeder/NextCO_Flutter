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

  /// Format DateTime to 'yyyy-MM-dd' or return null if input is null
  static String? _formatDate(DateTime? date) {
    try {
      return date != null ? DateFormat('yyyy-MM-dd').format(date) : null;
    } catch (e) {
      print('Date formatting error: $e');
      return null;
    }
  }

  /// Convert the object to JSON
  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'employee_id': employeeId,
      'fr_created_date': frCreatedDate,
      'to_created_date': toCreatedDate,
    };
  }
}
