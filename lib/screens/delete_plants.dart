import 'package:Fixed_Point_Adherence/helpers/database_helper.dart';
import 'package:Fixed_Point_Adherence/models/plant_zone.dart';
import 'package:Fixed_Point_Adherence/widgets/plantItem.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

DatabaseHelper databaseHelper = DatabaseHelper();

class DeletePlantsScreen extends StatefulWidget {
  const DeletePlantsScreen({super.key});

  @override
  State<DeletePlantsScreen> createState() => _DeletePlantsScreenState();
}

class _DeletePlantsScreenState extends State<DeletePlantsScreen> {
  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  List<Plant> _plants = [];
  bool _isLoading = true;
  String _error = '';

  // load plants to display
  void _loadItems() async {
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
        _plants = loadedPlants;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _error = 'Something went wrong. Please try again later!';
        print(error);
      });
    }
  }

  // get the plants from the database
  Future<List<Plant>> getPlantDetails() async {
    List<Map<String, dynamic>>? fetchedPlants =
        await DatabaseHelper().getPlants();

    // if data not present
    if (fetchedPlants == null) {
      Fluttertoast.showToast(
        msg: 'DATA NOT THERE!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return [];
    }

    List<Plant> plants = [];

    for (var row in fetchedPlants) {
      String id = row['id'];
      String plantName = row['plantName'];
      print(id);
      print(plantName);

      Plant plant = Plant(id: int.parse(id), plantName: plantName);

      plants.add(plant);
    }

    return plants;
  }

  // delete plant
  void _deletePlant(Plant plant) async {
    try {
      await databaseHelper.deletePlant(plant);
      _loadItems();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Delete Plants'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ..._plants.map(
                (plant) => PlantItem(
                  plant: plant,
                  deletePlant: _deletePlant,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
