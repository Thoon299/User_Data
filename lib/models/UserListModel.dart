
class UserListModel {
  List<ListData>? list;

  UserListModel({this.list, });

  factory UserListModel.fromJson(Map<String,dynamic> json){
    List<dynamic> data = json['users'];
    List<ListData> list = <ListData>[];

    data.forEach((element) {
      var item = ListData.fromJson(element);
      list.add(item);
    });


    return UserListModel(
      list: list,
    );
  }
}


class ListData {
  int? userId;
  String? username;
  String? role;
  String? profilePhoto;
  String? profilePhotoLink;

  ListData(
      {this.username,
        this.userId,
        this.role,
        this.profilePhoto,
        this.profilePhotoLink});

  ListData.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    userId = json['userId'];
    role = json['role']??'';
    profilePhoto = json['profilePhoto']??'';
    profilePhotoLink = json['profilePhotoLink']??'';

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['userId'] = this.userId;
    data['role'] = this.role;
    data['profilePhoto'] = this.profilePhoto;
    data['profilePhotoLink'] = this.profilePhotoLink;
    return data;
  }

}
