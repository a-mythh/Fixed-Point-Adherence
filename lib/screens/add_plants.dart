import 'package:Fixed_Point_Adherence/models/plant_zone.dart';
import 'package:Fixed_Point_Adherence/utility/CustomSnackbar.dart';
import 'package:flutter/material.dart';

// database
import 'package:Fixed_Point_Adherence/helpers/database_helper.dart';

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

  void _addPlant(BuildContext context) async {
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

        final snackBar = showCustomSnackbar(
          text: 'New Plant added.',
          colour: 'success',
        );

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } catch (e) {
        final snackBar = showCustomSnackbar(
          text: 'Error occurred while adding plant.',
          colour: 'failure',
        );

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      setState(() {
        _isAdding = false;
      });

      if (!context.mounted) {
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Add New Plant'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // enter plant name
                TextFormField(
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  onSaved: (value) => _enteredPlantName = value!,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    prefixIcon: const Icon(Icons.factory_rounded),
                    fillColor: Theme.of(context).colorScheme.surface,
                    filled: true,
                    label: const Text('Enter Plant Name'),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 20,
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(
                        Radius.circular(25),
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

                const SizedBox(height: 40),

                // add plant button
                InkWell(
                  onTap: () {
                    if (_isAdding) {
                      return;
                    }
                    _addPlant(context);
                  },
                  borderRadius: BorderRadius.circular(15),
                  splashColor: Theme.of(context).primaryColor,
                  child: Container(
                    height: 50,
                    width: 130,
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
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: _isAdding
                        ? const Center(
                            child: SizedBox(
                              width: 15,
                              height: 15,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            'Add Plant',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: Colors.white),
                          ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
