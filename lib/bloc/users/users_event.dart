import 'package:equatable/equatable.dart';

abstract class UsersEvent extends Equatable{
  const UsersEvent();
  @override
  List<Object> get props=>[];
}

// class ProfileStart extends ProfileEvent{}

class FetchUsers extends UsersEvent{
  FetchUsers();
}


