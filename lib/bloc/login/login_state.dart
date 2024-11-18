
import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable{
  // final String message;
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitialized extends LoginState {
}

class LoginLoading extends LoginState {
}

class LoginError extends LoginState {
  final String errorMessage;
  LoginError({required this.errorMessage});
}

class LoginSuccess extends LoginState {
  String token;


  LoginSuccess({required this.token });
}
