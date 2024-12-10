import 'package:flutter/material.dart';
import 'package:organizer_app/CommonWidgets/bottom_nav_item.dart';
import 'package:organizer_app/Screens/CreateEvent/create_event.dart';
import 'package:organizer_app/Screens/Dashboard/dashboard_screen.dart';
import 'package:organizer_app/Screens/ListEvent/list_event.dart';
import 'package:organizer_app/Screens/Profile/profile_screen.dart';
import 'package:organizer_app/Screens/Search/search_screen.dart';
import 'package:organizer_app/Utils/const_color.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  void _onPageChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void _onNavItemTapped(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          const DashboardScreen(),
          const SearchScreen(),
          CreateEvent(pageController: _pageController),
          const ListEvent(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            color: primaryColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BottomNavItem(
                onTap: () => _onNavItemTapped(0),
                color: Colors.white,
                icon: selectedIndex == 0
                    ? Icons.dashboard
                    : Icons.dashboard_outlined,
              ),
              BottomNavItem(
                onTap: () => _onNavItemTapped(1),
                color: Colors.white,
                icon: Icons.search,
              ),
              BottomNavItem(
                onTap: () => _onNavItemTapped(2),
                color: Colors.white,
                icon:
                    selectedIndex == 2 ? Icons.add_circle_outlined : Icons.add,
              ),
              BottomNavItem(
                onTap: () => _onNavItemTapped(3),
                color: Colors.white,
                icon: selectedIndex == 3
                    ? Icons.analytics
                    : Icons.analytics_outlined,
              ),
              BottomNavItem(
                onTap: () => _onNavItemTapped(4),
                color: Colors.white,
                icon: selectedIndex == 4 ? Icons.person : Icons.person_outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
