import 'package:flutter/cupertino.dart';
import 'package:instad_venue/models/booking.dart';
import 'package:instad_venue/models/timeslot.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_details.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firestore = FirebaseFirestore.instance;
UserDetails user = UserDetails();

class BookingSelections extends ChangeNotifier {
  void setUserDetails(String name, String number) {}
  DateTime _selectedDay = DateTime.now();
  String latestBookingId;
  Booking latestBooking;
  List<Timeslot> _selectedBookings = [];
  Timeslot selectedBookedBooking;
  bool isSelected(Timeslot selectedBooking) {
    //selectedBooking = mergeDayTime(selectedBooking, _selectedDay);
    return (_selectedBookings
            .where((element) => element.time == selectedBooking.time)
            .isNotEmpty ||
        (selectedBookedBooking != null &&
            selectedBookedBooking.time == selectedBooking.time));
  }

  void setSelectedDay(DateTime selectedDay) {
    _selectedDay = selectedDay;
    notifyListeners();
  }

  DateTime getSelectedDay() {
    return _selectedDay;
  }

  String getLatestBookingId() {
    return latestBookingId;
  }

  Booking getLatestBooking() {
    return latestBooking;
  }

  void clearSelections() {
    _selectedBookings.clear();
    notifyListeners();
  }

  void addToBookings(Timeslot selectedBooking) {
    //selectedBooking = mergeDayTime(selectedBooking, _selectedDay);
    _selectedBookings.add(selectedBooking);
    _selectedBookings.sort((a, b) => a.time.compareTo(b.time));
    notifyListeners();
  }

  void setSelectedBookedBooking(Timeslot selectedBooking) {
    //selectedBooking = mergeDayTimes(selectedBooking, _selectedDay);
    selectedBookedBooking = selectedBooking;
    notifyListeners();
  }

  void removeSelectedBookedBooking() {
    //selectedBooking = mergeDayTime(selectedBooking, _selectedDay);
    selectedBookedBooking = null;
    notifyListeners();
  }

  Timeslot getSelectedBookedBooking() {
    //selectedBooking = mergeDayTime(selectedBooking, _selectedDay);
    print(selectedBookedBooking.time);
    print(selectedBookedBooking.bookingName);
    return selectedBookedBooking;
  }

  void removeFromBookings(Timeslot selectedBooking) {
    //selectedBooking = mergeDayTime(selectedBooking, _selectedDay);
    _selectedBookings
        .removeWhere((element) => element.time == selectedBooking.time);
    print(_selectedBookings);
    notifyListeners();
  }

  bool timeslotSelected() {
    return !_selectedBookings.isEmpty;
  }

  List<Timeslot> getBookings() {
    /*List<Timeslot> bookings = [];
    for (var booking in _selectedBookings) {
      bookings.add(booking.time.toDate().hour);
    }*/
    return _selectedBookings;
  }

  void bookVenue(String venueId, UserDetails userDetails) {
    //print("logged in user: " + user.loggedInUserID);
    var timestampList = List<Timestamp>.generate(
        _selectedBookings.length, (index) => _selectedBookings[index].time);
    print("List " + timestampList.toString());
    print("booking venue " + venueId);
    _firestore.collection('locations').doc(venueId).update({
      "bookedSlots": FieldValue.arrayUnion(timestampList),
    });
    if (_selectedBookings.length > 0) {
      _firestore
          .collection("locations")
          .doc(venueId)
          .collection("bookings")
          .add({
        'bookingName': userDetails.userName,
        'phoneNumber': userDetails.userNumber,
        'startTime': _selectedBookings[0].time.toDate(),
        'endTime': _selectedBookings[_selectedBookings.length - 1]
            .time
            .toDate()
            .add(Duration(hours: 1)),
        'userId': FirebaseAuth.instance.currentUser.uid,
        'price': _selectedBookings.length * 200
      });
      _firestore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection("bookings")
          .add({
        'bookingName': userDetails.userName,
        'phoneNumber': userDetails.userNumber,
        'startTime': _selectedBookings[0].time.toDate(),
        'endTime': _selectedBookings[_selectedBookings.length - 1]
            .time
            .toDate()
            .add(Duration(hours: 1)),
        'location': venueId,
        'price': _selectedBookings.length * 200,
      }).then((value) => latestBookingId = value.id);
      latestBooking = Booking(
          phoneNumber: userDetails.userNumber,
          name: userDetails.userName,
          startTime: DateTime.fromMicrosecondsSinceEpoch(
              _selectedBookings[0].time.microsecondsSinceEpoch),
          isAllDay: false,
          price: _selectedBookings.length * 200,
          endTime: DateTime.fromMicrosecondsSinceEpoch(
              (_selectedBookings[_selectedBookings.length - 1])
                      .time
                      .microsecondsSinceEpoch +
                  3600000000));
    }
  }
}
