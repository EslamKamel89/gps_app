import 'package:flutter/material.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/widgets/gps_bottom_nav.dart';

class MarketPlaceScreen extends StatefulWidget {
  const MarketPlaceScreen({super.key});

  @override
  State<MarketPlaceScreen> createState() => _MarketPlaceScreenState();
}

class _MarketPlaceScreenState extends State<MarketPlaceScreen> {
  int _currentTab = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GPSColors.background,
      body: Container(
        alignment: Alignment.center,
        child: Text('Market Place', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
      ),
      bottomNavigationBar: GPSBottomNav(
        currentIndex: _currentTab,
        onChanged: (i) {
          setState(() => _currentTab = i);
        },
      ),
    );
  }
}
