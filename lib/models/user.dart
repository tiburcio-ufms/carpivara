class User {
  String passport;
  String name;
  String course;
  String profilePic;

  User({required this.passport, required this.name, required this.course, required this.profilePic});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      passport: json['passport'],
      name: json['name'],
      course: json['course'],
      profilePic: json['profile_picture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'passport': passport,
      'name': name,
      'course': course,
      'profile_picture': profilePic,
    };
  }
}
