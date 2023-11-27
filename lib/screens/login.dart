import 'package:Fixed_Point_Adherence/screens/admin.dart';
import 'package:Fixed_Point_Adherence/screens/tabs.dart';
import 'package:Fixed_Point_Adherence/utility/CustomSnackbar.dart';
import 'package:flutter/material.dart';

// import Authentication module
import 'package:Fixed_Point_Adherence/auth/auth_module.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  var _enteredUsername = '';
  var _enteredPassword = '';

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _showPassword =
      false; // Add a new bool variable to track the show/hide password state

  // Map<String, dynamic> getLoginValidity(String username, String password)
  // {
  //   Map<String, dynamic
  // }

  void _onLoginPressed() async {
    bool isValid = _formKey.currentState!.validate();

    // Invalid details entered
    if (!isValid) return;

    _formKey.currentState!.save();

    setState(() => _isLoading = true);

    Map<String, dynamic> isLoggedIn =
        await AuthModule.login(_enteredUsername, _enteredPassword);

    setState(() {
      _isLoading = false;
    });

    if (isLoggedIn['isLogin'] == true) {
      final snackbar = showCustomSnackbar(
        text: 'Login successful.',
        colour: 'success',
      );
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      if (isLoggedIn['userType'] == 'user') {
        Navigator.pushReplacementNamed(context, '/home');
      } else if (isLoggedIn['userType'] == 'admin') {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TabsScreen(
                username: _enteredUsername,
              ),

              // builder: (context) => AdminPage(username: _enteredUsername),
            ));
      }
    } else {
      final snackbar = showCustomSnackbar(
        text: 'Invalid credentials! Please try again.',
        colour: 'failure',
      );
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo
            const SizedBox(
              height: 110,
              width: 110,
              child: Image(
                image: AssetImage('assets/images/wipro_black_logo.png'),
                opacity: AlwaysStoppedAnimation(.75),
              ),
            ),

            const SizedBox(height: 60),

            Text(
              'Login',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 15),
            Text(
              'Hello, welcome back',
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            const SizedBox(height: 30),

            Form(
                key: _formKey,
                child: Column(
                  children: [
                    // username
                    TextFormField(
                      onSaved: (value) {
                        _enteredUsername = value!.trim();
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a username.';
                        }
                        return null;
                      },
                      autocorrect: false,
                      keyboardType: TextInputType.name,
                      style: Theme.of(context).textTheme.bodyLarge,
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        prefixIcon: Icon(
                          Icons.alternate_email_rounded,
                          size: 25,
                        ),
                        labelText: 'Username',
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // password
                    TextFormField(
                      onSaved: (value) {
                        _enteredPassword = value!.trim();
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a password.';
                        }
                        return null;
                      },
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        prefixIcon: const Icon(Icons.lock_rounded),
                        labelText: 'Password',
                        fillColor: Colors.white,
                        filled: true,
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        suffixIcon: IconButton(
                          padding: const EdgeInsets.only(right: 20),
                          icon: Icon(_showPassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        ),
                      ),
                      obscureText: !_showPassword,
                    ),
                  ],
                )),

            const SizedBox(height: 18),

            // login button
            SizedBox(
              width: 400,
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.primaryContainer,
                  ),
                  foregroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  textStyle: MaterialStateProperty.all(
                    Theme.of(context).textTheme.titleLarge,
                  ),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                  ),
                ),
                onPressed: _onLoginPressed,
                child: _isLoading
                    ? const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 0,
                        ),
                        child: CircularProgressIndicator(
                          strokeCap: StrokeCap.round,
                        ),
                      )
                    : const Text('Log in'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
