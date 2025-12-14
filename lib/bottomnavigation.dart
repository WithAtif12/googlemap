
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:googlemapproject/screen/driver_homescreen.dart';
import 'package:googlemapproject/screen/order_detail_screen.dart';
import 'package:googlemapproject/screen/profile_screen.dart';
import 'package:googlemapproject/screen/shipment_screen.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int selectedIndex = 0;

  final List<Widget> screens = [
    DriverHomescreen(),
   OrderDetailScreen(),
   ShipmentScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: NavigationBar(
        height: 80,
        elevation: 0,
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        backgroundColor: Colors.grey[300],
        indicatorColor: Colors.white.withOpacity(0.3),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const TextStyle(color: Colors.red, fontWeight: FontWeight.w600);
          }
          return TextStyle(color: Colors.grey[400]);
        }),

        // style icons for dark background
        destinations: [
          NavigationDestination(
            icon: Icon(FontAwesomeIcons.house, color: Colors.grey[400]),
            selectedIcon: Icon( FontAwesomeIcons.house, color: Colors.red),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(FontAwesomeIcons.boxOpen,color: Colors.grey[400]),
            selectedIcon: Icon( FontAwesomeIcons.boxOpen, color: Colors.red,),
            label: 'orders',
          ),
          NavigationDestination(
            icon: Icon(FontAwesomeIcons.truckFast, color: Colors.grey[400]),
            selectedIcon: Icon(FontAwesomeIcons.truckFast, color: Colors.red,),
            label: 'Shipment',
          ),
          NavigationDestination(
            icon: Icon( FontAwesomeIcons.solidCircleUser,color:Colors.grey[400]),
            selectedIcon: Icon( FontAwesomeIcons.solidCircleUser,color: Colors.red,),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
