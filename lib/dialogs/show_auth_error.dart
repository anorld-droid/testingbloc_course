import 'package:flutter/material.dart' show BuildContext;
import 'package:testingbloc_course/auth/auth_error.dart';
import 'package:testingbloc_course/dialogs/generic_dialog.dart';

Future<void> showAuthErrorDialog({
  required AuthError authError,
  required BuildContext context,
}) =>
    showGenericDialog<void>(
      title: authError.dialogTitle,
      content: authError.dialogText,
      context: context,
      optionsBuilder: () => {
        'OK': true,
      },
    );
