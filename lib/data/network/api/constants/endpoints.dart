
class Endpoints {
  Endpoints._();
  // receiveTimeout
  static const int receiveTimeout = 15000;
  // connectTimeout[kwf]
  static const int connectionTimeout = 30000;
  static const String baseUrl = "http://103.215.194.85:6006/";

  static const String users_list= "api/user/all";
  static const String user_edit = "api/user/update";
  static const String user_delete = "api/user/delete";
  static const String user_photo_upload = "upload-photo";
  static const String user_data = "api/user/sync-location";

}



