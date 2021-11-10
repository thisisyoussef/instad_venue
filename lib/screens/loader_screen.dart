import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instad_venue/models/venue.dart';
import 'package:instad_venue/models/venue_list.dart';
import 'package:provider/provider.dart';
import 'package:instad_venue/screens/venuesScreen/venueCard/list_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import 'instad_root.dart';

class LoaderScreen extends StatefulWidget {
  final List<ListCard> listCards = [];

  static GlobalKey InstadRootStateKey = new GlobalKey<_LoaderScreenState>();
  static String id = "loader_screen";

  @override
  _LoaderScreenState createState() => _LoaderScreenState();
}

final _firestore = FirebaseFirestore.instance;

class _LoaderScreenState extends State<LoaderScreen>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation defaultAnimation;
  Animation launchAnimation;
  bool ready;

  @override
  void initState() {
    setState(() {
      ready = false;
    });
    controller = AnimationController(
        vsync: this, duration: Duration(seconds: 3), upperBound: 1);
    defaultAnimation =
        CurvedAnimation(parent: controller, curve: Curves.slowMiddle);
    launchAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeInExpo);
    controller.forward();
    print("animation set up");
    defaultAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    // TODO: implement initState
    final _auth = auth.FirebaseAuth.instance;
    final user = _auth.currentUser;
    _firestore.collection('locations').get().then((querySnapshot) {
      querySnapshot.docs.forEach((location) {
        print("location");

        final List managers = location.data()['managers'];
        if (managers.contains(user.uid)) {
          print("location managed by user");

          final bool approved = location.data()['approved'];
          final String Id = location.id;
          final String name = location.data()['name'];
          final String area = location.data()['Area'];
          final double rating = location.data()['Rating'];
          final List sports = location.data()['Sports'];
          final int price = location.data()['price'];
          final List amenities = location.data()['amenities'];
          final GeoPoint geoPoint = location.data()['location'];
          //final int price = truePrice.toInt();
          print("Location is " + geoPoint.toString());
          print(name);
          final venue = Venue(
            venueArea: area,
            venueDistance: 5,
            venueRating: rating,
            venueId: Id,
            venueName: name,
            venueSports: sports,
            venuePrice: price,
            location: geoPoint,
            venueAmenities: amenities,
          );
          if (Provider.of<VenueList>(context, listen: false).venues == null ||
              !Provider.of<VenueList>(context, listen: false).inList(venue)) {
            Provider.of<VenueList>(context, listen: false).addVenue(venue);
          }
        }
      });
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    widget.listCards.clear();
    //Provider.of<VenueList>(context, listen: false).venues.clear();
    for (var venue in Provider.of<VenueList>(context, listen: true).venues) {
      final listCard = ListCard(
        venueArea: venue.venueArea,
        venueDistance: venue.venueDistance,
        venueRating: venue.venueRating,
        venueId: venue.venueId,
        venueName: venue.venueName,
        venueSports: venue.venueSports,
        venuePrice: venue.venuePrice,
        location: venue.location,
        venueAmenities: venue.venueAmenities,
      );
      print("Adding " + listCard.venueName);
      setState(() {
        widget.listCards.add(listCard);
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => InstadRoot(
            listCards: widget.listCards,
          ),
        ),
      );
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.black,
      child: Center(
        child: Hero(
          tag: "logo",
          child: Image.asset(
            "assets/images/instadLogo.png",
            height: !ready
                ? defaultAnimation.value * 250
                : launchAnimation.value * 500,
          ),
        ),
      ),
    );
  }
/*
  _checkInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      print("connected to internet");
      ready = true;
    } else {
      setState(() {});
    }
  }*/
}
