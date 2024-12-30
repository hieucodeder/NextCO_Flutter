class Dropdownbranchs {
  String? label;
  String? value;

  Dropdownbranchs({this.label, this.value});

  Dropdownbranchs.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['value'] = value;
    return data;
  }
}
