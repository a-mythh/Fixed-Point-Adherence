import 'package:flutter/material.dart';

// import location entry form
import 'package:Fixed_Point_Adherence/new_location_form.dart';

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