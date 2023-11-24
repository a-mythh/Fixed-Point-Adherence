import 'package:Fixed_Point_Adherence/models/plant_zone.dart';
import 'package:flutter/material.dart';

// database
import 'package:Fixed_Point_Adherence/helpers/database_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';

DatabaseHelper databaseHelper = DatabaseHelper();

class AddPlantsScreen extends StatefulWidget {
  const AddPlantsScreen({super.key});

  @override
  State<AddPlantsScreen> createState() => _AddPlantsScreenState();
}

class _AddPlantsScreenState extends State<AddPlantsScreen> {
  final _formKey = GlobalKey<FormState>();

  String _enteredPlantName = '';
  bool _isAdding = false;

  void _addPlant() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isAdding = true;
      });

      // todo: use UUID for unique id
      Plant plant = Plant(
        id: DateTime.now().millisecondsSinceEpoch,
        plantName: _enteredPlantName,
      );

      try {
        await databaseHelper.addNewPlant(plant);

        await Fluttertoast.showToast(
          msg: 'Added plant in the database!',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } catch (e) {
        await Fluttertoast.showToast(
          msg:
              'Error occurred while adding new plant',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }

      setState(() {
        _isAdding = false;
      });
      print('Plant added : $_enteredPlantName');

      if (!context.mounted) {
        return;
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade200,
        title: const Text('Add New Plant'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  onSaved: (value) => _enteredPlantName = value!,
                  maxLength: 1000,
                  decoration: const InputDecoration(
                    label: Text('Enter Plant Name'),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.trim().length > 1000) {
                      return 'Must be between 1 and 1000 characters.';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: _isAdding ? null : _addPlant,
                  child: _isAdding
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator())
                      : const Text('Add Plant'),
                ),
              ],
            )),
      ),
    );
  }
}
