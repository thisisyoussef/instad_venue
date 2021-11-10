import 'dart:math';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instad_venue/models/timeslot_data.dart';
import 'package:flutter/material.dart';
import 'package:instad_venue/models/venue_list.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:instad_venue/models/booking.dart';

class CalendarScreen extends StatefulWidget {
  static String id = "calendar_screen";

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  refreshCalendar() {
    setState(() {});
  }

  final _firestore = FirebaseFirestore.instance;
  DateTime selectedDateTime;
  QuerySnapshot querySnapshot;
  dynamic data;
  List<Color> _colorCollection;
  _showCalendar() {
    if (querySnapshot != null) {
      List<Booking> collection;
      var showData = querySnapshot.docs;
      List<dynamic> key = showData.toList();
      if (showData != null) {
        showData.forEach((element) {
          data = showData;
          collection ??= <Booking>[];
          collection.add(Booking(
            name: element.data()['bookingName'],
            isAllDay: false,
            isRecurring: false,
            startTime:
                DateTime.parse(element.data()['startTime'].toDate().toString()),
            endTime:
                DateTime.parse(element.data()['endTime'].toDate().toString()),
          ));
        });
      } else {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      return SafeArea(
          child: Container(
        height: MediaQuery.of(context).size.height -
            MediaQuery.of(context).size.height * 0.1,
        child: SfCalendar(
          showNavigationArrow: true,
          todayHighlightColor: Color(0xFF2B8116),
          backgroundColor: const Color(0xFFF4F6F8),
          view: CalendarView.week,
          timeSlotViewSettings: TimeSlotViewSettings(
            startHour: 0,
            endHour: 24,
          ),
          firstDayOfWeek: DateTime.now().weekday,
          monthViewSettings: MonthViewSettings(showAgenda: true),
          dataSource: _getCalendarDataSource(collection),
        ),
      ));
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  void _initializeEventColor() {
    this._colorCollection = new List<Color>();
    _colorCollection.add(const Color(0xFF0F8644));
  }

  BookingDataSource _getCalendarDataSource([List<Booking> collection]) {
    List<Booking> meetings = collection ?? <Booking>[];
    print(meetings);
    return BookingDataSource(meetings);
  }

  getDataFromDatabase() async {
    print((Provider.of<VenueList>(context, listen: false).venues[0].venueName));
    var value = await _firestore
        .collection("locations")
        .doc(((Provider.of<VenueList>(context, listen: false)
            .venues[0]
            .venueId)))
        .collection("bookings")
        .get();
    print(value);
    var getValue = await value;
    print(value);
    return getValue;
  }

  @override
  void initState() {
    _initializeEventColor();
    getDataFromDatabase().then((results) {
      setState(() {
        if (results != null) {
          querySnapshot = results;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimeSlotData>(builder:
        (BuildContext context, TimeSlotData timeSlotData, Widget child) {
      return Scaffold(
        body: _showCalendar(),
        floatingActionButton: Stack(
          children: [
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.05,
              right: 0,
              child: FloatingActionButton(onPressed: () async {
                await showModalBottomSheet(
                  context: context,
                  backgroundColor: const Color(0xFF2B8116),
                  isScrollControlled: true,
                  builder: (context) => SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Container(),
                    ),
                  ),
                );
                initState();
              }),
            ),
          ],
        ),
      );
    });
  }
}

class BookingDataSource extends CalendarDataSource {
  BookingDataSource(List<Booking> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].startTime;
  }

  Color getColor(int index) {
    return appointments[index].color;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].endTime;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }

  @override
  String getSubject(int index) {
    print(appointments[index].name);
    return appointments[index].name;
  }
}
