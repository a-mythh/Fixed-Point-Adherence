import 'package:flutter/material.dart';

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
                image: AssetImage('assets/images/wipro_logo.png'),
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