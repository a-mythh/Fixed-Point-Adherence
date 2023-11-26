import 'package:flutter/material.dart';

// database
import 'package:Fixed_Point_Adherence/helpers/database_helper.dart';

// screens
import 'package:Fixed_Point_Adherence/screens/home.dart';
import 'package:Fixed_Point_Adherence/screens/login.dart';
import 'package:Fixed_Point_Adherence/screens/sign_up.dart';
import 'package:Fixed_Point_Adherence/screens/admin.dart';
import 'package:Fixed_Point_Adherence/screens/data_entry.dart';
import 'package:google_fonts/google_fonts.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize database
  await DatabaseHelper().initDatabase();

  runApp(const App());
}

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.amber,
    background: const Color.fromARGB(255, 249, 236, 223),
    primary: Colors.black,
    primaryContainer: const Color.fromARGB(255, 128, 209, 217),
  ),
  textTheme: GoogleFonts.poppinsTextTheme(),
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
        '/home': (context) => const DataEntryScreen(),
        // '/admin': (context) => const AdminPage(),
        '/new_user': (context) => const SignUpScreen(),
      },
    );
  }
}
