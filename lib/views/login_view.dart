import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:testingbloc_course/views/email_textfield.dart';
import 'package:testingbloc_course/views/login_button.dart';
import 'package:testingbloc_course/views/password_textfield.dart';

class LoginView extends HookWidget {
  final OnLoginTapped onLoginTapped;
  const LoginView({
    super.key,
    required this.onLoginTapped,
  });

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    return Column(
      children: [
        EmailTextField(emailController: emailController),
        PasswordTextField(passwordController: passwordController),
        LoginButton(
          emailController: emailController,
          passwordController: passwordController,
          onLoginTapped: onLoginTapped,
        ),
      ],
    );
  }
}
