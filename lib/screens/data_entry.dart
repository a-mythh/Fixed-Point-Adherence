import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// import the data entry form
import 'package:Fixed_Point_Adherence/data_entry_form.dart';

class DataEntry extends StatelessWidget {
  const DataEntry({super.key});

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