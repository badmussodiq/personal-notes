import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_begining/services/auth/auth_providers.dart';
import 'package:new_begining/services/auth/bloc/auth_events.dart';
import 'package:new_begining/services/auth/bloc/auth_state.dart';

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

    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;

      if (user == null) {
        emit(const AuthStateLoggedOut());
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification());
      } else {
        emit(AuthStateLoggedIn(user: user));
      }
    });


    // login event handler
    on<AuthEventLogin>((event, emit) async {
      emit(const AuthStateLoading());
      try {
        final user = await provider.logIn(
          email: event.email,
          password: event.password,
        );
        emit(AuthStateLoggedIn(user: user));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e));
      }
    });

    // logout event handler
    on<AuthEventLogout>((event, emit) async {
      emit(const AuthStateLoading());
      try {
        await provider.logOut();
        emit(const AuthStateLoggedOut());
      } on Exception catch (e) {
        emit(AuthStateLoggedOutFailure(exception: e));
      }
    });
  }
}
