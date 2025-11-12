import 'address.dart';
import 'user.dart';

class Ride {
  int? id;
  User? driver;
  User passenger;
  List<Address> addresses;
  DateTime requestDate;
  DateTime? confirmationDate;
  DateTime? startDate;
  DateTime? endDate;

  Ride({
    this.id,
    this.driver,
    required this.passenger,
    required this.addresses,
    required this.requestDate,
    this.confirmationDate,
    this.startDate,
    this.endDate,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      id: json['id'],
      driver: User.fromJson(json['driver'] as Map<String, dynamic>),
      passenger: User.fromJson(json['passenger'] as Map<String, dynamic>),
      addresses:
          (json['addresses'] as List<dynamic>?)
              ?.map((address) => Address.fromJson(address as Map<String, dynamic>))
              .toList() ??
          [],
      requestDate: DateTime.parse(json['request_date'] as String),
      confirmationDate: json['confirmation_date'] != null ? DateTime.parse(json['confirmation_date'] as String) : null,
      startDate: json['start_date'] != null ? DateTime.parse(json['start_date'] as String) : null,
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (driver != null) 'driver': driver!.toJson(),
      'passenger': passenger.toJson(),
      'addresses': addresses.map((address) => address.toJson()).toList(),
      'request_date': requestDate.toIso8601String(),
      if (confirmationDate != null) 'confirmation_date': confirmationDate!.toIso8601String(),
      if (startDate != null) 'start_date': startDate!.toIso8601String(),
      if (endDate != null) 'end_date': endDate!.toIso8601String(),
    };
  }
}
