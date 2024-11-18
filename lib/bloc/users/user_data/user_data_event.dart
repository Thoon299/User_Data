import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class UserDataEvent extends Equatable{
  const UserDataEvent();

  @override
  List<Object> get props => [];
}

class UserDataStart extends UserDataEvent{}

class UserDataPost extends UserDataEvent{
  String userId;
  String latitude;
  String longitude;


  UserDataPost({required this.userId, required this.latitude, required this.longitude,
   });
}

