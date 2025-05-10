class UserModel {
  String? email;
  String? role;
  String? fullName;
  String? avatarUrl;
  String? studentCode;
  int? grade;
  String? phoneNumber;
  String? birthDate;
  String? token;

  UserModel(
      {this.email, this.role, this.fullName, this.avatarUrl, this.studentCode, this.token, this.grade, this
          .phoneNumber, this.birthDate});

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    role = json['role'];
    fullName = json['fullName'];
    avatarUrl = json['avatarUrl'];
    studentCode = json['studentCode'];
    token = json['token'];
    grade = json['grade'];
    phoneNumber = json['phoneNumber'];
    birthDate = json['birthDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['role'] = this.role;
    data['fullName'] = this.fullName;
    data['avatarUrl'] = this.avatarUrl;
    data['studentCode'] = this.studentCode;
    data['token'] = this.token;
    data['grade'] = this.grade;
    data['phoneNumber'] = this.phoneNumber;
    data['birthDate'] = this.birthDate;
    return data;
  }
}