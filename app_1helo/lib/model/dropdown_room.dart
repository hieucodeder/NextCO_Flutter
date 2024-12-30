class Dropdownroom {
  String? label;
  String? value;

  Dropdownroom({this.label, this.value});

  Dropdownroom.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    // Handle type mismatch by converting the value to a String
    value = json['value']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['value'] = value;
    return data;
  }
}
