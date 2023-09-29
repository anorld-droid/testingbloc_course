import 'package:flutter/foundation.dart' show immutable;
import 'package:testingbloc_course/models.dart';

@immutable
abstract class LoginAPiProtocol {
  const LoginAPiProtocol();

  Future<LoginHandle?> login({
    required final String email,
    required final String password,
  });
}

@immutable
class LoginApi implements LoginAPiProtocol {
  // Singleton Pattern
  // const LoginApi._sharedInstance();
  // static const LoginApi _shared = LoginApi._sharedInstance();
  // factory LoginApi.instance() => _shared;

  @override
  Future<LoginHandle?> login({
    required String email,
    required String password,
  }) =>
      Future.delayed(
        const Duration(seconds: 2),
        () => email == 'foo@bar.com' && password == 'foobar',
      ).then((isLoggedIn) => isLoggedIn ? const LoginHandle.foobar() : null);
}
