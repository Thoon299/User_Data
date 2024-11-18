
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class LoginEvent extends Equatable{
  const LoginEvent();
  @override
  List<Object> get props=>[];
}

class LoginStart extends LoginEvent {
}

class LoginPressedButton extends LoginEvent {
  String username;
  String password;


  LoginPressedButton({
    required this.username,
    required this.password,

  });
}