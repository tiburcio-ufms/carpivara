import 'address.dart';
import 'user.dart';

class Ride {
  int? id;
  int driverId;
  User? driver;
  int? passengerId;
  User? passenger;
  List<Address> addresses;
  DateTime requestDate;
  DateTime? confirmationDate;
  DateTime? startDate;
  DateTime? endDate;

  Ride({
    this.id,
    required this.driverId,
    this.driver,
    this.passengerId,
    this.passenger,
    required this.addresses,
    required this.requestDate,
    this.confirmationDate,
    this.startDate,
    this.endDate,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      id: json['id'],
      driverId: json['driver_id'],
      driver: json['driver'] != null ? User.fromJson(json['driver'] as Map<String, dynamic>) : null,
      passengerId: json['passenger_id'],
      passenger: json['passenger'] != null ? User.fromJson(json['passenger'] as Map<String, dynamic>) : null,
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
      'driver_id': driverId,
      if (driver != null) 'driver': driver!.toJson(),
      if (passengerId != null) 'passenger_id': passengerId,
      if (passenger != null) 'passenger': passenger!.toJson(),
      'addresses': addresses.map((address) => address.toJson()).toList(),
      'request_date': requestDate.toIso8601String(),
      if (confirmationDate != null) 'confirmation_date': confirmationDate!.toIso8601String(),
      if (startDate != null) 'start_date': startDate!.toIso8601String(),
      if (endDate != null) 'end_date': endDate!.toIso8601String(),
    };
  }
}
