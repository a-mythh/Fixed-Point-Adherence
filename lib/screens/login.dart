import 'package:Fixed_Point_Adherence/screens/admin.dart';
import 'package:flutter/material.dart';

// import Authentication module
import 'package:Fixed_Point_Adherence/auth/auth_module.dart';

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

    setState(() {
      _isLoading = false;
    });

    if (isLoggedIn['isLogin'] == true) {
      if (isLoggedIn['userType'] == 'user') {
        Navigator.pushReplacementNamed(context, '/home');
      } else if (isLoggedIn['userType'] == 'admin') {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AdminPage(username: username),
            ));
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
        title: const Text('Login'),
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : () => _onLoginPressed(context),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
