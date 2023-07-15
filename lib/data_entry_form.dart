import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DataEntryForm extends StatefulWidget {
  const DataEntryForm({super.key});

  @override
  State<DataEntryForm> createState() => _DataEntryFormState();
}

class _DataEntryFormState extends State<DataEntryForm> {

  // constructor of the form class
  _DataEntryFormState() {
    _selected_plant = _plantList[0];
  }

  // initialize the state variables
  @override
  void initState() {

    _date_picked.text = "";
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
        _date_picked.text = DateFormat('dd-MMMM-yyyy').format(datePicked);
      });
    }
  }

  // declare controllers here
  final TextEditingController _date_picked = TextEditingController();

  // declare variables here
  final _plantList = ["Chennai", "Mumbai", "Kolkata", "Shillong", "Delhi"];
  String? _selected_plant = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: ListView(

        children: [

          // select plant
          DropdownButtonFormField(

            // add some decoration to the drop down menu
            decoration: const InputDecoration(
              labelText: "Select Plant",
              prefixIcon: Icon(
                Icons.accessibility_new_rounded,
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

            controller: _date_picked,

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
          )

        ],
      ),
    );
  }
}
