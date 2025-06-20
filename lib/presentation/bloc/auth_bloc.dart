import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lockitem_movil/domain/entities/user_entity.dart';
import 'package:lockitem_movil/domain/usecases/login_user.dart';
import 'package:lockitem_movil/domain/usecases/signup_user.dart';
import 'package:lockitem_movil/core/error/failures.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final SignupUser signupUser;

  AuthBloc({required this.loginUser, required this.signupUser}) : super(AuthInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
    on<SignupButtonPressed>(_onSignupButtonPressed);
    on<LogoutButtonPressed>(_onLogoutButtonPressed);
  }

  Future<void> _onLoginButtonPressed(
      LoginButtonPressed event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    final result = await loginUser(event.email, event.password);
    result.fold(
          (failure) {
        if (failure is ServerFailure) {
          emit(AuthFailure(failure.message));
        } else if (failure is NetworkFailure) {
          emit(AuthFailure(failure.message));
        } else if (failure is InvalidInputFailure) {
          emit(AuthFailure(failure.message));
        } else {
          emit(const AuthFailure('Ocurrió un error inesperado durante el login.'));
        }
      },
          (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> _onSignupButtonPressed(
      SignupButtonPressed event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    final result = await signupUser(
      firstName: event.firstName,
      lastName: event.lastName,
      email: event.email,
      password: event.password,
    );
    result.fold(
          (failure) {
        if (failure is ServerFailure) {
          emit(AuthFailure(failure.message));
        } else if (failure is NetworkFailure) {
          emit(AuthFailure(failure.message));
        } else if (failure is InvalidInputFailure) {
          emit(AuthFailure(failure.message));
        } else {
          emit(const AuthFailure('Ocurrió un error inesperado durante el registro.'));
        }
      },
          (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> _onLogoutButtonPressed( // Nuevo manejador
      LogoutButtonPressed event,
      Emitter<AuthState> emit,
      ) async {
    print("Logout pressed, returning to AuthInitial state.");
    emit(AuthInitial());
  }
}