import 'package:flutter/material.dart' show BuildContext;
import 'package:testingbloc_course/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog({
  required BuildContext context,
}) =>
    showGenericDialog<bool>(
      content: 'Are you sure you want to log out.',
      title: 'Log Out',
      context: context,
      optionsBuilder: () => {
        'Cancel': false,
        'Log out': true,
      },
    ).then(
      (value) => value ?? false,
    );
