class ForgotPasswordModel {
  final String? email;
  final String? otp;
  final String? password;
  final String? tokenId;

  ForgotPasswordModel({this.email, this.otp, this.password, this.tokenId});

  factory ForgotPasswordModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordModel(
      email: json['email'] as String?,
      otp: json['otp'] as String?,
      password: json['password'] as String?,
      tokenId: json['token_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
      'password': password,
      'tokenId': tokenId,
    };
  }
}
