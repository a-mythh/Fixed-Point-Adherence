import 'package:Fixed_Point_Adherence/models/plant_zone.dart';
import 'package:Fixed_Point_Adherence/screens/download_data.dart';
import 'package:Fixed_Point_Adherence/screens/manage_users.dart';
import 'package:Fixed_Point_Adherence/screens/plants.dart';
import 'package:Fixed_Point_Adherence/screens/zones.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// database and excel
import 'package:Fixed_Point_Adherence/helpers/database_helper.dart';
import 'package:Fixed_Point_Adherence/helpers/save_to_excel.dart';

DatabaseHelper databaseHelper = DatabaseHelper();
ExcelHelper excelHelper = ExcelHelper();

Future<void> deleteOneWeekOldData() async {
  try {
    await databaseHelper.deleteData();
    print('OKAY');

    await Fluttertoast.showToast(
      msg: 'Successfully deleted week older data',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  } catch (e) {
    await Fluttertoast.showToast(
      msg: 'Error occurred while deleting data',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }
}

class AdminPage extends StatefulWidget {
  AdminPage({required this.username, super.key});

  String username;

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  bool downloaded = true;
  bool deleted = true;

  @override
  Widget build(BuildContext context) {
    print(widget.username);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(1),
            ),
            onPressed: () async {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/');

              await Fluttertoast.showToast(
                msg: 'Admin successfully logged out!',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.green,
                textColor: Colors.white,
              );
            },
            child: const Icon(
              Icons.power_settings_new_rounded,
              color: Colors.blue,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 100),

            const SizedBox(
              height: 100,
              width: 100,
              child: Image(
                image: AssetImage('images/wipro_logo.png'),
              ),
            ),
            const SizedBox(height: 100),

            // grid button layout
            Expanded(
              child: GridView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 30,
                ),
                children: [
                  // add user button
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/new_user');
                    },
                    borderRadius: BorderRadius.circular(15),
                    splashColor: Theme.of(context).primaryColor,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.withOpacity(0.4),
                            Colors.blue.withOpacity(0.9)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_add,
                          ),
                          Text('Add User'),
                        ],
                      ),
                    ),
                  ),

                  // manage user button
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ManageUsersScreen(currentUser: widget.username),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(15),
                    splashColor: Theme.of(context).primaryColor,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.yellow.withOpacity(0.4),
                            Colors.yellow.withOpacity(0.9)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.manage_accounts_rounded,
                          ),
                          Text('Manage Users'),
                        ],
                      ),
                    ),
                  ),

                  // download data button
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const DownloadDataScreen()));
                    },
                    /*
                    onTap: () async {
                      setState(() {
                        downloaded = false;
                      });
                      await excelHelper.saveTodaysDataToExcel();
                      setState(() {
                        downloaded = true;
                      });
                    },
                    */
                    borderRadius: BorderRadius.circular(15),
                    splashColor: Theme.of(context).primaryColor,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.withOpacity(0.4),
                            Colors.green.withOpacity(0.9)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: downloaded
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.save_alt_rounded,
                                ),
                                Text('Download Data'),
                              ],
                            )
                          : const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                backgroundColor: Colors.green,
                              ),
                            ),
                    ),
                  ),

                  // delete data button
                  InkWell(
                    onTap: () async {
                      setState(() {
                        deleted = false;
                      });
                      await deleteOneWeekOldData();
                      setState(() {
                        deleted = true;
                      });
                    },
                    borderRadius: BorderRadius.circular(15),
                    splashColor: Theme.of(context).primaryColor,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.red.withOpacity(0.4),
                            Colors.red.withOpacity(0.9)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: deleted
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.delete_rounded,
                                ),
                                Text('Delete Data'),
                              ],
                            )
                          : const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                backgroundColor: Colors.red,
                              ),
                            ),
                    ),
                  ),

                  // plants edit button
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const PlantScreen()));
                    },
                    borderRadius: BorderRadius.circular(15),
                    splashColor: Theme.of(context).primaryColor,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.pink.withOpacity(0.4),
                            Colors.pink.withOpacity(0.9)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit_location_alt,
                          ),
                          Text('Plants'),
                        ],
                      ),
                    ),
                  ),

                  // zones edit button
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ZoneScreen(),
                      ));
                    },
                    borderRadius: BorderRadius.circular(15),
                    splashColor: Theme.of(context).primaryColor,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.indigo.withOpacity(0.4),
                            Colors.indigo.withOpacity(0.9)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.room_preferences_rounded,
                          ),
                          Text('Zones'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /*
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context,
                    '/new_user'); // Navigate to the new user register page
              },
              child: const Text('Register User'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context,
                    '/new_location'); // Navigate to the new location page
              },
              child: const Text('Register New Locations'),
            ),



            /*** Download file buttons ***/
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                excelHelper
                    .saveTodaysDataToExcel(); // Save Today's Data to Excel Button
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.file_download,
                    color: Colors.deepPurple,
                  ),
                  SizedBox(width: 10),
                  Text('Save Today\'s Data'),
                ],
              ),
            ),


            /*** Delete 1 week old data ***/
            const SizedBox(height: 40),
            const ElevatedButton(
              onPressed: deleteOneWeekOldData,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.file_download,
                    color: Colors.deepPurple,
                  ),
                  SizedBox(width: 10),
                  Text('Delete 1 week old data'),
                ],
              ),
            ),



            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                excelHelper.saveToExcel(); // Save To Excel Button
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.file_download,
                    color: Colors.deepPurple,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Generate Excel'),
                ],
              ),
            ),
            */
          ],
        ),
      ),
    );
  }
}
