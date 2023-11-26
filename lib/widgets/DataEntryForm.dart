import 'package:Fixed_Point_Adherence/models/plant_zone.dart';
import 'package:Fixed_Point_Adherence/utility/CustomSnackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

// models
import 'package:Fixed_Point_Adherence/models/zone_details.dart';

// submit form
import 'package:Fixed_Point_Adherence/screens/submit_form.dart';

// database and excel
import 'package:Fixed_Point_Adherence/helpers/database_helper.dart';
import 'package:Fixed_Point_Adherence/helpers/save_to_excel.dart';

DatabaseHelper databaseHelper = DatabaseHelper();
ExcelHelper excelHelper = ExcelHelper();

enum PathTypeEnum { Path_is_ok, Path_is_not_ok }

class DataEntryForm extends StatefulWidget {
  const DataEntryForm({super.key});

  @override
  State<DataEntryForm> createState() => _DataEntryFormState();
}

class _DataEntryFormState extends State<DataEntryForm> {
  // initialize the state variables
  @override
  void initState() {
    _datePickedController.text = "";
    super.initState();
    _loadPlants();
    _loadZones();
  }

  List<Plant> plants = [];
  List<Zone> zones = [];
  Plant _selectedPlant = Plant(id: 0, plantName: 'None');
  Zone _selectedZone = Zone(id: 0, zoneName: 'None', plantId: 0);
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

  // load zones to display
  Future<void> _loadZones() async {
    try {
      final fetchedZones = await databaseHelper.getZones(_selectedPlant);

      // when no data is present in database
      if (fetchedZones == null) {
        setState(() {
          _isLoading = false;
        });
        return null;
      }

      final List<Zone> loadedZones = [];

      for (final row in fetchedZones) {
        int id = row['id'];
        String zoneName = row['zoneName'];
        int plantId = row['plantId'];

        Zone zone = Zone(id: id, zoneName: zoneName, plantId: plantId);
        loadedZones.add(zone);
      }

      setState(() {
        zones = loadedZones;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _error = 'Something went wrong. Please try again later!';
        print(error);
      });
    }
  }

  // function to open date picker
  Future _selectDate() async {
    DateTime? datePicked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime.now());

