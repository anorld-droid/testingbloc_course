import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testingbloc_course/auth/auth_error.dart';
import 'package:testingbloc_course/bloc/app_event.dart';
import 'package:testingbloc_course/bloc/app_state.dart';
import 'package:testingbloc_course/utils/upload_image.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc()
      : super(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        ) {
    on<AppEventGoToRegistration>((event, emit) {
      emit(
        const AppStateIsInRegistrationVIew(
          isLoading: false,
        ),
      );
    });
    on<AppEventLogIn>((event, emit) async {
      emit(
        const AppStateLoggedOut(isLoading: true),
      );

      final email = event.email;
      final password = event.password;

      try {
        final credentials = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        final user = credentials.user!;
        final images = await _getImages(user.uid);
        emit(
          AppStateLoggedIn(
            user: user,
            images: images,
            isLoading: false,
          ),
        );
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateLoggedOut(
            isLoading: false,
            authError: AuthError.from(e),
          ),
        );
      }
    });
    on<AppEventGoToLogin>((event, emit) {
      emit(
        const AppStateLoggedOut(isLoading: false),
      );
    });
    on<AppEventRegister>((event, emit) async {
      //Start loading
      emit(
        const AppStateIsInRegistrationVIew(
          isLoading: true,
        ),
      );

      final email = event.email;
      final password = event.password;

      try {
        final credentials = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        emit(
          AppStateLoggedIn(
            user: credentials.user!,
            images: const [],
            isLoading: false,
          ),
        );
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateIsInRegistrationVIew(
            isLoading: false,
            authError: AuthError.from(e),
          ),
        );
      }
    });
    on<AppEventInitialize>((event, emit) async {
      //Get the current user
      final user = FirebaseAuth.instance.currentUser;

      //Log user out if there is no credentials/userid
      if (user == null) {
        emit(
          const AppStateLoggedOut(isLoading: false),
        );
        return;
      }
      //Grab the user's uploaded images
      final images = await _getImages(user.uid);
      emit(
        AppStateLoggedIn(
          isLoading: false,
          user: user,
          images: images,
        ),
      );
    });
    //handle log out event
    on<AppEventLogout>((event, emit) async {
      //start loading
      emit(
        const AppStateLoggedOut(isLoading: true),
      );
      //Sign the user out
      await FirebaseAuth.instance.signOut();
      // log the user out in the ui
      emit(
        const AppStateLoggedOut(isLoading: false),
      );
    });
    //handle account deletion
    on<AppEventDeleteAccount>((event, emit) async {
      final user = FirebaseAuth.instance.currentUser;
      //Log user out if there is no credentials/userid
      if (user == null) {
        emit(
          const AppStateLoggedOut(isLoading: false),
        );
        return;
      }
      //Start Loading
      emit(
        AppStateLoggedIn(
          isLoading: true,
          user: user,
          images: state.images ?? [],
        ),
      );
      //Delete the user folder

      try {
        //Get the images folder
        final folder = await FirebaseStorage.instance.ref(user.uid).listAll();

        for (var item in folder.items) {
          await item.delete().catchError((_) {}); //Log the error
        }
        //delete the folder itself
        await FirebaseStorage.instance
            .ref(user.uid)
            .delete()
            .catchError((_) {});

        //Delete the user
        await user.delete();
        //Sign the user out
        await FirebaseAuth.instance.signOut();
        // log the user out in the ui
        emit(
          const AppStateLoggedOut(isLoading: false),
        );
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateLoggedIn(
            isLoading: false,
            user: user,
            images: state.images ?? [],
            authError: AuthError.from(e),
          ),
        );
      } on FirebaseException {
        //We might not be able to delete the folder
        // log the user out
        emit(
          const AppStateLoggedOut(isLoading: false),
        );
      }
    });
    //handle uploading images
    on<AppEventUploadImage>((event, emit) async {
      final user = state.user;
      //Log user out if there is no credentials/userid
      if (user == null) {
        emit(
          const AppStateLoggedOut(isLoading: false),
        );
        return;
      }

      //Start the loading process
      emit(
        AppStateLoggedIn(
          isLoading: true,
          user: user,
          images: state.images ?? [],
        ),
      );
      //Upload the file
      final file = File(event.filePathtoUpload);
      await uploadImage(
        file: file,
        userId: user.uid,
      );
      //After upload is complete grab the latest file refs
      final images = await _getImages(user.uid);
      //emit the new images and turn off loading
      emit(
        AppStateLoggedIn(
          user: user,
          images: images,
          isLoading: false,
        ),
      );
    });
  }

  Future<Iterable<Reference>> _getImages(String userId) =>
      FirebaseStorage.instance
          .ref(userId)
          .list()
          .then((listResults) => listResults.items);
}
