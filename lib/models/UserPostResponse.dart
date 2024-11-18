class UserPostResponse{
  String? msg;

  UserPostResponse({this.msg});

  UserPostResponse.fromJson(Map<String, dynamic> json) {
    msg = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.msg;
    return data;
  }
}