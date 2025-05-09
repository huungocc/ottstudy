class UploadFileModel {
  String? path;
  String? fileName;

  UploadFileModel({this.path, this.fileName});

  UploadFileModel.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    fileName = json['filename'];
  }
}