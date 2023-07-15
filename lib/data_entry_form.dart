import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum PathTypeEnum { Path_is_ok, Path_is_not_ok }

class DataEntryForm extends StatefulWidget {
  const DataEntryForm({super.key});

  @override
  State<DataEntryForm> createState() => _DataEntryFormState();
}

class _DataEntryFormState extends State<DataEntryForm> {

  // constructor of the form class
  _DataEntryFormState() {
    _selected_plant = _plantList[0];
    _selected_zone = _zoneList[0];
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

  // declare enums here
  PathTypeEnum? _pathTypeEnum;

  // declare controllers here
  final TextEditingController _date_picked_Controller = TextEditingController();
  final TextEditingController _zone_leader_Controller = TextEditingController();

  // declare variables here
  final _plantList = ["Chennai", "Mumbai", "Kolkata", "Shillong", "Delhi"];
  final _zoneList = [
    "Zone 1", "Zone 2", "Zone 3", "Zone 4", "Zone 5", 
    // "Zone 6", "Zone 7", "Zone 8", "Zone 9", "Zone 10", 
    // "Zone 11", "Zone 12", "Zone 13", "Zone 14", "Zone 15", 
    // "Zone 16", "Zone 17", "Zone 18", "Zone 19", "Zone 20"
  ];

  String? _selected_plant = "";
  String? _selected_zone = "";

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
            items: _plantList
                .map((plant) => DropdownMenuItem(
                      value: plant,
                      child: Text(plant),
                    ))
                .toList(),

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
          DropdownButtonFormField(

            // add some decoration to the drop down menu
            decoration: const InputDecoration(
              labelText: "Select Zone",
              prefixIcon: Icon(
                Icons.room_rounded,
                color: Colors.deepPurple,
              ),
              border: OutlineInputBorder(),
            ),

            // list of items to show in the plant drop down menu
            items: _zoneList
                .map((zone) => DropdownMenuItem(
                      value: zone,
                      child: Text(zone),
                    ))
                .toList(),

            // what happens when a value is selected
            onChanged: (value) {
              setState(() {
                _selected_zone = value as String;
              });
            },
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

              width: 150,
              height: 50,

              child: ElevatedButton(
              
                onPressed: () {},
                
                child: const Text('Click Picture'),
                
              ),

            ),
          ),
        
          const SizedBox(height: 40,),
        
          // Row(
          //   children: [

          //           Expanded(
          //             child: RadioListTile<PathTypeEnum>(


                    
          //               contentPadding: EdgeInsets.all(0.0),
                    
          //               title: const Text("OK"),

          //               tileColor: Color.fromARGB(255, 198, 255, 133),

          //               shape: RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(40.0)
          //               ),
                    
          //               value: PathTypeEnum.Path_is_ok, 
          //               groupValue: _pathTypeEnum, 
                    
          //               onChanged: (value) {
          //                 setState(() {
          //                   _pathTypeEnum = value;
          //                 });
          //               },
                    
          //             ),
          //           ),

          //           SizedBox(width: 20.0,),

          //           Expanded(
          //             child: RadioListTile<PathTypeEnum>(
                    
          //               contentPadding: EdgeInsets.all(0.0),
                    
          //               title: const Text("Not OK"),

          //               tileColor: Color.fromARGB(255, 255, 154, 154),

          //               shape: RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(40.0)
          //               ),
                    
          //               value: PathTypeEnum.Path_is_not_ok, 
          //               groupValue: _pathTypeEnum, 
                    
          //               onChanged: (value) {
          //                 setState(() {
          //                   _pathTypeEnum = value;
          //                 });
          //               },
                    
          //             ),
          //           ),
          //   ],
          // ),

          // OK and Not OK buttons
          Row(

            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            children: [

              ElevatedButton(

                style: ElevatedButton.styleFrom(

                  textStyle: TextStyle(fontWeight: FontWeight.bold),

                  backgroundColor: const Color.fromARGB(255, 71, 221, 76),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(100, 50),
                ),
                
                onPressed: () {},
                child: const Text("OK"),

              ),

              SizedBox(width: 50,),

              ElevatedButton(

                style: ElevatedButton.styleFrom(

                  textStyle: TextStyle(fontWeight: FontWeight.bold),

                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(100, 50),
                ),

                onPressed: () {},
                child: const Text("Not OK"),
                
              ),
            ],

          )

          
        ],
      ),
    );
  }
}
