import 'package:user_data_system/data/network/api/constants/endpoints.dart';
import 'package:user_data_system/models/UserPostResponse.dart';

import '../../../../di/components/service_locator.dart';
import '../dio_client.dart';


class UserDataApi {
  // dio instance
  final DioClient _dioClient;


  // injecting dio instance
  UserDataApi(this._dioClient);



  //post
  Future<UserPostResponse> userDataPost({required formData}) async {
    final res=await _dioClient.post(Endpoints.baseUrl+Endpoints.user_data,data: formData);
    return UserPostResponse.fromJson(res);
  }


}




