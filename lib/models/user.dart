class User {
  int id;
  String passport;
  String name;
  String course;
  String profilePic;
  String rating;
  String ridesAsDriver;
  String ridesAsPassenger;
  String semester;
  String? carModel;
  String? carPlate;
  bool isWoman;

  User({
    required this.id,
    required this.passport,
    required this.name,
    required this.course,
    required this.profilePic,
    required this.rating,
    required this.ridesAsDriver,
    required this.ridesAsPassenger,
    required this.semester,
    required this.isWoman,
    this.carModel,
    this.carPlate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      passport: json['passport'],
      name: json['name'],
      course: json['course'],
      profilePic: json['profile_picture'],
      rating: json['rating'],
      ridesAsDriver: json['rides_as_driver'],
      ridesAsPassenger: json['rides_as_passenger'],
      semester: json['semester'],
      isWoman: json['is_woman'],
      carModel: json['car_model'],
      carPlate: json['car_plate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'passport': passport,
      'name': name,
      'course': course,
      'profile_picture': profilePic,
      'rating': rating,
      'rides_as_driver': ridesAsDriver,
      'rides_as_passenger': ridesAsPassenger,
      'semester': semester,
      'is_woman': isWoman,
      if (carModel != null) 'car_model': carModel,
      if (carPlate != null) 'car_plate': carPlate,
    };
  }
}
