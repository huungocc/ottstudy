class QuestionModel {
  String? id;
  String? questionImage;
  String? answer;

  QuestionModel({
    this.id,
    this.questionImage,
    this.answer
  });

  QuestionModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    questionImage = json['question_image'];
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['question_image'] = questionImage;
    data['answer'] = answer;
    return data;
  }
}