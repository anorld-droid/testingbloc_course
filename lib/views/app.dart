import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testingbloc_course/bloc/app_bloc.dart';
import 'package:testingbloc_course/bloc/app_event.dart';
import 'package:testingbloc_course/bloc/app_state.dart';
import 'package:testingbloc_course/dialogs/show_auth_error.dart';
import 'package:testingbloc_course/loading/loading_screen.dart';
import 'package:testingbloc_course/views/login_view.dart';
import 'package:testingbloc_course/views/photo_gallery_view.dart';
import 'package:testingbloc_course/views/register_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      create: (_) => AppBloc()
        ..add(
          const AppEventInitialize(),
        ),
      child: MaterialApp(
        title: 'Photo Library',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: BlocConsumer<AppBloc, AppState>(
          builder: (context, appState) {
            if (appState is AppStateLoggedOut) {
              return const LoginView();
            } else if (appState is AppStateLoggedIn) {
              return const PhotoGalleryView();
            } else if (appState is AppStateIsInRegistrationVIew) {
              return const RegisterView();
            } else {
              //This should never happen
              return Container();
            }
          },
          listener: (context, appState) {
            if (appState.isLoading) {
              LoadingScreen.instance()
                  .show(context: context, text: 'Loading...');
            } else {
              LoadingScreen.instance().hide();
            }
            final authError = appState.authError;
            if (authError != null) {
              showAuthErrorDialog(
                authError: authError,
                context: context,
              );
            }
          },
        ),
      ),
    );
  }
}
