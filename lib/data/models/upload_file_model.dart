class UploadFileModel {
  String? path;
  String? fileName;
  String? fileType;

  UploadFileModel({this.path, this.fileName});

  UploadFileModel.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    fileName = json['file_name'];
    fileType = json['file_type'];
  }
}