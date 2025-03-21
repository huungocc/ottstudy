class UserModel {
  String? userName;
  int? age;
  String? address;

  @override
  UserModel.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    age = json['age'];
    address = json['address'];
  }
}
