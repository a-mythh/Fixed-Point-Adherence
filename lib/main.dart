import 'package:flutter/material.dart';
import 'package:Fixed_Point_Adherence/data_entry_form.dart';
import 'auth_module.dart'; // Import the auth_module.dart
import 'package:Fixed_Point_Adherence/helpers/database_helper.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:Fixed_Point_Adherence/new_location_form.dart';
import 'package:fluttertoast/fluttertoast.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load(fileName: 'lib/.env');

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
        '/home': (context) => const HomePage(),
        '/admin': (context) => const AdminPage(),
        '/new_user': (context) => const SignUpScreen(),
        '/new_location': (context) => const NewLocationPage(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fixed Point Adherence'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 150,
              width: 150,
              child: Image(
                image: AssetImage('images/wipro_logo.png'),
              ),
            ),
            const SizedBox(
              height: 20
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login'); // Navigate to the login page
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Data"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              textStyle: TextStyle(fontWeight: FontWeight.bold),
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue,
              shape: CircleBorder(),
              padding: EdgeInsets.all(1),
            ),
            onPressed: () async {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/');

              await Fluttertoast.showToast(
                msg: 'User successfully logged out!',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.green,
                textColor: Colors.white,
              );
            },
            child: const Icon(
              Icons.power_settings_new,
              color: Colors.blue,
            ),
          ),
        ],
      ),
      body: const DataEntryForm(),
    );
  }
}

class NewLocationPage extends StatelessWidget {
  const NewLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Location Registration'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: const NewLocationEntryForm(),
    );
  }
}

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              textStyle: TextStyle(fontWeight: FontWeight.bold),
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue,
              shape: CircleBorder(),
              padding: EdgeInsets.all(1),
            ),
            onPressed: () async {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/');

              await Fluttertoast.showToast(
                msg: 'Admin successfully logged out!',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.green,
                textColor: Colors.white,
              );
            },
            child: const Icon(
              Icons.power_settings_new,
              color: Colors.blue,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 150,
              width: 150,
              child: Image(
                image: AssetImage('images/wipro_logo.png'),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context,
                    '/new_user'); // Navigate to the new user register page
              },
              child: Text('Register User'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context,
                    '/new_location'); // Navigate to the new location page
              },
              child: Text('Register New Locations'),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _showPassword =
      false; // Add a new bool variable to track the show/hide password state

  void _onLoginPressed(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    String username = _usernameController.text;
    String password = _passwordController.text;

    Map<String, dynamic> isLoggedIn =
        await AuthModule.login(username, password);

    // Map<String, dynamic> isLoggedIn = {'userType': 'admin', 'isLogin': true};

    setState(() {
      _isLoading = false;
    });

    if (isLoggedIn['isLogin'] == true) {
      if (isLoggedIn['userType'] == 'user') {
        Navigator.pushReplacementNamed(context, '/home');
      } else if (isLoggedIn['userType'] == 'admin') {
        Navigator.pushReplacementNamed(context, '/admin');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Invalid Credentials. Try again'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username')),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                      _showPassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                ),
              ),
              obscureText: !_showPassword,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : () => _onLoginPressed(context),
              child: _isLoading ? CircularProgressIndicator() : Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final List<String> _accTypeList = ['User', 'Admin'];
  String _selected_accType = '';
  bool _showPassword =
      false; // Add a new bool variable to track the show/hide password state

  void _onSignUpPressed(BuildContext context) async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    String accType = _selected_accType.toLowerCase();

    AuthModule.signUp(username, password, accType);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New User Registration'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username')),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                      _showPassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                ),
              ),
              obscureText: !_showPassword,
            ),
            const SizedBox(
              height: 30,
            ),
            DropdownButtonFormField(
              // add some decoration to the drop down menu
              decoration: const InputDecoration(
                labelText: "Select User Type",
                prefixIcon: Icon(
                  Icons.admin_panel_settings,
                  color: Colors.deepPurple,
                ),
                border: OutlineInputBorder(),
              ),

              // list of items to show in the plant drop down menu
              items: _accTypeList
                  .map((plant) => DropdownMenuItem(
                        value: plant,
                        child: Text(plant),
                      ))
                  .toList(),

              // what happens when a value is selected
              onChanged: (value) {
                setState(() {
                  _selected_accType = value as String;
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () => _onSignUpPressed(context),
                child: const Text('Sign User Up')),
          ],
        ),
      ),
    );
  }
}
