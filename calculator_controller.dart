import 'package:flutter/foundation.dart';
import '../utils/constants.dart';

/// Pure business logic for the calculator, exposed as a [ChangeNotifier]
/// so the UI layer (via `provider`) can rebuild reactively.
///
/// This class knows nothing about Flutter widgets — it only manages an
/// expression as a list of tokens (numbers and operators) and exposes
/// derived, display-ready strings. That separation makes it trivially
/// unit-testable independent of any UI.
class CalculatorController extends ChangeNotifier {
  /// Tokens that make up the current expression, e.g. ["12", "+", "5"].
  /// Numbers and operators alternate; the last token may be a
  /// partially-typed number (e.g. "12." while the user is still typing).
  final List<String> _tokens = [];

  /// True once "=" has been pressed and a final result is being shown.
  /// The next digit press should start a brand-new expression.
  bool _justEvaluated = false;

  /// True when the current state represents an error (e.g. division by
  /// zero). Any input other than AC clears the error first.
  bool _hasError = false;
  String _errorMessage = '';

  bool get hasError => _hasError;

  /// The top, smaller display line: the full expression typed so far,
  /// e.g. "12 + 5 ×". Empty when nothing has been entered yet.
  String get expressionText => _tokens.join(' ');

  /// The bottom, bold display line: either the error message, the final
  /// result after "=", or the current in-progress number.
  String get resultText {
    if (_hasError) return _errorMessage;
    if (_tokens.isEmpty) return '0';
    return _tokens.last;
  }

  // ---------------------------------------------------------------------
  // Public input handlers — one per key type. Each mutates _tokens and
  // then calls notifyListeners() exactly once so the UI updates cleanly.
  // ---------------------------------------------------------------------

  void inputDigit(String digit) {
    _clearErrorIfNeeded();

    if (_justEvaluated) {
      // Starting a fresh calculation after a result was shown.
      _tokens.clear();
      _justEvaluated = false;
    }

    if (_tokens.isEmpty || _isOperator(_tokens.last)) {
      _tokens.add(digit == '0' ? '0' : digit);
    } else {
      final current = _tokens.last;
      // Avoid leading zeros like "007"; allow "0" -> "5" to become "5".
      if (current == '0') {
        _tokens[_tokens.length - 1] = digit;
      } else if (current.replaceAll('-', '').replaceAll('.', '').length < 12) {
        // Cap length so the display never overflows.
        _tokens[_tokens.length - 1] = current + digit;
      }
    }
    notifyListeners();
  }

  void inputDecimal() {
    _clearErrorIfNeeded();

    if (_justEvaluated) {
      _tokens.clear();
      _justEvaluated = false;
    }

    if (_tokens.isEmpty || _isOperator(_tokens.last)) {
      _tokens.add('0.');
    } else if (!_tokens.last.contains('.')) {
      // Strictly one decimal point per number.
      _tokens[_tokens.length - 1] = '${_tokens.last}.';
    }
    // If the current number already has a '.', the key press is ignored.
    notifyListeners();
  }

  void inputOperator(String operator) {
    _clearErrorIfNeeded();
    _justEvaluated = false;

    if (_tokens.isEmpty) {
      // Allow starting with "-" for a negative number; otherwise ignore
      // an operator with nothing to operate on yet.
      if (operator == CalcConstants.subtract) {
        _tokens.add('-');
      }
      return notifyListeners();
    }

    if (_isOperator(_tokens.last)) {
      // Prevent multiple consecutive operators (e.g. "5 + ×") by
      // replacing the previous operator instead of stacking them.
      _tokens[_tokens.length - 1] = operator;
    } else {
      _tokens.add(operator);
    }
    notifyListeners();
  }

  void inputPercent() {
    _clearErrorIfNeeded();
    if (_tokens.isEmpty || _isOperator(_tokens.last)) return;

    final value = double.tryParse(_tokens.last);
    if (value != null) {
      _tokens[_tokens.length - 1] = _formatNumber(value / 100);
      notifyListeners();
    }
  }

  void backspace() {
    _clearErrorIfNeeded();
    if (_tokens.isEmpty) return;

    final last = _tokens.last;
    if (last.length <= 1 || _isOperator(last)) {
      _tokens.removeLast();
    } else {
      _tokens[_tokens.length - 1] = last.substring(0, last.length - 1);
    }
    notifyListeners();
  }

  void clearAll() {
    _tokens.clear();
    _hasError = false;
    _errorMessage = '';
    _justEvaluated = false;
    notifyListeners();
  }

  void evaluate() {
    if (_tokens.isEmpty) return;

    // Drop a trailing operator so "12 +" evaluates as just "12".
    final cleanTokens = List<String>.from(_tokens);
    if (_isOperator(cleanTokens.last)) cleanTokens.removeLast();
    if (cleanTokens.isEmpty) return;

    final result = _evaluateTokens(cleanTokens);

    if (result == null) {
      _hasError = true;
      _errorMessage = CalcConstants.errorMessage;
      _tokens
        ..clear()
        ..add(CalcConstants.genericError);
      _justEvaluated = true;
      return notifyListeners();
    }

    _tokens
      ..clear()
      ..add(_formatNumber(result));
    _justEvaluated = true;
    notifyListeners();
  }

  // ---------------------------------------------------------------------
  // Internal helpers
  // ---------------------------------------------------------------------

  void _clearErrorIfNeeded() {
    if (_hasError) {
      _tokens.clear();
      _hasError = false;
      _errorMessage = '';
    }
  }

  bool _isOperator(String token) => CalcConstants.operators.contains(token);

  /// Evaluates a token list with standard operator precedence
  /// (× and ÷ before + and -), returning null on division by zero.
  double? _evaluateTokens(List<String> tokens) {
    // Pass 1: resolve × and ÷ left-to-right.
    final pass1 = <String>[tokens.first];
    for (var i = 1; i < tokens.length; i += 2) {
      final op = tokens[i];
      final nextValue = double.tryParse(tokens[i + 1]) ?? 0;

      if (op == CalcConstants.multiply || op == CalcConstants.divide) {
        final prevValue = double.tryParse(pass1.last) ?? 0;
        if (op == CalcConstants.divide && nextValue == 0) {
          return null; // Division by zero — signal error to the caller.
        }
        final combined =
            op == CalcConstants.multiply ? prevValue * nextValue : prevValue / nextValue;
        pass1[pass1.length - 1] = _formatNumber(combined);
      } else {
        pass1.add(op);
        pass1.add(tokens[i + 1]);
      }
    }

    // Pass 2: resolve + and - left-to-right on the reduced list.
    double result = double.tryParse(pass1.first) ?? 0;
    for (var i = 1; i < pass1.length; i += 2) {
      final op = pass1[i];
      final value = double.tryParse(pass1[i + 1]) ?? 0;
      result = op == CalcConstants.add ? result + value : result - value;
    }
    return result;
  }

  /// Formats a double for display: whole numbers drop the trailing ".0",
  /// and long decimals are trimmed to avoid overflowing the display.
  String _formatNumber(double value) {
    if (value.isNaN || value.isInfinite) return CalcConstants.genericError;
    if (value == value.roundToDouble() && value.abs() < 1e12) {
      return value.toInt().toString();
    }
    String formatted = value.toStringAsFixed(8);
    formatted = formatted.replaceAll(RegExp(r'0+$'), '');
    formatted = formatted.replaceAll(RegExp(r'\.$'), '');
    return formatted;
  }
}
