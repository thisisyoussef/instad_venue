import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instad_venue/screens/calendarScreen/calendar_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:instad_venue/screens/profile_page.dart';
import 'package:instad_venue/screens/venuesScreen/venueCard/list_card.dart';
import 'package:instad_venue/screens/venuesScreen/venues_screen.dart';

class InstadRoot extends StatefulWidget {
  final List<ListCard> listCards;

  static GlobalKey InstadRootStateKey = new GlobalKey<_InstadRootState>();
  static TabController tabController;
  static bool isSearching = false;
  static String id = "home_screen";
  static int currentIndex = 0;

  const InstadRoot({Key key, this.listCards}) : super(key: key);
  @override
  _InstadRootState createState() => _InstadRootState();
}

List<Widget> _pages;

class _InstadRootState extends State<InstadRoot> with TickerProviderStateMixin {
  String currentPage;
  List<String> pageKeys = ["Page1", "Page2", "Page3", "Page4", "Page5"];
  Map<String, GlobalKey<NavigatorState>> _navigatorKeys = {
    "Page1": GlobalKey<NavigatorState>(),
    "Page2": GlobalKey<NavigatorState>(),
    "Page3": GlobalKey<NavigatorState>(),
    "Page4": GlobalKey<NavigatorState>(),
  };

  void _selectTab(String tabItem, int index) {
    setState(() {
      currentPage = pageKeys[index];
      InstadRoot.currentIndex = index;
    });
  }

  @override
  void initState() {
    _pages = [VenuesScreen(), ProfilePage(), CalendarScreen()];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            currentIndex: InstadRoot.currentIndex,
            /*showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedIconTheme: IconThemeData(color: Color(0xFF2B8116), size: 35),
          unselectedIconTheme: IconThemeData(color: Colors.grey, size: 30),
          */
            onTap: (int index) {
              setState(() {
                _selectTab(pageKeys[index], index);
              });
            },
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                label: "",
//      icon: ,
                icon: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 30),
                  child: Icon(
                    Icons.house_outlined,
                    //color: Colors.black,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                label: "",
                icon: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 30),
                  child: Icon(
                    Icons.account_circle_outlined,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                label: "",
                icon: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 30),
                  child: Icon(
                    Icons.calendar_today_outlined,
                  ),
                ),
              ),
            ],
            //type: BottomNavigationBarType.fixed,
          ),
          tabBuilder: (context, i) {
            return CupertinoTabView(
              builder: (context) {
                return _pages[i];
              },
            );
          });
    });
  }
}
