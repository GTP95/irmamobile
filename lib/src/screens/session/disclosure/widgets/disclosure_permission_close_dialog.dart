import 'package:flutter/material.dart';

import '../../../../widgets/irma_confirmation_dialog.dart';

class DisclosurePermissionCloseDialog extends StatelessWidget {
  static Future<void> show(BuildContext context) async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => DisclosurePermissionCloseDialog(),
        ) ??
        false;
    if (confirmed) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) => const IrmaConfirmationDialog(
        titleTranslationKey: 'disclosure_permission.confirm_close_dialog.title',
        contentTranslationKey: 'disclosure_permission.confirm_close_dialog.explanation',
        confirmTranslationKey: 'disclosure_permission.confirm_close_dialog.confirm',
        cancelTranslationKey: 'disclosure_permission.confirm_close_dialog.decline',
        nudgeCancel: true,
      );
}
