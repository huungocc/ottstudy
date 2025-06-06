class CourseModel {
  String? id;
  String? courseName;
  String? courseImage;
  String? teacher;
  int? grade;
  String? subjectId;
  String? description;
  int? studentCount;
  List<String>? lessons;
  String? finalTestId;
  bool? finalTestPassed;

  CourseModel({
    this.id,
    this.courseName,
    this.courseImage,
    this.teacher,
    this.grade,
    this.subjectId,
    this.description,
    this.studentCount,
    this.lessons,
    this.finalTestId,
    this.finalTestPassed
  });

  CourseModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    courseName = json['course_name'];
    courseImage = json['course_image'];
    teacher = json['teacher'];
    grade = json['grade'];
    subjectId = json['subject_id'];
    description = json['description'];
    studentCount = json['student_count'];
    finalTestId = json['final_test_id'];
    lessons = json['lessons'] != null ? List<String>.from(json['lessons']) : null;
    finalTestPassed = json['final_test_passed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['course_name'] = courseName;
    data['course_image'] = courseImage;
    data['teacher'] = teacher;
    data['grade'] = grade;
    data['subject_id'] = subjectId;
    data['description'] = description;
    data['student_count'] = studentCount;
    data['final_test_id'] = finalTestId;
    data['lessons'] = lessons;
    data['final_test_passed'] = finalTestPassed;
    return data;
  }
}
