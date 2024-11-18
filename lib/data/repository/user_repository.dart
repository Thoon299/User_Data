
import 'package:user_data_system/data/network/api/user_api.dart';
import 'package:user_data_system/models/UserListModel.dart';

import '../../models/UserPostResponse.dart';

class UsersRepository {
  //api object
  final UsersApi usersApi;

  UsersRepository(this.usersApi);

  Future<UserListModel> getUsers() async {
    return usersApi.getUsers();
  }
  //post
  Future<UserPostResponse> userEdit({required user_id,required formData})async{
    return usersApi.userEdit(user_id: user_id,formData: formData);
  }


  //delete

  Future<UserPostResponse> userDelete({required user_id}) async {
    return usersApi.userDelete(user_id: user_id);
  }

  //upload photo

  Future<UserPostResponse> userPhotoUpload({required user_id, required formData}) async {
    return usersApi.userPhotoUpload(user_id: user_id, formData: formData);
  }

  //data
  Future<UserPostResponse> dataPost({required formData}) async {
    return usersApi.dataPost(formData: formData);
  }

}