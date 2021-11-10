import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pageContent/venue_page_header.dart';
import 'selectTimeGrid/select_time_grid.dart';
import 'package:instad_venue/models/timeslot.dart';
import 'venueBottomSheet/venue_bottom_sheet.dart';
import 'package:instad_venue/data/booking_selections.dart';
import 'pageContent/venue_info.dart';
import 'pageContent/header_text.dart';
import 'package:provider/provider.dart';
import 'package:instad_venue/functions/merge_date_time.dart';
import 'selectDayGrid/select_day_grid.dart';
import 'locationSnapshot/location_snapshot.dart';

class VenueProfilePage extends StatefulWidget {
  static String id = "venue_page";
  final Widget venueImage;
  final String venueName;
  final String venueArea;
  final double venueRating;
  final int venueDistance;
  final bool approved;
  final String venueId;
  final List venueSports;
  final int venuePrice;
  final GeoPoint location;
  final List venueAmenities;
  const VenueProfilePage({
    Key key,
    this.venueImage,
    this.venueId,
    this.approved,
    this.venueName,
    this.venueArea,
    this.venueRating,
    this.venueDistance,
    this.venueSports,
    this.venuePrice,
    this.location,
    this.venueAmenities,
  }) : super(key: key);

  @override
  _VenueProfilePageState createState() => _VenueProfilePageState();
}

final _firestore = FirebaseFirestore.instance;

class VenueListStream extends StatelessWidget {
  const VenueListStream({Key key, this.homePage}) : super(key: key);

  final bool homePage;
  @override
  Widget build(BuildContext context) {}
}

class _VenueProfilePageState extends State<VenueProfilePage> {
  final _firestore = FirebaseFirestore.instance;
  DateTime selectedDateTime;
  QuerySnapshot querySnapshot;
  dynamic data;
  _showCalendar() {
    if (querySnapshot != null) {
      List<Timeslot> collection;
      var showData = querySnapshot.docs;
      List<dynamic> key = showData.toList();
      if (showData != null) {
        showData.forEach((element) {
          data = showData;
          collection ??= <Timeslot>[];
          collection.add(Timeslot(
            bookingName: element.data()['bookingName'],
            time: element.data()['startTime'].toDate(),
          ));
        });
      }
    }
  }

  List<Timeslot> timeslotsAM = [];
  List<Timeslot> timeslotsPM = [];
  String headerText = "AMENITIES";
  List<String> amenities = [
    "Ball",
    "Bibs",
    "Bathroom",
    "Drinks",
    "Prayer Area",
  ];

  bool isAm = true;

