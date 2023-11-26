import 'package:Fixed_Point_Adherence/models/plant_zone.dart';
import 'package:Fixed_Point_Adherence/utility/CustomSnackbar.dart';
import 'package:flutter/material.dart';

// database
import 'package:Fixed_Point_Adherence/helpers/database_helper.dart';

DatabaseHelper databaseHelper = DatabaseHelper();

class AddZonesScreen extends StatefulWidget {
  const AddZonesScreen({super.key});

  @override
  State<AddZonesScreen> createState() => _AddZonesScreenState();
}

class _AddZonesScreenState extends State<AddZonesScreen> {
  @override
  void initState() {
    super.initState();
    _loadPlants();
  }

  List<Plant> plants = [];
  Plant _selectedPlant = Plant(id: 0, plantName: 'None');
  int _selectedPlantId = 0;
  bool _isLoading = true;
  String _error = '';

  // load plants to display
  void _loadPlants() async {
    try {
      final fetchedPlants = await databaseHelper.getPlants();

      // when no data is present in database
      if (fetchedPlants == null) {
        setState(() {
          _isLoading = false;
        });
        return null;
      }

      final List<Plant> loadedPlants = [];

      for (final row in fetchedPlants) {
        int id = row['id'];
        String plantName = row['plantName'];

        Plant plant = Plant(id: id, plantName: plantName);
        loadedPlants.add(plant);
      }

      setState(() {
        plants = loadedPlants;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _error = 'Something went wrong. Please try again later!';
        print(error);
      });
    }

    _selectedPlant = plants[0];
  }

  final _formKey = GlobalKey<FormState>();

  String _enteredZoneName = '';
  bool _isAdding = false;

  void _addZone(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isAdding = true;
      });

      // todo: use UUID for unique id
      Zone zone = Zone(
        id: DateTime.now().millisecondsSinceEpoch,
        zoneName: _enteredZoneName,
        plantId: _selectedPlantId,
      );

      try {
        await databaseHelper.addNewZone(zone);

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
      print('Zone added : $_enteredZoneName');

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
        backgroundColor: Colors.transparent,
        title: const Text('Add New Zone'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // select plant
                DropdownButtonFormField<Plant>(
                  dropdownColor: Theme.of(context).colorScheme.surface,
                  decoration: InputDecoration(
                    fillColor: Theme.of(context).colorScheme.surface,
                    filled: true,
                    labelText: 'Select Plant',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    prefixIcon: const Icon(Icons.factory_rounded),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(25)),
                  ),
                  borderRadius: BorderRadius.circular(20),
                  items: plants
                      .map(
                        (plant) => DropdownMenuItem(
                          value: plant,
                          child: Text(plant.plantName),
                        ),
                      )
                      .toList(),
                  onChanged: (plant) {
                    setState(() {
                      _selectedPlant = plant!;
                      _selectedPlantId = plant.id;
                    });
                  },
                ),

                const SizedBox(height: 20),

                // enter zone name
                TextFormField(
                  onSaved: (value) => _enteredZoneName = value!,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.forklift),
                    fillColor: Theme.of(context).colorScheme.surface,
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    label: const Text('Enter Zone Name'),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
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

                const SizedBox(height: 30),

                // add zone button
                InkWell(
                  onTap: () {
                    if (_isAdding) {
                      return;
                    }
                    _addZone(context);
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
                            'Add Zone',
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

/*
ElevatedButton(
                  onPressed: _isAdding ? null : _addZone,
                  child: _isAdding
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator())
                      : const Text('Add Zone'),
                ),
*/