class TestModel {
  String? id;
  int? time;
  double? minimumScore;
  List<String>? questions;
  bool? isFinalTest;
  String? registrationId;
  bool? finalTestStatus;

  TestModel({
    this.id,
    this.time,
    this.minimumScore,
    this.questions,
    this.isFinalTest,
    this.registrationId,
    this.finalTestStatus
  });

  TestModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    time = json['time'];
    minimumScore = json['minimum_score'];
    questions = json['questions'] != null ? List<String>.from(json['questions']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['time'] = time;
    data['minimum_score'] = minimumScore;
    data['questions'] = questions;
    return data;
  }
}

extension TestModelCopyWith on TestModel {
  TestModel copyWith({
    String? id,
    int? time,
    double? minimumScore,
    List<String>? questions,
    bool? isFinalTest,
    String? registrationId,
    bool? finalTestStatus,
  }) {
    return TestModel(
      id: id ?? this.id,
      time: time ?? this.time,
      minimumScore: minimumScore ?? this.minimumScore,
      questions: questions ?? this.questions,
      isFinalTest: isFinalTest ?? this.isFinalTest,
      registrationId: registrationId ?? this.registrationId,
      finalTestStatus: finalTestStatus ?? this.finalTestStatus
    );
  }
}
