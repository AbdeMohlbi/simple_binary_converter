import 'package:flutter/services.dart';

class NumericRangeTextInputFormatter extends TextInputFormatter {
  final int maxValue;

  NumericRangeTextInputFormatter({required this.maxValue});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text;
    if (newText.isEmpty) {
      return newValue;
    }
    final int? newNumber = int.tryParse(newText);
    if (newNumber == null || newNumber > maxValue) {
      return oldValue;
    }
    return newValue;
  }
}
