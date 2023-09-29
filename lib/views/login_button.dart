import 'package:flutter/material.dart';
import 'package:testingbloc_course/dialogs/generic_dialog.dart';
import 'package:testingbloc_course/strings.dart';

typedef OnLoginTapped = void Function(
  String email,
  String password,
);

class LoginButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final OnLoginTapped onLoginTapped;
  const LoginButton({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onLoginTapped,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        final email = emailController.text;
        final pass = passwordController.text;
        if (email.isEmpty || pass.isEmpty) {
          showGenericDialog(
            context: context,
            title: emailOrPasswordEmptyDialogTitle,
            content: emailOrPasswordEmptyDescription,
            optionsBuilder: () => {
              ok: true,
            },
          );
        } else {
          onLoginTapped(
            email,
            pass,
          );
        }
      },
      child: const Text(login),
    );
  }
}
