class ApiResponse<T> {
  String? message;
  int? code;
  T? data;
  int? status;
  String? errMessage;
  int? errCode;

  ApiResponse.success({
    this.data,
    this.code,
    this.message,
    this.status,
    this.errMessage,
    this.errCode,
  });

  ApiResponse.error(this.errMessage, {this.data, this.code});

  bool get isSuccess => this.code != null && this.code == 200;
  bool get isStatusSuccess => this.status == 200;
}
