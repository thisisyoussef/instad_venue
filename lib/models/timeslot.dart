import 'package:cloud_firestore/cloud_firestore.dart';

class Timeslot {
  Timeslot(
      {this.bookingName,
      this.bookingNumber,
      this.bookingEmail,
      this.bookingId,
      this.booked,
      this.time});
  bool booked;
  Timestamp time;
  String bookingId;
  String bookingName;
  String bookingNumber;
  String bookingEmail;
}
