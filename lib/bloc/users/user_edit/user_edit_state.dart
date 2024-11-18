import 'package:equatable/equatable.dart';

abstract class UserEditState extends Equatable{
  @override
  List<Object> get props => [];
}

class UserEditInitialize extends UserEditState{}

class UserEditLoading extends UserEditState{}

class UserEditLoaded extends UserEditState{
  String msg;
  UserEditLoaded({required this.msg});
}

class UserEditError extends UserEditState{
  final String errorMessage;
  UserEditError({required this.errorMessage});
}

//Delete

class UserDeleteEmpty extends UserEditState{}


class UserDeleteLoading extends UserEditState{}

class UserDeleteLoaded extends UserEditState{
  String msg;
  UserDeleteLoaded({required this.msg});
}

class UserDeleteError extends UserEditState{
  final String errorMessage;
  UserDeleteError({required this.errorMessage});
}


//Upload Photo

//Delete

class UserUploadPhotoEmpty extends UserEditState{}

class UserUploadPhotoInitialized extends UserEditState {
}
class UserUploadPhotoLoading extends UserEditState{}

class UserUploadPhotoLoaded extends UserEditState{
  String msg;
  UserUploadPhotoLoaded({required this.msg});
}

class UserUploadPhotoError extends UserEditState{
  final String errorMessage;
  UserUploadPhotoError({required this.errorMessage});
}

//data


class DataPostEmpty extends UserEditState{}

class DataPostInitialized extends UserEditState {
}
class DataPostLoading extends UserEditState{}

class DataPostLoaded extends UserEditState{
  String msg;
  DataPostLoaded({required this.msg});
}

class DataPostError extends UserEditState{
  final String errorMessage;
  DataPostError({required this.errorMessage});
}
