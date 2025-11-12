class Address {
  int? id;
  int userId;
  String street;
  String number;
  String neighborhood;
  String complement;
  String city;
  String state;
  String country;
  String postalCode;
  String nickname;
  double? latitude;
  double? longitude;

  Address({
    this.id,
    required this.userId,
    required this.street,
    required this.number,
    required this.neighborhood,
    required this.complement,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    required this.nickname,
    this.latitude,
    this.longitude,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      userId: json['user_id'],
      street: json['street'],
      number: json['number'],
      neighborhood: json['neighborhood'],
      complement: json['complement'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      postalCode: json['postal_code'],
      nickname: json['nickname'],
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'street': street,
      'number': number,
      'neighborhood': neighborhood,
      'complement': complement,
      'city': city,
      'state': state,
      'country': country,
      'postal_code': postalCode,
      'nickname': nickname,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    };
  }
}
