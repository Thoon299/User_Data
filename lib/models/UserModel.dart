class UserModel{
  User? user;

  UserModel({this.user});


  UserModel.fromJson(Map<String, dynamic> json) {
    user =
    json['user'] != null ? new User.fromJson(json['user']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }

    return data;
  }
}

class User {
  int? userId;
  String? username;
  String? role;
  String? profilePhoto;
  String? profilePhotoLink;

  User(
      {this.username,
        this.userId,
        this.role,
        this.profilePhoto,
        this.profilePhotoLink});

  User.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    userId = json['userId'];
    role = json['role'];
    profilePhoto = json['profilePhoto'];
    profilePhotoLink = json['profilePhotoLink'];

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