class TestModel {
  String? id;
  int? time;
  double? minimumScore;
  List<String>? questions;

  TestModel({
    this.id,
    this.time,
    this.minimumScore,
    this.questions
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