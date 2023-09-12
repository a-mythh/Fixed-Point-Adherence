import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:Fixed_Point_Adherence/models/zone_details.dart';
import 'package:Fixed_Point_Adherence/submit_form.dart';

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

  // constructor of the form class
  _DataEntryFormState() {
    _selected_plant = "";
    _selected_zone = "";
  }

  // initialize the state variables
  @override
  void initState() {

    _date_picked_Controller.text = "";
    super.initState();

  }

  // function to open date picker
  Future _select_date() async {

    DateTime? datePicked = await showDatePicker(
              context: context, 
              initialDate: DateTime.now(), 
              firstDate: DateTime(2022), 
              lastDate: DateTime.now()
          );

    if (datePicked != null)
    {
      setState(() {
        _date_picked_Controller.text = DateFormat('dd-MMMM-yyyy').format(datePicked);
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
        this._image = imageTemp;
      });

    } on PlatformException catch (e) {

      print("Failed to pick image: $e");

    }
  }

  // // declare variables here
  // List<Map<String, dynamic>>? _plantListData;
  // //List<Map<String, dynamic>>? _zoneListData;
  // List<String> plantList = [];
  // //List<String> _zoneList = [];
  //
  // void fetchDataFromDatabase() async {
  //   _plantListData = await DatabaseHelper().getRecordsPlants();
  //
  //   for (var row in _plantListData!) { // Cast the value to String
  //     plantList.add(row['plantName']); // Remove the null-safe access operator '?'
  //   }
  // }

  // declare controllers here
  final TextEditingController _date_picked_Controller = TextEditingController();
  final TextEditingController _zone_leader_Controller = TextEditingController();

  String? _selected_plant = "";
  String? _selected_zone = "";

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(20.0),
      child: ListView(

        children: [

          const SizedBox(
            
            height: 50,
            width: 50,

            child: Image(
              
              image: AssetImage('images/wipro_logo.png'),
            ),

          ),

          const SizedBox(height: 20,),

          const Text("Zone Data Entry", 
          
          textAlign: TextAlign.center,

          style: TextStyle(
            fontFamily: "Roboto", 
            fontSize: 22, 
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 59, 57, 57),
          ),
        
        ),

          const SizedBox(height: 20,),

          /* Form for data entry */ 
          Form(

            key: _formKey,
          
            child: Column(

              children: [

                // select plant
                DropdownButtonFormField(

                  // add some decoration to the drop down menu
                  decoration: const InputDecoration(
                    labelText: "Select Plant",
                    prefixIcon: Icon(
                      Icons.factory_rounded,
                      color: Colors.deepPurple,
                    ),
                    border: OutlineInputBorder(),
                  ),

                  // list of items to show in the plant drop down menu
                   items: [], //plantList
                      // .map((plant) => DropdownMenuItem(
                      //       value: plant,
                      //       child: Text(plant),
                      //     ))
                      // .toList(),

                  // what happens when a value is selected
                  onChanged: (value) {
                    setState(() {
                      _selected_plant = value as String;
                    });
                  },
                ),
              
                const SizedBox(height: 40,),

                // select date
                TextFormField(

                  controller: _date_picked_Controller,

                  readOnly: true,

                  onTap: () => _select_date(),


                  decoration: const InputDecoration(
                    labelText: "Select Date",
                    prefixIcon: Icon(
                      Icons.calendar_month_rounded,
                      color: Colors.deepPurple
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 40,),

                // select zone
                IgnorePointer(
                  ignoring: _selected_plant == null || _selected_plant!.isEmpty,
                  child: DropdownButtonFormField(
                    // add some decoration to the drop down menu
                    decoration: const InputDecoration(
                      labelText: "Select Zone",
                      prefixIcon: Icon(
                        Icons.room_rounded,
                        color: Colors.deepPurple,
                      ),
                      border: OutlineInputBorder(),
                    ),

                    // list of items to show in the zone drop down menu
                     items: [], //_zoneList
                    //     .map((plant) => DropdownMenuItem(
                    //   value: plant,
                    //   child: Text(plant),
                    // ))
                    //     .toList(),

                    // what happens when a value is selected
                    onChanged: (value) {
                      setState(() {
                        _selected_zone = value as String;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 40,),

                TextFormField(

                  controller: _zone_leader_Controller,

                  decoration: const InputDecoration(
                    labelText: "Enter Zone Leader",
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.deepPurple
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              
                const SizedBox(height: 40,),

                // button for clicking picture
                Align(

                  child: SizedBox(

                    width: 170,
                    height: 50,

                    child: ElevatedButton(
                    
                      onPressed: getImage,
                      
                      child: _image == null ? const Row(

                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.deepPurple,
                          ),
                          SizedBox(width: 10,),
                          Text('Click Picture'),
                        ],
                      ) : const Row(
                        
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Text('Click Again'),
                          SizedBox(width: 10,),
                          Icon(
                            Icons.replay_rounded,
                            color: Colors.deepPurple,
                          ),
                        ],
                      ),
                      
                    ),

                  ),
                ),
              
                const SizedBox(height: 40,),
              
                // buttons for ok and not ok
                Row(

                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                  children: [

                    // OK button
                    ElevatedButton(

                      style: ElevatedButton.styleFrom(

                        textStyle: TextStyle(fontWeight: FontWeight.bold),

                        backgroundColor: const Color.fromARGB(255, 71, 221, 76),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(100, 50),
                      ),
                      
                      onPressed: () {

                        if (_formKey.currentState!.validate()) {

                          ZoneDetails zoneDetails = ZoneDetails();

                          zoneDetails.plantName = _selected_plant!;
                          zoneDetails.datePicked = _date_picked_Controller.text;
                          zoneDetails.zoneName = _selected_zone!;
                          zoneDetails.zoneLeader = _zone_leader_Controller.text;
                          zoneDetails.pathType = "OK";
                          zoneDetails.image = _image!;

                          // Go to submit page
                          Navigator.push(context, MaterialPageRoute(builder: (context) {

                            // return Details(zoneDetails: zoneDetails);
                            return ZoneDetailsSubmitForm(zoneDetails: zoneDetails,);

                          }));

                        }

                      },
                      child: const Text("OK"),

                    ),

                    SizedBox(width: 50,),

                    // Not OK Button
                    ElevatedButton(

                      style: ElevatedButton.styleFrom(

                        textStyle: TextStyle(fontWeight: FontWeight.bold),

                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(100, 50),
                      ),

                      onPressed: () {

                        if (_formKey.currentState!.validate()) {

                          ZoneDetails zoneDetails = ZoneDetails();

                          zoneDetails.plantName = _selected_plant!;
                          zoneDetails.datePicked = _date_picked_Controller.text;
                          zoneDetails.zoneName = _selected_zone!;
                          zoneDetails.zoneLeader = _zone_leader_Controller.text;
                          zoneDetails.pathType = "Not OK";
                          zoneDetails.image = _image!;

                          // Go to submit page
                          Navigator.push(context, MaterialPageRoute(builder: (context) {

                            // return Details(zoneDetails: zoneDetails);
                            return ZoneDetailsSubmitForm(zoneDetails: zoneDetails,);

                          }));

                        }

                      },
                      child: const Text("Not OK"),
                      
                    ),
                  ],

                )

              ],

            )
          
          ),
          SizedBox(height: 10,),

          ElevatedButton(
            onPressed: () {
              excelHelper.saveToExcel();// Save To Excel Button
            },
            child: const Row(

              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Icon(
                  Icons.file_download,
                  color: Colors.deepPurple,
                ),
                SizedBox(width: 10,),
                Text('Generate Excel'),
              ],
            ),
          )

        ],
      ),
    );
  }
}
