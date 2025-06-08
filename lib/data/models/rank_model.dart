class RankModel {
  String? id;
  String? avatarUrl;
  String? fullName;
  String? studentCode;
  int? studyTime;
  String? score;
  int? rank;

  RankModel(
      {this.id,
        this.avatarUrl,
        this.fullName,
        this.studentCode,
        this.studyTime,
        this.score,
        this.rank});

  RankModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    avatarUrl = json['avatar_url'];
    fullName = json['full_name'];
    studentCode = json['student_code'];
    studyTime = json['study_time'];
    score = json['score'];
    rank = json['rank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['avatar_url'] = this.avatarUrl;
    data['full_name'] = this.fullName;
    data['student_code'] = this.studentCode;
    data['study_time'] = this.studyTime;
    data['score'] = this.score;
    data['rank'] = this.rank;
    return data;
  }
}
