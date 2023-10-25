import 'package:flutter/material.dart';

// database
import 'package:Fixed_Point_Adherence/helpers/database_helper.dart';

// screens
import 'package:Fixed_Point_Adherence/screens/home.dart';
import 'package:Fixed_Point_Adherence/screens/login.dart';
import 'package:Fixed_Point_Adherence/screens/sign_up.dart';
import 'package:Fixed_Point_Adherence/screens/admin.dart';
import 'package:Fixed_Point_Adherence/screens/data_entry.dart';
import 'package:Fixed_Point_Adherence/screens/location_registration.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize database
  await DatabaseHelper().initDatabase();

  runApp(const App());
}

final theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  useMaterial3: true,
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(context) {
    return MaterialApp(
      title: 'Fixed Point Adherence',
      theme: theme,

      // use the HomeScreen as the initial route
      initialRoute: '/',

      routes: {
        '/': (context) => const HomeScreen(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const DataEntry(),
        '/admin': (context) => const AdminPage(),
        '/new_user': (context) => const SignUpScreen(),
        '/new_location': (context) => const NewLocationPage(),
      },
    );
  }
}







