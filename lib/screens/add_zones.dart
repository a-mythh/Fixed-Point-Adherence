import 'package:Fixed_Point_Adherence/models/plant_zone.dart';
import 'package:flutter/material.dart';

// database
import 'package:Fixed_Point_Adherence/helpers/database_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  void _addZone() async {
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

        await Fluttertoast.showToast(
          msg: 'Added zone in the database!',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } catch (e) {
        print(zone.id);
        print(zone.zoneName);
        print(zone.plantId);
        await Fluttertoast.showToast(
          msg: 'Error occurred while adding new zone',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
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
        backgroundColor: Colors.green.shade200,
        title: const Text('Add New Zone'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // select plant
                DropdownButtonFormField<Plant>(
                  decoration: InputDecoration(
                    labelText: 'Select Plant',
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  borderRadius: BorderRadius.circular(20),
                  // value: _selectedPlant,
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
                const SizedBox(height: 30),
                TextFormField(
                  onSaved: (value) => _enteredZoneName = value!,
                  maxLength: 1000,
                  decoration: const InputDecoration(
                    label: Text('Enter Zone Name'),
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
                  onPressed: _isAdding ? null : _addZone,
                  child: _isAdding
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator())
                      : const Text('Add Zone'),
                ),
              ],
            )),
      ),
    );
  }
}
