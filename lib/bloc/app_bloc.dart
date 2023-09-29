import 'package:bloc/bloc.dart';
import 'package:testingbloc_course/apis/login_api.dart';
import 'package:testingbloc_course/apis/notes_api.dart';
import 'package:testingbloc_course/bloc/actions.dart';
import 'package:testingbloc_course/bloc/app_state.dart';
import 'package:testingbloc_course/models.dart';

class AppBloc extends Bloc<AppAction, AppState> {
  final LoginAPiProtocol loginApi;
  final NotesApiProtocol notesApi;

  AppBloc({
    required this.loginApi,
    required this.notesApi,
  }) : super(const AppState.empty()) {
    on<LoginAction>((event, emit) async {
      //Start loading
      emit(
        const AppState(
          isLoading: true,
          loginError: null,
          loginHandle: null,
          fetchedNotes: null,
        ),
      );

      //Login user
      final loginHandle = await loginApi.login(
        email: event.email,
        password: event.password,
      );
      emit(
        AppState(
          isLoading: false,
          loginError: loginHandle == null ? LoginErrors.invalidHandles : null,
          loginHandle: loginHandle,
          fetchedNotes: null,
        ),
      );
    });

    on<LoadNotesAction>((event, emit) async {
      //Start loading
      emit(
        AppState(
          isLoading: true,
          loginError: null,
          loginHandle: state.loginHandle,
          fetchedNotes: null,
        ),
      );

      //get the login handle
      final loginHandle = state.loginHandle;
      if (loginHandle != const LoginHandle.foobar()) {
        emit(
          AppState(
            isLoading: false,
            loginError: LoginErrors.invalidHandles,
            loginHandle: loginHandle,
            fetchedNotes: null,
          ),
        );
        return;
      }

      // we have a valid login handle and we want to fetch notes

      final notes = await NotesAPi().getNotes(
        loginHandle: loginHandle!,
      );
      emit(
        AppState(
          isLoading: false,
          loginError: null,
          loginHandle: loginHandle,
          fetchedNotes: notes,
        ),
      );
    });
  }
}
