import 'package:flutter/material.dart';
<<<<<<< Updated upstream
import 'package:path_validation/data_entry_form.dart';
// import 'package:path_validation/form_input.dart';
// import 'package:path_validation/input_form.dart';
// import 'package:path_validation/input_form.dart';

=======
import 'package:Fixed_Point_Adherence/data_entry_form.dart';
import 'auth_module.dart'; // Import the auth_module.dart
import 'package:Fixed_Point_Adherence/helpers/database_helper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
>>>>>>> Stashed changes


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'lib/.env');
  await DatabaseHelper().initDatabase();
  runApp(
    MaterialApp(
<<<<<<< Updated upstream
      title: 'Flutter Demo',
=======
      title: 'Fixed Point Adherence',
>>>>>>> Stashed changes
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
<<<<<<< Updated upstream
      home: const HomePage(),
=======
      // Use the HomeScreen as the initial route
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomePage(),
      },
>>>>>>> Stashed changes
    ),
  );
}

<<<<<<< Updated upstream
=======
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Fixed Point Adherence'),
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
            const SizedBox(height: 20,),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login'); // Navigate to the login page
              },
              child: Text('Login'),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup'); // Navigate to the signup page
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

>>>>>>> Stashed changes
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Data'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      // body: const InputForm(),
      // body: const PictureInput(),
      body: const DataEntryForm(),
    );
  }
}
<<<<<<< Updated upstream
=======

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _showPassword = false; // Add a new bool variable to track the show/hide password state

  void _onLoginPressed(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    String username = _usernameController.text;
    String password = _passwordController.text;

    bool isLoggedIn = await AuthModule.login(username, password);

    setState(() {
      _isLoading = false;
    });

    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
            TextFormField(controller: _usernameController, decoration: InputDecoration(labelText: 'Username')),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                ),
              ),
              obscureText: !_showPassword,
            ),
            SizedBox(height: 20,),
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
  final _secretController = TextEditingController();
  bool _showPassword = false; // Add a new bool variable to track the show/hide password state
  bool _showSecret = false;

  void _onSignUpPressed(BuildContext context) async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    String secret = _secretController.text;

    AuthModule.signUp(username, password, secret);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(controller: _usernameController, decoration: InputDecoration(labelText: 'Username')),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                ),
              ),
              obscureText: !_showPassword,
            ),
            TextFormField(
              controller: _secretController,
              decoration: InputDecoration(
                labelText: 'Secret Key',
                suffixIcon: IconButton(
                  icon: Icon(_showSecret ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _showSecret = !_showSecret;
                    });
                  },
                ),
              ),
              obscureText: !_showSecret,
            ),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: () => _onSignUpPressed(context), child: Text('Sign Up')),
          ],
        ),
      ),
    );
  }
}
>>>>>>> Stashed changes
