class Dropdownbranchs {
  String? label;
  String? value;

  Dropdownbranchs({this.label, this.value});

  Dropdownbranchs.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['value'] = this.value;
    return data;
  }
}
