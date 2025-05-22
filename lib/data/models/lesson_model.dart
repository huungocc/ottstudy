class LessonModel {
  String? id;
  String? lessonName;
  String? fileUrl;
  String? fileType;
  String? testId;

  LessonModel({
    this.id,
    this.lessonName,
    this.fileUrl,
    this.fileType,
    this.testId,
  });

  LessonModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    lessonName = json['lesson_name'];
    fileUrl = json['file_url'];
    fileType = json['file_type'];
    testId = json['test_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['lesson_name'] = lessonName;
    data['file_url'] = fileUrl;
    data['file_type'] = fileType;
    data['test_id'] = testId;
    return data;
  }
}
