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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['value'] = this.value;
    return data;
  }
}
