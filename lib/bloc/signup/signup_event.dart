
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class SignupEvent extends Equatable{
  const SignupEvent();
  @override
  List<Object> get props=>[];
}

class SignupStart extends SignupEvent {
}

class SignupPressedButton extends SignupEvent {
  String username;
  String password;
  String role;


  SignupPressedButton({
    required this.username,
    required this.password,
    required this.role,
  });
}