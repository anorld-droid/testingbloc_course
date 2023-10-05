import 'package:flutter/material.dart' show BuildContext;
import 'package:testingbloc_course/dialogs/generic_dialog.dart';

Future<bool> showDeleteAccountDialog({
  required BuildContext context,
}) =>
    showGenericDialog<bool>(
      content:
          'Are you sure you want to delete this account? You cannot undo this operation.',
      title: 'Delete Account',
      context: context,
      optionsBuilder: () => {
        'Cancel': false,
        'Delete Account': true,
      },
    ).then((value) => value ?? false);
