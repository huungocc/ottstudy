class RegistrationModel {
  String? id;
  String? userId;
  String? courseId;
  String? status;
  double? finalTestScore;
  bool? finalTestPassed;
  String? studentAvatar;
  String? studentName;
  String? studentCode;
  bool? isApproval;

  RegistrationModel({
    this.id,
    this.userId,
    this.courseId,
    this.status,
    this.finalTestScore,
    this.finalTestPassed,
    this.studentAvatar,
    this.studentName,
    this.studentCode,
    this.isApproval
  });

  factory RegistrationModel.fromJson(Map<String, dynamic> json) {
    return RegistrationModel(
      id: json['_id'] as String?,
      userId: json['user_id'] as String?,
      courseId: json['course_id'] as String?,
      status: json['status'] as String?,
      finalTestScore: json['final_test_score'] != null
          ? (json['final_test_score'] as num).toDouble()
          : null,
      finalTestPassed: json['final_test_passed'] as bool?,
      studentAvatar: json['student_avatar'] as String?,
      studentName: json['student_name'] as String?,
      studentCode: json['student_code'] as String?
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user_id': userId,
      'course_id': courseId,
      'status': status,
      'final_test_score': finalTestScore,
      'final_test_passed': finalTestPassed,
      'student_avatar': studentAvatar,
      'student_name': studentName,
      'student_code': studentCode
    };
  }
}

extension RegistrationModelCopyWith on RegistrationModel {
  RegistrationModel copyWith({
    String? id,
    String? userId,
    String? courseId,
    String? status,
    double? finalTestScore,
    bool? finalTestPassed,
    String? studentAvatar,
    String? studentName,
    String? studentCode,
    bool? isApproval,
  }) {
    return RegistrationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      courseId: courseId ?? this.courseId,
      status: status ?? this.status,
      finalTestScore: finalTestScore ?? this.finalTestScore,
      finalTestPassed: finalTestPassed ?? this.finalTestPassed,
      studentAvatar: studentAvatar ?? this.studentAvatar,
      studentName: studentName ?? this.studentName,
      studentCode: studentCode ?? this.studentCode,
      isApproval: isApproval ?? this.isApproval,
    );
  }
}

