import 'package:Fixed_Point_Adherence/screens/download_data.dart';
import 'package:Fixed_Point_Adherence/utility/CustomSnackbar.dart';
import 'package:flutter/material.dart';

// database and excel
import 'package:Fixed_Point_Adherence/helpers/database_helper.dart';
import 'package:Fixed_Point_Adherence/helpers/save_to_excel.dart';
import 'package:intl/intl.dart';

DatabaseHelper databaseHelper = DatabaseHelper();
ExcelHelper excelHelper = ExcelHelper();

Future<bool> deleteOneWeekOldData() async {
  try {
    await databaseHelper.deleteData();
    return true;
  } catch (e) {
    return false;
  }
}

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});


  @override
  State<AdminScreen> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminScreen> {
  bool downloaded = true;
  bool deleted = true;
  int numEntries = 0;

  @override
  void initState() {
    getEntriesCount();
    super.initState();
  }

  void getEntriesCount() async {
    int count = await databaseHelper
        .countEntriesToday(DateFormat('dd-MM-yyyy').format(DateTime.now()));
    setState(() {
      numEntries = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // logo
          const SizedBox(
            height: 100,
            width: 100,
            child: Image(
              image: AssetImage('assets/images/wipro_black_logo.png'),
            ),
          ),
      
          const SizedBox(height: 100),
      
          // show count of entries
          Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  numEntries.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge!
                      .copyWith(fontSize: 72),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.outline),
                          children: [
                            (numEntries == 1
                                ? const TextSpan(text: 'ENTRY\n')
                                : const TextSpan(text: 'ENTRIES\n')),
                            const TextSpan(text: 'DONE\n'),
                            const TextSpan(text: 'TODAY'),
                          ]),
                    ),
                  ],
                )
              ],
            ),
          ),
      
          const SizedBox(height: 80),
      
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // download data button
              InkWell(
                onTap: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const DownloadDataScreen()));
                  getEntriesCount();
                },
                borderRadius: BorderRadius.circular(15),
                splashColor: Theme.of(context).primaryColor,
                child: Container(
                  height: 125,
                  width: 150,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.black.withOpacity(0.85),
                        Colors.black.withOpacity(1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.download_rounded,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Save Data',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
      
              const SizedBox(width: 20),
      
              // delete data button
              InkWell(
                onTap: () async {
                  setState(() {
                    deleted = false;
                  });
                  bool status = await deleteOneWeekOldData();
                  final snackBar = status
                      ? showCustomSnackbar(
                          text: 'Week older data deleted.', colour: 'success')
                      : showCustomSnackbar(
                          text: 'Error occurred while deleting.',
                          colour: 'failure');
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  setState(() {
                    deleted = true;
                  });
                },
                borderRadius: BorderRadius.circular(15),
                splashColor: Theme.of(context).primaryColor,
                child: Container(
                  height: 125,
                  width: 150,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.black.withOpacity(0.85),
                        Colors.black.withOpacity(1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: deleted
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.delete_rounded,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Delete Data',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: Colors.white),
                            ),
                          ],
                        )
                      : const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}