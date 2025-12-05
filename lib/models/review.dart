class Review {
  int? id;
  int userId;
  int rideId;
  int rating;
  String? comment;

  Review({
    this.id,
    required this.userId,
    required this.rideId,
    required this.rating,
    this.comment,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      userId: json['user_id'],
      rideId: json['ride_id'],
      rating: json['rating'],
      comment: json['comment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'ride_id': rideId,
      'rating': rating,
      if (comment != null) 'comment': comment,
    };
  }
}
