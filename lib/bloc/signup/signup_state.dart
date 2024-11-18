
import 'package:equatable/equatable.dart';

import '../../models/UserModel.dart';

abstract class SignupState extends Equatable{
  // final String message;
  const SignupState();

  @override
  List<Object> get props => [];
}

class SignupInitialized extends SignupState {
}

class SignupLoading extends SignupState {
}

class SignupError extends SignupState {
  final String errorMessage;
  SignupError({required this.errorMessage});
}

class SignupSuccess extends SignupState {
  String message;
  final UserModel userModel;


  SignupSuccess({required this.message, required this.userModel });
}
