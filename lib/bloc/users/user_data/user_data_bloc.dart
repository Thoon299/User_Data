import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:user_data_system/bloc/users/user_data/user_data_event.dart';
import 'package:user_data_system/bloc/users/user_data/user_data_state.dart';
import 'package:user_data_system/models/UserPostResponse.dart';

import '../../../data/repository/user_data_repository.dart';


class UserDataBloc extends Bloc<UserDataEvent,UserDataState>{
  UserDataRepository userDataRepository;
  UserDataBloc(this.userDataRepository) : super(UserDataInitialize());

  @override
  Stream<UserDataState> mapEventToState(UserDataEvent event) async* {
    if (event is UserDataStart) {
      yield UserDataInitialize();
    }

    else if (event is UserDataPost) {
      yield UserDataLoading();
      try {

        var formData = FormData.fromMap({
          'userId': event.userId,
          'latitude': event.latitude,
          'longitude': event.longitude,

        });
        UserPostResponse userPostResponse =  await userDataRepository.userDataPost(
            formData: formData);
        yield UserDataLoaded(msg: userPostResponse.msg.toString());
      }
      catch (e) {

        yield UserDataError(errorMessage: e.hashCode.toString());
      }
    }


  }


}