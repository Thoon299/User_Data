

import 'package:user_data_system/models/UserPostResponse.dart';

import '../network/api/user_data_api.dart';

class UserDataRepository {
  //api object
  final UserDataApi userDataApi;

  UserDataRepository(this.userDataApi);


  //post
  Future<UserPostResponse> userDataPost({required formData})async{
    return userDataApi.userDataPost(formData: formData);
  }



}
