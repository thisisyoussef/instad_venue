import 'package:flutter/material.dart';
import 'package:instad_venue/generalWidgets/string_to_icon_data.dart';

class BookingDetailBox extends StatelessWidget {
  const BookingDetailBox({
    Key key,
    this.type,
    this.subtitle,
    this.title,
  }) : super(key: key);

  final String type;
  final String title;
  final dynamic subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          StringToIconData(type),
          size: 36,
          color: Color(0xFF2E2E2E),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 20,
                color: const Color(0xff2e2e2e),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.left,
            ),
            subtitle is List && subtitle.length > 1
                ? Column(children: [
                    Text(
                      (subtitle[0] > 12 && subtitle[subtitle.length - 1] > 12)
                          ? (subtitle[0] - 12).toString() +
                              " to " +
                              (subtitle[subtitle.length - 1] - 11).toString() +
                              " PM"
                          : (subtitle[0] < 12 &&
                                  subtitle[subtitle.length - 1] < 12)
                              ? subtitle[0].toString() +
                                  " to " +
                                  (subtitle[subtitle.length - 1] + 1)
                                      .toString() +
                                  " AM"
                              : subtitle[0].toString() +
                                  " AM" +
                                  " to " +
                                  (subtitle[subtitle.length - 1] - 11)
                                      .toString() +
                                  " PM",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                        color: const Color(0xff2e2e2e),
                        letterSpacing: 0.96,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ])
                : subtitle is List && subtitle.length == 1
                    ? Text(
                        (subtitle[0].time.toDate().hour > 12)
                            ? (subtitle[0].time.toDate().hour - 12).toString() +
                                " to " +
                                (subtitle[0].time.toDate().hour - 11)
                                    .toString() +
                                " PM"
                            : subtitle[0].time.toDate().hour.toString() +
                                " to " +
                                (subtitle[0].time.toDate().hour + 1)
                                    .toString() +
                                " AM",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18,
                          color: const Color(0xff2e2e2e),
                          letterSpacing: 0.96,
                        ),
                        textAlign: TextAlign.left,
                      )
                    : Text(
                        subtitle,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18,
                          color: const Color(0xff2e2e2e),
                          letterSpacing: 0.96,
                        ),
                        textAlign: TextAlign.left,
                      ),
          ]),
        ),
      ],
    );
  }
}
