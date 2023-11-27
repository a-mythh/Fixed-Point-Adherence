import 'package:Fixed_Point_Adherence/utility/CustomSnackbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// import the data entry form
import 'package:Fixed_Point_Adherence/widgets/DataEntryForm.dart';

class DataEntryScreen extends StatelessWidget {
  const DataEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text("Upload Data"),
        // centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        automaticallyImplyLeading: false,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
              backgroundColor: Theme.of(context).colorScheme.background,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(1),
              shadowColor: null,
            ),
            onPressed: () async {
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);

              final snackBar = showCustomSnackbar(text: 'Log out successful.', 
              colour: 'success',);
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              // await Fluttertoast.showToast(
              //   msg: 'User successfully logged out!',
              //   toastLength: Toast.LENGTH_LONG,
              //   gravity: ToastGravity.BOTTOM,
              //   backgroundColor: Colors.green,
              //   textColor: Colors.white,
              // );
            },
            child: const Icon(
              Icons.power_settings_new,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: const DataEntryForm(),
    );
  }
}