  bool isFavorite = true;
  var _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    Provider.of<BookingSelections>(context, listen: false).clearSelections();
    return StreamBuilder<DocumentSnapshot>(
        stream:
            _firestore.collection('locations').doc(widget.venueId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.green,
              ),
            );
          }

          timeslotsPM.clear();
          timeslotsAM.clear();
          final field = snapshot.data;
          final List openTimes = field.data()['timeSlots'];
          final List bookedTimes = field.data()['bookedSlots'];
          List<Timeslot> timeslots = [];
          List<Timeslot> bookedslots = [];
          for (Timestamp stamp in openTimes) {
            timeslots.add(Timeslot(time: stamp));
          }
          for (Timestamp stamp in bookedTimes) {
            bookedslots.add(Timeslot(time: stamp));
          }
          openTimes.sort();
          bookedTimes.sort();
          for (Timeslot timeslot in timeslots) {
            Timeslot selectedBooking = Timeslot(
                time: mergeDayTime(
                    timeslot.time,
                    Provider.of<BookingSelections>(context, listen: true)
                        .getSelectedDay()));
            bool _booked = false;
            for (Timestamp stamp in bookedTimes) {
              if (stamp.toDate().hour == selectedBooking.time.toDate().hour &&
                  stamp.toDate().day == selectedBooking.time.toDate().day &&
                  stamp.toDate().month == selectedBooking.time.toDate().month &&
                  stamp.toDate().year == selectedBooking.time.toDate().year) {
                _booked = true;
                print("contains booking)");
                break;
              }
            }
            if (bookedTimes.contains(selectedBooking)) {
              print("contains booking");
              _booked = true;
            }
            if (timeslot.time.toDate().isBefore(
                  DateTime(
                      timeslot.time.toDate().year,
                      timeslot.time.toDate().month,
                      timeslot.time.toDate().day,
                      12),
                )) {
              timeslotsAM.add(Timeslot(booked: _booked, time: timeslot.time));
            } else {
              timeslotsPM.add(Timeslot(booked: _booked, time: timeslot.time));
            }
          }
          timeslotsPM.sort((a, b) => a.time.compareTo(b.time));
          timeslotsAM.sort((a, b) => a.time.compareTo(b.time));
          return StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('locations')
                .doc(widget.venueId)
                .collection("bookings")
                .snapshots(),
            builder: (context, snapshot) {
              final field = snapshot.data;
              field.docs.forEach((element) {
                for (Timeslot slot in bookedslots) {
                  if ((element.data()["startTime"]) == slot.time) {
                    slot.bookingName = element.data()["bookingName"];
                    slot.bookingNumber = element.data()["phoneNumber"];
                    slot.bookingId = element.id;
                  }
                }
              });
              return SafeArea(
                child: Scaffold(
                  backgroundColor: Color(0xFFF7F8F8),
                  body: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        elevation: 30,
                        toolbarHeight: 50,
                        expandedHeight: 227,
                        pinned: true,
                        floating: true,
                        flexibleSpace: FlexibleSpaceBar(
                          background:
                              VenuePageHeader(venueImage: widget.venueImage),
                        ),
                      ),
                      SliverToBoxAdapter(
                          child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, left: 24, right: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VenueInfo(
                              sports: widget.venueSports,
                              area: widget.venueArea,
                              name: widget.venueName,
                              distance: widget.venueDistance,
                              rating: widget.venueRating,
                              price: widget.venuePrice,
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: HeaderText(headerText: "SELECT DAY")),
                            Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(17.0),
                                color: const Color(0xffffffff),
                              ),
                              child: SelectDayGrid(
                                isFilterVersion: false,
                                selectedDay: Provider.of<BookingSelections>(
                                        context,
                                        listen: true)
                                    .getSelectedDay(),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: HeaderText(headerText: "SELECT TIME")),
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: SelectTimeGrid(
                                isAm: true,
                                childrenList: timeslotsAM,
                                isAmenitiesGrid: false,
                                dayselected: Provider.of<BookingSelections>(
                                        context,
                                        listen: true)
                                    .getSelectedDay(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: SelectTimeGrid(
                                isAm: false,
                                childrenList: timeslotsPM,
                                isAmenitiesGrid: false,
                                dayselected: Provider.of<BookingSelections>(
                                        context,
                                        listen: true)
                                    .getSelectedDay(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: HeaderText(headerText: "AMENITIES"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: SelectTimeGrid(
                                isAm: false,
                                childrenList: widget.venueAmenities,
                                isAmenitiesGrid: true,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: HeaderText(headerText: "LOCATION"),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 16.0, bottom: 0),
                              child: LocationSnapshot(widget: widget),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                  bottomNavigationBar: (Provider.of<BookingSelections>(context,
                              listen: true)
                          .timeslotSelected())
                      ? VenueBottomSheet(
                          venueName: widget.venueName,
                          venueArea: widget.venueArea,
                          venuePrice: widget.venuePrice,
                          venueId: widget.venueId,
                          bookings: (Provider.of<BookingSelections>(context,
                                      listen: true)
                                  .timeslotSelected()
                              ? Provider.of<BookingSelections>(context,
                                      listen: true)
                                  .getBookings()
                              : [
                                  Provider.of<BookingSelections>(context,
                                          listen: true)
                                      .getSelectedBookedBooking()
                                ]),
                          daySelected: Provider.of<BookingSelections>(context,
                                  listen: true)
                              .getSelectedDay(),
                          isBooked: false,
                          bookingId: widget.venueId,
                        )
                      : (Provider.of<BookingSelections>(context, listen: true)
                                  .selectedBookedBooking !=
                              null)
                          ? VenueBottomSheet(
                              venueName: widget.venueName,
                              venueArea: widget.venueArea,
                              venuePrice: widget.venuePrice,
                              venueId: widget.venueId,
                              bookings: (Provider.of<BookingSelections>(context,
                                          listen: true)
                                      .timeslotSelected()
                                  ? Provider.of<BookingSelections>(context,
                                          listen: true)
                                      .getBookings()
                                  : [
                                      Provider.of<BookingSelections>(context,
                                              listen: true)
                                          .getSelectedBookedBooking()
                                    ]),
                              daySelected: Provider.of<BookingSelections>(
                                      context,
                                      listen: true)
                                  .getSelectedDay(),
                              isBooked: true,
                              bookingId: widget.venueId,
                            )
                          : Container(
                              height: 0,
                            ),
                ),
              );
            },
          );
        });
  }
}
