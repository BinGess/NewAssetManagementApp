import 'package:flutter/material.dart';
import '../../core/utils/currency_formatter.dart';

class AmountText extends StatelessWidget {
  final double amount;
  final Color? color;
  final TextStyle? style;
  final bool showSign;

  const AmountText({
    super.key,
    required this.amount,
    this.color,
    this.style,
    this.showSign = false,
  });

  @override
  Widget build(BuildContext context) {
    final formatted = showSign && amount > 0
        ? '+${formatCNY(amount)}'
        : formatCNY(amount);
    final textStyle = (style ?? Theme.of(context).textTheme.bodyMedium)?.copyWith(
      color: color,
    );
    return Text(formatted, style: textStyle);
  }
}
