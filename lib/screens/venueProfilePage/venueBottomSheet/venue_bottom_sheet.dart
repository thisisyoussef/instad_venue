import 'package:flutter/material.dart';
import 'package:instad_venue/data/user_details.dart';
import 'package:instad_venue/generalWidgets/wide_rounded_button.dart';
import 'package:instad_venue/models/timeslot.dart';
import 'package:intl/intl.dart';
import 'slider_widget.dart';
import 'seperator.dart';
import 'booking_details_box.dart';

class VenueBottomSheet extends StatefulWidget {
  const VenueBottomSheet({
    Key key,
    this.venueName,
    this.venueArea,
    this.bookings,
    this.venuePrice,
    this.daySelected,
    this.venueId,
    this.isBooked,
    this.bookingId,
  }) : super(key: key);

  final String venueName;
  final String venueArea;
  final List<Timeslot> bookings;
  final int venuePrice;
  final DateTime daySelected;
  final String venueId;
  final bool isBooked;
  final String bookingId;

  @override
  State<VenueBottomSheet> createState() => _VenueBottomSheetState();
}

class _VenueBottomSheetState extends State<VenueBottomSheet> {
  String bookerName;
  String bookerNumber;
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      minChildSize: 0.21,
      maxChildSize: 0.45,
      initialChildSize: 0.21,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      Icon(Icons.horizontal_rule),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 32.0),
                                child: Text(
                                  'Total',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 16,
                                    color: const Color(0xff2e2e2e),
                                    letterSpacing: 0.8,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Text(
                                (widget.bookings.length * widget.venuePrice)
                                        .toString() +
                                    ' EGP',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 20,
                                  color: const Color(0xff2b8116),
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              color: const Color(0x6fffffff),
                              border: Border.all(
                                width: 1.0,
                                color: const Color(0xff2b8116),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7.0, vertical: 4),
                              child: Row(
                                children: [
                                  Text(
                                    'Details',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 16,
                                      color: const Color(0xff2b8116),
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: const Color(0xff2b8116),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: !widget.isBooked
                            ? SliderWidget(
                                venueId: widget.venueId,
                                userDetails: UserDetails(
                                    username: bookerName,
                                    usernumber: bookerNumber),
                              )
                            : WideRoundedButton(
                                title: widget.bookings[0].bookingName,
                                isEnabled: true,
                                color: Colors.redAccent,
                              ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12.0, horizontal: 1),
                  child: Seperator(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: BookingDetailBox(
                          type: "Location",
                          title: widget.venueName,
                          subtitle: widget.venueArea,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: BookingDetailBox(
                          type: "Calendar",
                          title: DateFormat.MMMd()
                              .format(widget.daySelected)
                              .toString(),
                          subtitle: widget.bookings,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12.0, horizontal: 1),
                  child: Seperator(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.venuePrice.toString(),
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 20,
                              color: const Color(0xff2e2e2e),
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'EGP/ Hour',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 17,
                                color: const Color(0xff2e2e2e),
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Row(
                          children: [
                            Text(
                              'Total',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                                color: const Color(0xff2e2e2e),
                              ),
                              textAlign: TextAlign.right,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                (widget.bookings.length * widget.venuePrice)
                                    .toString(),
                                style: TextStyle(
                                  fontFamily: 'Chakra Petch',
                                  fontSize: 23,
                                  color: const Color(0xff2b8116),
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Text(
                                'EGP',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 16,
                                  color: const Color(0xff2e2e2e),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
