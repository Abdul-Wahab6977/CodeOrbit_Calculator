import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/calculator_controller.dart';
import '../utils/constants.dart';
import '../utils/theme.dart';
import '../widgets/calc_button.dart';

/// The calculator's single screen: a two-row display on top and a
/// responsive button grid below. All state comes from
/// [CalculatorController] via `Consumer` — this widget has no business
/// logic of its own.
class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<CalculatorController>(
          builder: (context, controller, _) {
            return Column(
              children: [
                Expanded(
                  flex: 2,
                  child: _DisplayArea(controller: controller),
                ),
                Expanded(
                  flex: 5,
                  child: _KeypadArea(controller: controller),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Top section: the two-row display (expression + result).
class _DisplayArea extends StatelessWidget {
  const _DisplayArea({required this.controller});

  final CalculatorController controller;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      alignment: Alignment.bottomRight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Small top row: the expression typed so far.
          Text(
            controller.expressionText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 20,
              color: isDark ? Colors.white54 : Colors.black45,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          // Bold bottom row: the live/final result, auto-shrinks to fit.
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              controller.resultText,
              maxLines: 1,
              style: TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.bold,
                color: controller.hasError
                    ? AppColors.errorRed
                    : (isDark ? Colors.white : Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom section: the responsive button grid.
class _KeypadArea extends StatelessWidget {
  const _KeypadArea({required this.controller});

  final CalculatorController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: CalcConstants.keypad.map((row) {
          return Expanded(
            child: Row(
              children: row.map((label) {
                // The last row's "0" key spans two columns, matching
                // common calculator conventions — implemented with an
                // Expanded flex factor rather than a hardcoded width so
                // it stays responsive on every screen size.
                final isWideZero = label == '0' && row.length == 3;
                return Expanded(
                  flex: isWideZero ? 2 : 1,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: CalcButton(
                      label: label,
                      type: _typeFor(label),
                      onTap: () => _handleTap(controller, label),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }

  CalcButtonType _typeFor(String label) {
    if (label == CalcConstants.equals) return CalcButtonType.equals;
    if (CalcConstants.operators.contains(label)) return CalcButtonType.operatorKey;
    if (label == CalcConstants.clear ||
        label == CalcConstants.backspace ||
        label == CalcConstants.percent) {
      return CalcButtonType.function;
    }
    return CalcButtonType.number;
  }

  void _handleTap(CalculatorController controller, String label) {
    switch (label) {
      case CalcConstants.clear:
        controller.clearAll();
        break;
      case CalcConstants.backspace:
        controller.backspace();
        break;
      case CalcConstants.percent:
        controller.inputPercent();
        break;
      case CalcConstants.decimal:
        controller.inputDecimal();
        break;
      case CalcConstants.equals:
        controller.evaluate();
        break;
      default:
        if (CalcConstants.operators.contains(label)) {
          controller.inputOperator(label);
        } else {
          controller.inputDigit(label);
        }
    }
  }
}
