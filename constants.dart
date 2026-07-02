/// Static constants describing the calculator's key layout.
///
/// Keeping this separate from the UI means the button grid can be
/// reordered or localized without touching widget code.
class CalcConstants {
  CalcConstants._();

  static const String clear = 'AC';
  static const String backspace = '⌫';
  static const String percent = '%';
  static const String divide = '÷';
  static const String multiply = '×';
  static const String subtract = '-';
  static const String add = '+';
  static const String decimal = '.';
  static const String equals = '=';
  static const String errorMessage = 'Cannot divide by zero';
  static const String genericError = 'Error';

  static const List<String> operators = [add, subtract, multiply, divide];

  /// 5 rows x 4 columns, in on-screen order.
  static const List<List<String>> keypad = [
    [clear, backspace, percent, divide],
    ['7', '8', '9', multiply],
    ['4', '5', '6', subtract],
    ['1', '2', '3', add],
    ['0', decimal, equals],
  ];
}
