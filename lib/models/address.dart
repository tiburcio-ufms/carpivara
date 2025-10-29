class Address {
  int userId;
  String street;
  String number;
  String neighborhood;
  String complement;
  String city;
  String state;
  String country;
  String postalCode;

  Address({
    required this.userId,
    required this.street,
    required this.number,
    required this.neighborhood,
    required this.complement,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      userId: json['user_id'],
      street: json['street'],
      number: json['number'],
      neighborhood: json['neighborhood'],
      complement: json['complement'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      postalCode: json['postal_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'street': street,
      'number': number,
      'neighborhood': neighborhood,
      'complement': complement,
      'city': city,
      'state': state,
      'country': country,
      'postal_code': postalCode,
    };
  }
}
