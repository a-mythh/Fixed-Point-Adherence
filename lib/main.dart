import 'package:flutter/material.dart';
import 'package:path_validation/data_entry_form.dart';
import 'package:path_validation/input_form.dart';
// import 'package:path_validation/form_input.dart';
// import 'package:path_validation/input_form.dart';
// import 'package:path_validation/input_form.dart';


void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    ),
  );
}

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
      ),
      // body: const InputForm(),
      body: const DataEntryForm(),
    );
  }
}
