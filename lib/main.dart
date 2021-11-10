import 'package:flutter/material.dart';
import 'package:instad_venue/data/instad_data.dart';
import 'package:instad_venue/models/timeslot_data.dart';
import 'package:instad_venue/models/venue_list.dart';
import 'package:instad_venue/screens/loader_screen.dart';
import 'screens/bookedPage/booked_page.dart';
import 'package:instad_venue/screens/loginScreen/login_page.dart';
import 'package:instad_venue/screens/register_screen.dart';
import 'package:instad_venue/services/venue_details.dart';
import 'package:instad_venue/data/venue_filters.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:instad_venue/screens/venueProfilePage/venue_profile_page.dart';
import 'package:instad_venue/screens/venuesScreen/venues_screen.dart';
import 'package:instad_venue/services/geolocator_screen.dart';
import 'package:provider/provider.dart';
import 'screens/instad_root.dart';
import 'selected_location.dart';
import 'package:instad_venue/data/booking_selections.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseFirestore.instance.clearPersistence();
  //FirebaseFirestore.instance.settings = Settings(persistenceEnabled: false);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final locatorService = GeoLocatorService();
    return MultiProvider(
      providers: [
        FutureProvider(
          create: (context) => locatorService.getLocation(),
        ),
        ChangeNotifierProvider(create: (context) => VenueFilters()),
        ChangeNotifierProvider(create: (context) => InstadData()),
        ChangeNotifierProvider(create: (context) => VenueDetails()),
        ChangeNotifierProvider(create: (context) => SelectedLocation()),
        ChangeNotifierProvider(create: (context) => VenueList()),
        ChangeNotifierProvider(create: (context) => BookingSelections()),
        ChangeNotifierProvider(create: (context) => VenueList()),
        ChangeNotifierProvider(create: (context) => TimeSlotData())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: const Color(0xFF2B8116)),
          appBarTheme: AppBarTheme(color: Colors.black),
          primarySwatch: Colors.green,
          sliderTheme: SliderTheme.of(context).copyWith(
            trackHeight: 2,
            valueIndicatorColor: Color(0xFF2B8116),
            //slider modifications
            thumbColor: Colors.white,
            inactiveTrackColor: Color(0xFF2B8116),
            activeTrackColor: Color(0xFF2B8116),
            overlayColor: Color(0x992E2E2E),
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 15.0),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 10.0),
          ),
        ),
        //home: InstadRoot(),
        initialRoute: LoginPage.id,
        routes: {
          InstadRoot.id: (context) => InstadRoot(),
          LoginPage.id: (context) => LoginPage(),
          //HomePage.id: (context) => HomePage(),
          //FilterScreen.id: (context) => FilterScreen(),
          VenueProfilePage.id: (context) => VenueProfilePage(),
          BookedPage.id: (context) => BookedPage(),
          RegisterScreen.id: (context) => RegisterScreen(),
          //ListCard.id: (context) => ListCard(),
          LoaderScreen.id: (context) => LoaderScreen(),
          VenuesScreen.id: (context) => VenuesScreen(),
        },
      ),
    );
  }
}
