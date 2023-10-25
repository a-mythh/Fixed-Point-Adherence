import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminPage extends StatelessWidget 
{
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
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(1),
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
              child: const Text('Register User'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context,
                    '/new_location'); // Navigate to the new location page
              },
              child: const Text('Register New Locations'),
            ),
          ],
        ),
      ),
    );
  }
}