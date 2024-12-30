class ColumnChar {
  int? month;
  int? coNumber;
  int? vatNumber;
  int? importDeclarationNumber;
  int? exportDeclarationNumber;
  int? userNumber;

  ColumnChar({
    this.month,
    this.coNumber,
    this.vatNumber,
    this.importDeclarationNumber,
    this.exportDeclarationNumber,
    this.userNumber,
  });

  factory ColumnChar.fromJson(Map<String, dynamic> json) {
    return ColumnChar(
      month: json['month'],
      coNumber: json['co_number'],
      vatNumber: json['vat_number'],
      importDeclarationNumber: json['import_declaration_number'],
      exportDeclarationNumber: json['export_declaration_number'],
      userNumber: json['user_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'co_number': coNumber,
      'vat_number': vatNumber,
      'import_declaration_number': importDeclarationNumber,
      'export_declaration_number': exportDeclarationNumber,
      'user_number': userNumber,
    };
  }
}
