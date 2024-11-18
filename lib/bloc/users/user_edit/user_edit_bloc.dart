import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:user_data_system/bloc/users/user_edit/user_edit_event.dart';
import 'package:user_data_system/bloc/users/user_edit/user_edit_state.dart';
import 'package:user_data_system/models/UserPostResponse.dart';

import '../../../data/repository/user_repository.dart';


class UserEditBloc extends Bloc<UserEditEvent,UserEditState>{
  UsersRepository userEditRepository;
  UserEditBloc(this.userEditRepository) : super(UserEditInitialize());

  @override
  Stream<UserEditState> mapEventToState(UserEditEvent event) async* {
    if (event is UserEditStart) {
      yield UserEditInitialize();
    }

    else if (event is UserEditPost) {
      yield UserEditLoading();
      String? fileString;
      try {

        var jsonVar = {
          'username': event.username,
          'password': event.password,
          'role': event.role,
        };
        UserPostResponse userPostResponse =  await userEditRepository.userEdit(
          user_id: event.user_id,
            formData: jsonEncode(jsonVar));
        yield UserEditLoaded(msg: userPostResponse.msg.toString());
      }
      catch (e) {
        yield UserEditError(errorMessage: e.toString());
      }
    }

    //Upload Photo
    else if (event is UserPhotoUpload) {
      yield UserUploadPhotoLoading();
      String? fileString;
      try {
        fileString = event.file
            .path
            .split('/')
            .last;
        var formData = FormData.fromMap({
          'file': await MultipartFile.fromFile(
              event.file.path, filename: fileString)
        });

        UserPostResponse userPostResponse =  await userEditRepository.userPhotoUpload(
            user_id: event.user_id,
            formData: formData);
        yield UserUploadPhotoLoaded(msg: userPostResponse.msg.toString());
      }
      catch (e) {
        yield UserUploadPhotoError(errorMessage: e.toString());
      }
    }

    //Data
    //Upload Photo
    else if (event is DataPost) {
      yield DataPostLoading();
      String? fileString;
      try {
        var formData = FormData.fromMap({
          'userId': event.userId,
          'latitude': event.latitude,
          'longitude': event.longitude,

        });

        UserPostResponse userPostResponse =  await userEditRepository.dataPost(
            formData: formData);
        yield DataPostLoaded(msg: userPostResponse.msg.toString());
      }
      catch (e) {
        yield DataPostError(errorMessage: e.toString());
      }
    }

    //Delete

    else if (event is UserPhotoUploadStart) {
      yield UserUploadPhotoInitialized();
    }

    else if(event is FetchUserDelete){
      yield UserDeleteLoading();
      try{
        UserPostResponse userPostResponse=await userEditRepository.userDelete(
             user_id: event.user_id);

      }
      catch (e){
        yield UserDeleteError(errorMessage: e.toString());
      }
    }


  }




}