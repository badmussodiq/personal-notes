import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_begining/services/auth/auth_exceptions.dart';
import 'package:new_begining/services/auth/auth_providers.dart';
import 'package:new_begining/services/auth/auth_users.dart';
import 'package:new_begining/services/bloc/auth_events.dart';
import 'package:new_begining/services/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvents, AuthStates> {
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading()) {
    // initialize event handler
    // on<AuthEventInitialize>((event, emit) async {
    //   await provider.initialize();
    //   final user = provider.currentUser;
    //   if (user != null) {
    //     emit(AuthStateLoggedIn(user: user));
    //   } else if (user != null && !user.isEmailVerified) {
    //     emit(const AuthStateNeedsVerification());
    //   } else {
    //     emit(const AuthStateLoggedOut());
    //   }
    // });

    // initialize handler when application is loading
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      var user = provider.currentUser;

      if (user == null) {
        emit(const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
        ));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification());
      } else {
        await provider.reload();
        user = provider.currentUser;
        emit(AuthStateLoggedIn(user: user!));
      }
    });

    // handle registration
    on<AuthEventRegister>((event, emit) async {
      emit(const AuthStateLoading());
      try {
        AuthUser authUser = await provider.createUser(
          email: event.email,
          password: event.password,
        );

        // send email verification
        if (!authUser.isEmailVerified) {
          await provider.sendEmailVerification();
          emit(const AuthStateNeedsVerification());
        }
      } on GeneralException catch (e) {
        // emit the exception to general exception state.
        emit(
          GeneralExceptionState(exception: e, message: e.message, code: e.code),
        );
      }
    });

    // login event handler
    on<AuthEventLogin>((event, emit) async {
      emit(const AuthStateLoading());
      // emit(AuthStateLoggedOut(isLoading: true, exception: null));
      try {
        final user = await provider.logIn(
          email: event.email,
          password: event.password,
        );
        if (!user.isEmailVerified) {
          emit(AuthStateNeedsVerification());
        } else {
          emit(AuthStateLoggedIn(user: user));
        }
      } on GeneralException catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    });

    // logout event handler
    on<AuthEventLogout>((event, emit) async {
      emit(const AuthStateLoading());
      try {
        await provider.logOut();
        emit(const AuthStateLoggedOut(isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateLoggedOutFailure(exception: e));
      }
    });

    //
    on<AuthEventSendEmailVerification>((event, emit) async {
      // emit(const AuthStateLoading());
      try {
        await provider.sendEmailVerification();
        emit(state);
      } on UserNotLoggedInAuthException catch (e) {
        emit(AuthStateLoggedOut(exception: e as GeneralException, isLoading: false));
      }
    });
  }
}