    if (datePicked != null) {
      setState(() {
        _datePickedController.text =
            DateFormat('dd-MM-yyyy').format(datePicked);
      });
    }
  }

  File? _image;

  // function to pick image from camera
  Future getImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() {
        _image = imageTemp;
      });
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }

  final List<String> plantList = [
    'Avadi',
    'Anna Nagar',
    'Tambaram',
    'Kelambakkam',
    'Shillong'
  ];
  final List<String> zoneList = [
    'Zone 1',
    'Zone 2',
    'Zone 3',
    'Zone 4',
    'Zone 5'
  ];

  var _datePicked = '';

  // declare controllers here
  final TextEditingController _datePickedController = TextEditingController();
  final TextEditingController _zoneLeaderController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 10,
      ),
      child: ListView(
        children: [
          // logo
          const SizedBox(
            height: 70,
            width: 70,
            child: Image(
              image: AssetImage('assets/images/wipro_black_logo.png'),
            ),
          ),

          const SizedBox(height: 20),

          // title
          Text(
            'Zone Data Entry',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: 40),

          /* Form for data entry */
          Form(
            key: _formKey,
            child: Column(
              children: [
                // select plant
                DropdownButtonFormField(
                  validator: (value) {
                    if (value == null || value.plantName.isEmpty) {
                      return 'Please choose a plant.';
                    }
                    return null;
                  },
                  icon: const Icon(Icons.expand_more_rounded),
                  elevation: 16,
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  dropdownColor: Colors.white,
                  style: Theme.of(context).textTheme.bodyLarge,
                  decoration: InputDecoration(
                    fillColor: Theme.of(context).colorScheme.surface,
                    filled: true,
                    labelText: 'Select Zone',
                    prefixIcon: const Icon(Icons.factory_rounded),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        borderSide: BorderSide.none),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                  ),
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
                      _loadZones();
                    });
                  },
                ),

                const SizedBox(height: 20),

                // select date
                TextFormField(
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a valid date.';
                    }
                    return null;
                  },
                  controller: _datePickedController,
                  readOnly: true,
                  onTap: () => _selectDate(),
                  style: Theme.of(context).textTheme.bodyLarge,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: Theme.of(context).colorScheme.surface,
                    filled: true,
                    labelText: 'Select Date',
                    prefixIcon: const Icon(Icons.event_rounded),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // select zone
                DropdownButtonFormField<Zone>(
                  validator: (value) {
                    if (value == null || value.zoneName.trim().isEmpty) {
                      return 'Please choose a zone.';
                    }
                    return null;
                  },
                  icon: const Icon(Icons.expand_more_rounded),
                  elevation: 16,
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  dropdownColor: Colors.white,
                  style: Theme.of(context).textTheme.bodyLarge,
                  decoration: InputDecoration(
                    fillColor: Theme.of(context).colorScheme.surface,
                    filled: true,
                    labelText: 'Select Zone',
                    prefixIcon: const Icon(Icons.forklift),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        borderSide: BorderSide.none),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                  ),
                  value: zones.isNotEmpty ? zones.first : null,
                  items: zones.isEmpty
                      ? null
                      : zones
                          .map(
                            (zone) => DropdownMenuItem(
                              value: zone,
                              child: Text(zone.zoneName),
                            ),
                          )
                          .toList(), //_zoneList

                  onChanged: (zone) {
                    setState(() {
                      _selectedZone = zone!;
                    });
                  },
                ),

                const SizedBox(height: 20),

                // select zone leader
                TextFormField(
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter zone leader\'s name.';
                    }
                    return null;
                  },
                  controller: _zoneLeaderController,
                  autocorrect: false,
                  keyboardType: TextInputType.name,
                  style: Theme.of(context).textTheme.bodyLarge,
                  decoration: const InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    prefixIcon: Icon(
                      Icons.badge_rounded,
                      size: 25,
                    ),
                    labelText: 'Enter Zone Leader',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // button for clicking picture
                Align(
                  child: SizedBox(
                    width: 190,
                    height: 60,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)))),
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.primaryContainer)),
                      onPressed: getImage,
                      child: _image == null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.add_a_photo_rounded),
                                const SizedBox(width: 10),
                                Text('Click Picture',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Click Again',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                                const SizedBox(width: 10),
                                const Icon(Icons.replay_rounded),
                              ],
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                // buttons for ok and not ok
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // OK button
                    ElevatedButton.icon(
                      icon: const Icon(Icons.check),
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)))),
                          minimumSize:
                              MaterialStateProperty.all(const Size(120, 50)),
                          textStyle: MaterialStateProperty.all(
                              Theme.of(context).textTheme.bodyLarge),
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 156, 241, 150))),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ZoneDetails zoneDetails = ZoneDetails();

                          zoneDetails.plantName = _selectedPlant.plantName;
                          zoneDetails.datePicked = _datePickedController.text;
                          zoneDetails.zoneName = _selectedZone.zoneName;
                          zoneDetails.zoneLeader = _zoneLeaderController.text;
                          zoneDetails.pathType = "OK";

                          if (_image == null) {
                            final snackBar = showCustomSnackbar(
                              text: 'Please click a picture to submit.',
                              colour: 'warning',
                            );
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            return;
                          }

                          zoneDetails.image = _image!;

                          // Go to submit page
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            // return Details(zoneDetails: zoneDetails);
                            return ZoneDetailsSubmitScreen(
                              zoneDetails: zoneDetails,
                            );
                          }));
                        }
                      },
                      label: const Text("OK"),
                    ),

                    const SizedBox(width: 50),

                    // Not OK Button
                    ElevatedButton.icon(
                      icon: const Icon(Icons.close),
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)))),
                          minimumSize:
                              MaterialStateProperty.all(const Size(120, 50)),
                          textStyle: MaterialStateProperty.all(
                              Theme.of(context).textTheme.bodyLarge),
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 246, 114, 128))),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ZoneDetails zoneDetails = ZoneDetails();

                          zoneDetails.plantName = _selectedPlant.plantName;
                          zoneDetails.datePicked = _datePickedController.text;
                          zoneDetails.zoneName = _selectedZone.zoneName;
                          zoneDetails.zoneLeader = _zoneLeaderController.text;
                          zoneDetails.pathType = "Not OK";
                          
                          if (_image == null) {
                            final snackBar = showCustomSnackbar(
                              text: 'Please click a picture to submit.',
                              colour: 'warning',
                            );
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            return;
                          }

                          zoneDetails.image = _image!;

                          // Go to submit page
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ZoneDetailsSubmitScreen(
                              zoneDetails: zoneDetails,
                            );
                          }));
                        }
                      },
                      label: const Text("Not OK"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
