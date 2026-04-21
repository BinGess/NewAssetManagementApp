// Returns an error message string if invalid, null if valid.

String? validateRequired(String? value, {String fieldName = '此字段'}) {
  if (value == null || value.trim().isEmpty) {
    return '$fieldName不能为空';
  }
  return null;
}

String? validatePositiveNumber(String? value, {String fieldName = '金额'}) {
  if (value == null || value.trim().isEmpty) {
    return '$fieldName不能为空';
  }
  final number = double.tryParse(value.trim());
  if (number == null) {
    return '请输入有效的数字';
  }
  if (number <= 0) {
    return '$fieldName必须大于0';
  }
  return null;
}

String? validateRate(String? value) {
  if (value == null || value.trim().isEmpty) return null; // Rate is optional
  final number = double.tryParse(value.trim());
  if (number == null) return '请输入有效的利率';
  if (number < 0 || number > 100) return '利率必须在0到100之间';
  return null;
}
