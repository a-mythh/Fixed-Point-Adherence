import 'package:Fixed_Point_Adherence/screens/admin.dart';
import 'package:Fixed_Point_Adherence/screens/plants.dart';
import 'package:Fixed_Point_Adherence/screens/accounts.dart';
import 'package:Fixed_Point_Adherence/screens/zones.dart';
import 'package:Fixed_Point_Adherence/utility/CustomSnackbar.dart';
import 'package:flutter/material.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({required this.username, super.key});

  final String username;

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    String selectedPageTitle = 'Admin Dashboard';
    Widget activeScreen = const AdminScreen();

    if (_selectedPageIndex == 1) {
      selectedPageTitle = 'Plants Dashboard';
      activeScreen = PlantScreen();
    } else if (_selectedPageIndex == 2) {
      selectedPageTitle = 'Zones Dashboard';
      activeScreen = const ZoneScreen();
    } else if (_selectedPageIndex == 3) {
      selectedPageTitle = 'Accounts Dashboard';
      activeScreen = AccountsScreen(username: widget.username,);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedPageTitle),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        automaticallyImplyLeading: false,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
              backgroundColor: Theme.of(context).colorScheme.background,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(1),
              shadowColor: null,
            ),
            onPressed: () async {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);

              final snackBar = showCustomSnackbar(
                text: 'Log out successful.',
                colour: 'success',
              );
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              // await Fluttertoast.showToast(
              //   msg: 'User successfully logged out!',
              //   toastLength: Toast.LENGTH_LONG,
              //   gravity: ToastGravity.BOTTOM,
              //   backgroundColor: Colors.green,
              //   textColor: Colors.white,
              // );
            },
            child: const Icon(
              Icons.power_settings_new,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: activeScreen,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).colorScheme.onBackground,
        showUnselectedLabels: false,
        enableFeedback: true,
        onTap: (index) {
          setState(() {
            _selectedPageIndex = index;
          });
        },
        currentIndex: _selectedPageIndex,

        // Navigation bar icons
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_rounded,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.factory_rounded,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            label: 'Plants',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.forklift,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            label: 'Zones',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.face_rounded,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            label: 'Accounts',
          ),
        ],
      ),
    );
  }
}
