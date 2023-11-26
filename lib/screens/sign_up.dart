import 'package:flutter/material.dart';

// import Authentication module
import 'package:Fixed_Point_Adherence/auth/auth_module.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  var _enteredUsername = '';
  var _enteredPassword = '';

  final List<String> _accTypeList = ['User', 'Admin'];
  String _selectedAccType = '';
  bool _showPassword =
      false; // Add a new bool variable to track the show/hide password state

  void _onSignUpPressed(BuildContext context) async {
    bool isValid = _formKey.currentState!.validate();

    // Invalid details entered
    if (!isValid) return;

    _formKey.currentState!.save();

    String username = _enteredUsername;
    String password = _enteredPassword;
    String accType = _selectedAccType.toLowerCase();

    AuthModule.signUp(username, password, accType);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Registration'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // enter username
              TextFormField(
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a username.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredUsername = value!;
                },
                autocorrect: false,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: const Icon(Icons.alternate_email_rounded),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 20,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none),
                  labelText: 'Username',
                ),
              ),

              const SizedBox(height: 20),

              // enter a password
              TextFormField(
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a password.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredPassword = value!;
                },
                autocorrect: false,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: const Icon(Icons.lock_outline),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 20,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none),
                  labelText: 'Password',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
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

              const SizedBox(height: 20),

              // select account type
              DropdownButtonFormField(
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please choose an account type.';
                  }
                  return null;
                },
                icon: const Icon(Icons.expand_more_rounded),
                borderRadius: BorderRadius.circular(20),
                dropdownColor: Colors.white,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: 'Select Account Type',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  prefixIcon: Icon(Icons.supervisor_account_outlined),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 20,
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                ),
                items: _accTypeList
                    .map((plant) => DropdownMenuItem(
                          value: plant,
                          child: Text(plant),
                        ))
                    .toList(),

                // what happens when a value is selected
                onChanged: (value) {
                  setState(() {
                    _selectedAccType = value as String;
                  });
                },
              ),

              const SizedBox(height: 40),

              // sign up button
              InkWell(
                onTap: () => _onSignUpPressed(context),
                borderRadius: BorderRadius.circular(15),
                splashColor: Theme.of(context).primaryColor,
                child: Container(
                  height: 55,
                  width: 140,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.77),
                        Colors.black.withOpacity(0.85),
                        Colors.black.withOpacity(1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      'Sign up',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}