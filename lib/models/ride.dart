import 'address.dart';

class Ride {
  int driverId;
  int passengerId;
  List<Address> addresses;
  DateTime requestDate;
  DateTime confirmationDate;
  DateTime startDate;
  DateTime endDate;

  Ride({
    required this.driverId,
    required this.passengerId,
    required this.addresses,
    required this.requestDate,
    required this.confirmationDate,
    required this.startDate,
    required this.endDate,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      driverId: json['driver_id'],
      passengerId: json['passenger_id'],
      addresses: json['addresses'],
      requestDate: json['request_date'],
      confirmationDate: json['confirmation_date'],
      startDate: json['start_date'],
      endDate: json['end_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driver_id': driverId,
      'passenger_id': passengerId,
      'addresses': addresses,
      'request_date': requestDate,
      'confirmation_date': confirmationDate,
      'start_date': startDate,
      'end_date': endDate,
    };
  }
}
