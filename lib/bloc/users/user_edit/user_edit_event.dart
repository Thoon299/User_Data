import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class UserEditEvent extends Equatable{
  const UserEditEvent();

  @override
  List<Object> get props => [];
}

class UserEditStart extends UserEditEvent{}

class UserEditPost extends UserEditEvent{

  String username;
  String password;
  String role;
  String user_id;

  UserEditPost({required this.username, required this.password, required this.role, required this.user_id});
}



class FetchUserDelete extends UserEditEvent{
  String user_id;
  FetchUserDelete({required this.user_id});
}

class UserPhotoUploadStart extends UserEditEvent{}

class UserPhotoUpload extends UserEditEvent{
  String user_id;
  File file;
  UserPhotoUpload({required this.user_id, required this.file});
}




class DataPostStart extends UserEditEvent{}

class DataPost extends UserEditEvent{
  String userId;
  String latitude;
  String longitude;


  DataPost({required this.userId, required this.latitude, required this.longitude,
  });
}

