import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testingbloc_course/bloc/app_bloc.dart';
import 'package:testingbloc_course/bloc/app_state.dart';
import 'package:testingbloc_course/bloc/bloc_events.dart';

extension ToList on String {
  Uint8List toUint8List() => Uint8List.fromList(codeUnits);
}

enum Errors {
  dummy,
}

final test1Data = 'Foo'.toUint8List();
final test2Data = 'Bar'.toUint8List();

void main() {
  //Initial State
  blocTest<AppBloc, AppState>(
    'Initial State of the bloc should be empty',
    build: () => AppBloc(
      allUrls: [],
    ),
    verify: (appBloc) => expect(
      appBloc.state,
      const AppState.empty(),
    ),
  );

  //Load valid data and compare states
  blocTest<AppBloc, AppState>(
    'Load valid data and compare states',
    build: () => AppBloc(
      allUrls: [],
      urlPicker: (_) => '',
      urlLoader: (_) => Future.value(test1Data),
    ),
    act: (appBloc) => appBloc.add(
      const LoadNextUrlEvent(),
    ),
    expect: () => [
      const AppState(
        isLoading: true,
        data: null,
        error: null,
      ),
      AppState(
        isLoading: false,
        data: test1Data,
        error: null,
      ),
    ],
  );

  //Test for throwing an error and catching it
  blocTest<AppBloc, AppState>(
    'Throw an error in url loader then catch it',
    build: () => AppBloc(
      allUrls: [],
      urlPicker: (_) => '',
      urlLoader: (_) => Future.error(Errors.dummy),
    ),
    act: (appBloc) => appBloc.add(
      const LoadNextUrlEvent(),
    ),
    expect: () => [
      const AppState(
        isLoading: true,
        data: null,
        error: null,
      ),
      const AppState(
        isLoading: false,
        data: null,
        error: Errors.dummy,
      ),
    ],
  );

  //Load valid data and compare states
  blocTest<AppBloc, AppState>(
    'Test loading more than one url',
    build: () => AppBloc(
      allUrls: [],
      urlPicker: (_) => '',
      urlLoader: (_) => Future.value(test2Data),
    ),
    act: (appBloc) {
      appBloc.add(
        const LoadNextUrlEvent(),
      );
      appBloc.add(
        const LoadNextUrlEvent(),
      );
    },
    expect: () => [
      const AppState(
        isLoading: true,
        data: null,
        error: null,
      ),
      AppState(
        isLoading: false,
        data: test2Data,
        error: null,
      ),
      const AppState(
        isLoading: true,
        data: null,
        error: null,
      ),
      AppState(
        isLoading: false,
        data: test2Data,
        error: null,
      ),
    ],
  );
}
