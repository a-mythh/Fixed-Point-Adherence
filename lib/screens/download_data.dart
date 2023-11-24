import 'package:Fixed_Point_Adherence/helpers/save_to_excel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

ExcelHelper excelHelper = ExcelHelper();

class DownloadDataScreen extends StatefulWidget {
  const DownloadDataScreen({super.key});

  @override
  State<DownloadDataScreen> createState() => _DownloadDataScreenState();
}

class _DownloadDataScreenState extends State<DownloadDataScreen> {
  late final TextEditingController _dateController = TextEditingController();
  bool downloadedToday = true;
  bool downloadedAnyDate = true;

  @override
  void initState() {
    super.initState();

    _dateController.text = '';
  }

  @override
  void dispose() {
    _dateController.dispose();

    super.dispose();
  }

  // function to open date picker
  Future _selectDate() async {
    DateTime? datePicked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(const Duration(days: 7)),
        lastDate: DateTime.now());

    if (datePicked != null) {
      setState(() {
        _dateController.text = DateFormat('dd-MM-yyyy').format(datePicked);
      });
      print(_dateController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Download Data'),
        backgroundColor: Colors.green.shade200,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // download today's data
              InkWell(
                onTap: () async {
                  setState(() {
                    downloadedToday = false;
                  });
                  await excelHelper.saveTodaysDataToExcel();
                  setState(() {
                    downloadedToday = true;
                  });
                },
                borderRadius: BorderRadius.circular(15),
                splashColor: Theme.of(context).primaryColor,
                child: Container(
                  height: 120,
                  width: 180,
                  padding: const EdgeInsets.all(15),
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
                  child: downloadedToday
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.file_download_rounded),
                            Text(
                              'Download Today\'s Data',
                              textAlign: TextAlign.center,
                            ),
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

              const SizedBox(height: 80),

              // text to indicate download by date
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                    color: Colors.blue.shade200,
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: const Text('Download by date'),
              ),

              const SizedBox(height: 30),

              // download data by date
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    width: 180,
                    child: TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      onTap: () => _selectDate(),
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide:
                                BorderSide(color: Colors.lime, width: 2)),
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                        contentPadding: EdgeInsets.all(20),
                        labelText: "Select Date",
                        prefixIcon: Icon(
                          Icons.calendar_month_rounded,
                          color: Colors.lime,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      if (_dateController.text.isEmpty) {
                        return;
                      }
                      setState(() {
                        downloadedAnyDate = false;
                      });
                      print(_dateController.text);
                      await excelHelper
                          .saveGivenDatesDataToExcel(_dateController.text);
                      setState(() {
                        downloadedAnyDate = true;
                      });
                    },
                    borderRadius: BorderRadius.circular(15),
                    splashColor: Theme.of(context).primaryColor,
                    child: Container(
                      height: 40,
                      width: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.lime.withOpacity(0.4),
                            Colors.lime.withOpacity(0.9)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: downloadedAnyDate
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.downloading_rounded),
                              ],
                            )
                          : const Center(
                              child: SizedBox(
                                width: 15,
                                height: 15,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  backgroundColor: Colors.lime,
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
