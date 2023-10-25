import 'package:flutter/material.dart';

// import Authentication module
import 'package:Fixed_Point_Adherence/auth/auth_module.dart';

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
