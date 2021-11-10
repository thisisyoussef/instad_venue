import 'package:flutter/material.dart';

class Booking {
  final String name;
  final String phoneNumber;
  final String uid;
  DateTime startTime;
  DateTime endTime;
  int price;
  Color color = const Color(0xFF2B8116);
  bool isRecurring = false;
  bool isAllDay = false;
  Booking(
      {this.name,
      this.phoneNumber,
      this.startTime,
      this.endTime,
      this.uid,
      this.price,
      @required this.isAllDay,
      @required this.isRecurring});
}
