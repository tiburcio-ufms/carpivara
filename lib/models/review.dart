class Review {
  int userId;
  int rideId;
  int rating;

  Review({required this.userId, required this.rideId, required this.rating});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      userId: json['userId'],
      rideId: json['rideId'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'rideId': rideId,
      'rating': rating,
    };
  }
}
