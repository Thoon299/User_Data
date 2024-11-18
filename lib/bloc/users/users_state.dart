import 'package:equatable/equatable.dart';

import '../../models/UserListModel.dart';


abstract class UsersState extends Equatable{
  @override
  List<Object> get props => [];
}

class UsersEmpty extends UsersState {}

class UsersLoading extends UsersState{}

class UsersLoaded extends UsersState{
  final UserListModel userListModel;
  UsersLoaded({required this.userListModel});
}

class UsersError extends UsersState{
  final String errorMessage;
  UsersError({required this.errorMessage});
}


