class SignupModel {
  String? email;
  String? password;
  String? avatarUrl;
  String? fullName;
  String? birthDate;
  String? phoneNumber;
  int? grade;

  SignupModel({
    this.email,
    this.password,
    this.avatarUrl,
    this.fullName,
    this.birthDate,
    this.phoneNumber,
    this.grade,
  });

  factory SignupModel.fromJson(Map<String, dynamic> json) {
    return SignupModel(
      email: json['email'] as String?,
      password: json['password'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      fullName: json['full_name'] as String?,
      birthDate: json['birth_date'] as String?,
      phoneNumber: json['phone_number'] as String?,
      grade: json['grade'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'avatar_url': avatarUrl,
      'full_name': fullName,
      'birth_date': birthDate,
      'phone_number': phoneNumber,
      'grade': grade,
    };
  }
}
