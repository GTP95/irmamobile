import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import '../theme/theme.dart';
import 'irma_themed_button.dart';

class IrmaTextButton extends StatelessWidget {
  final String? label;
  final double minWidth;
  final VoidCallback? onPressed;
  final TextStyle? textStyle;
  final IrmaButtonSize? size;

  const IrmaTextButton({
    Key? key,
    this.label,
    this.onPressed,
    this.textStyle,
    this.size,
    this.minWidth = 232,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = IrmaTheme.of(context);
    final fixedHeight = size?.value ?? 45.0;

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        primary: theme.secondary,
        minimumSize: Size(minWidth, fixedHeight),
        maximumSize: Size.fromHeight(fixedHeight),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      child: Text(
        label != null ? FlutterI18n.translate(context, label!) : '',
        style: textStyle ?? theme.textTheme.button!.copyWith(color: theme.secondary),
        textAlign: TextAlign.center,
      ),
    );
  }
}
