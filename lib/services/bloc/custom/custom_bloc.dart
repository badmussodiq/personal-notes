import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/auth_exceptions.dart';
import '../../auth/auth_providers.dart';
import '../../auth/auth_users.dart';
import 'custom_event.dart';
import 'custom_state.dart';

class CustomBloc extends Bloc<CustomEvent, CustomState> {
  CustomBloc(AuthProvider provider) : super(CustomState.unknown()) {

    // initialize handler when application is loading
    on<CustomEventInitialize>((event, emit) async {
      await provider.initialize();
      var user = provider.currentUser;

      if (user == null) {
        // emit(state.copyWith(isLoading: false));
        emit(CustomState.loggedOut(exception: null));
      } else if (!user.isEmailVerified) {
        emit(CustomState.verifying());
      } else {
        await provider.reload();
        user = provider.currentUser;
        emit(CustomState.loggedIn(user!));
      }
    });

    // handle registration
    on<CustomEventRegister>((event, emit) async {
      emit(state.copyWith(isLoading: true, exception: null));
      try {
        AuthUser authUser = await provider.createUser(
          email: event.email,
          password: event.password,
        );

        // send email verification
        if (!authUser.isEmailVerified) {
          await provider.sendEmailVerification();
          emit(CustomState.verifying());
        }
      } on GeneralException catch (e) {
        // emit the exception to general exception state.
        emit(CustomState.loggedOut(exception: e));
      }
    });

    // login event handler
    on<CustomEventLogin>((event, emit) async {
      emit(state.copyWith(isLoading: true, exception: null));
      try {
        final user = await provider.logIn(
          email: event.email,
          password: event.password,
        );
        if (!user.isEmailVerified) {
          emit(CustomState.verifying());
        } else {
          emit(CustomState.loggedIn(user));
        }
      } on GeneralException catch (e) {
        emit(CustomState.loggedOut(exception: e));
      }
    });

    // logout event handler
    on<CustomEventLogout>((event, emit) async {
      emit(state.copyWith(isLoading: true, exception: null));
      try {
        await provider.logOut();
        emit(CustomState.loggedOut());
      } on GeneralException catch (e) {
        emit(CustomState.loggedOut(exception: e));
      }
    });

    //
    on<CustomEventSendEmailVerification>((event, emit) async {
      // emit(const AuthStateLoading());
      emit(CustomState.verifying());
      try {
        await provider.sendEmailVerification();
        emit(state);

      } on GeneralException catch (e) {
        emit(CustomState.loggedOut(exception: e));
      }
    });
  }
}
