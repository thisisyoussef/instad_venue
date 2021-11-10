import 'package:flutter/material.dart';
import 'package:instad_venue/data/venue_filters.dart';
import 'package:instad_venue/functions/build_listCards.dart';
import 'package:instad_venue/screens/filterModal/filter_screen.dart';
import 'venueCard/list_card.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:instad_venue/models/venue_list.dart';

class VenuesScreen extends StatefulWidget {
  static String id = "venues_screen";
  List<ListCard> listCards = [];
  VenuesScreen();
  @override
  _VenuesScreenState createState() => _VenuesScreenState();
}

class _VenuesScreenState extends State<VenuesScreen> {
  @override
  Widget build(BuildContext context) {
    buildListCards(context, widget.listCards);
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          color: Color(0xFFF4F6F8),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: widget.listCards.length,
                  scrollDirection: Axis.vertical,
                  reverse: false,
                  itemBuilder: (context, position) {
                    var listCard = widget.listCards[position];
                    return ListCard(
                      venueArea: listCard.venueArea,
                      venueRating: listCard.venueRating,
                      venueDistance: listCard.venueDistance,
                      venueName: listCard.venueName,
                      venueId: listCard.venueId,
                      approved: listCard.approved,
                      venueSports: listCard.venueSports,
                      venuePrice: listCard.venuePrice,
                      location: listCard.location,
                      venueAmenities: listCard.venueAmenities,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
