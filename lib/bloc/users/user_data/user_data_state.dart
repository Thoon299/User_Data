import 'package:equatable/equatable.dart';

abstract class UserDataState extends Equatable{
  @override
  List<Object> get props => [];
}

class UserDataInitialize extends UserDataState{}

class UserDataLoading extends UserDataState{}

class UserDataLoaded extends UserDataState{
  String msg;
  UserDataLoaded({required this.msg});
}

class UserDataError extends UserDataState{
  final String errorMessage;
  UserDataError({required this.errorMessage});
}
