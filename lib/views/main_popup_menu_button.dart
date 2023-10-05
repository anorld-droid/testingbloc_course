import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testingbloc_course/bloc/app_bloc.dart';
import 'package:testingbloc_course/bloc/app_event.dart';
import 'package:testingbloc_course/dialogs/delete_account_dialog.dart';
import 'package:testingbloc_course/dialogs/logout_dialog.dart';

enum MenuAction { logOut, deleteAccount }

class MainPopupMenuButton extends StatelessWidget {
  const MainPopupMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuAction>(
      onSelected: (value) async {
        switch (value) {
          case MenuAction.logOut:
            final shouldLogout = await showLogOutDialog(context: context);
            if (shouldLogout) {
              // ignore: use_build_context_synchronously
              context.read<AppBloc>().add(
                    const AppEventLogout(),
                  );
            }
            break;
          case MenuAction.deleteAccount:
            final shouldDeleteAccount =
                await showDeleteAccountDialog(context: context);
            if (shouldDeleteAccount) {
              // ignore: use_build_context_synchronously
              context.read<AppBloc>().add(
                    const AppEventDeleteAccount(),
                  );
            }
            break;
        }
        ;
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: MenuAction.logOut,
          child: Text('Log Out'),
        ),
        const PopupMenuItem(
          value: MenuAction.deleteAccount,
          child: Text('Delete Account'),
        ),
      ],
    );
  }
}
