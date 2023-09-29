import 'package:flutter/foundation.dart' show immutable;
import 'package:testingbloc_course/models.dart';

@immutable
abstract class NotesApiProtocol {
  const NotesApiProtocol();

  Future<Iterable<Notes>?> getNotes({
    required LoginHandle loginHandle,
  });
}

@immutable
class NotesAPi implements NotesApiProtocol {
  @override
  Future<Iterable<Notes>?> getNotes({
    required LoginHandle loginHandle,
  }) =>
      Future.delayed(
        const Duration(seconds: 2),
        () => loginHandle == const LoginHandle.foobar() ? mockNotes : null,
      );
}
