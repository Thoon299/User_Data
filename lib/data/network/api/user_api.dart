
import 'package:user_data_system/data/network/api/constants/endpoints.dart';
import 'package:user_data_system/models/UserListModel.dart';

import '../../../di/components/service_locator.dart';
import '../../../models/UserPostResponse.dart';
import '../dio_client.dart';

class UsersApi {
  // dio instance
  final DioClient _dioClient;


  // injecting dio instance
  UsersApi(this._dioClient);


  Future<UserListModel> getUsers() async {
    final res = await _dioClient.get(Endpoints.baseUrl+Endpoints.users_list);
    return UserListModel.fromJson(res);
  }

  //post
  Future<UserPostResponse> userEdit({required user_id,required formData}) async {
    final res=await _dioClient.put(Endpoints.baseUrl+Endpoints.user_edit+"/$user_id",data: formData);
    return UserPostResponse.fromJson(res);
  }

  //data
  Future<UserPostResponse> dataPost({required formData}) async {
    final res=await _dioClient.post(Endpoints.baseUrl+Endpoints.user_data,data: formData);
    return UserPostResponse.fromJson(res);
  }



  Future<UserPostResponse> userDelete( {required user_id}) async {
    final res = await _dioClient.delete(Endpoints.baseUrl+Endpoints.user_delete+"/$user_id");
    return UserPostResponse.fromJson(res);
  }

  Future<UserPostResponse> userPhotoUpload( {required user_id, required formData}) async {
    final res = await _dioClient.post(Endpoints.baseUrl+Endpoints.user_photo_upload+"/$user_id",data: formData);
    return UserPostResponse.fromJson(res);
  }
}