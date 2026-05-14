import 'package:flutter/material.dart';

import '../core/utils/format_utils.dart';

class PriceText extends StatelessWidget {
  const PriceText({
    super.key,
    required this.amount,
    this.style,
    this.color,
    this.textAlign,
  });

  final int amount;
  final TextStyle? style;
  final Color? color;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultStyle = theme.textTheme.titleMedium?.copyWith(
      color: color ?? theme.colorScheme.primary,
      fontWeight: FontWeight.w800,
    );

    return Text(
      FormatUtils.formatCurrency(amount),
      textAlign: textAlign,
      style: defaultStyle?.merge(style) ?? style,
    );
  }
}
