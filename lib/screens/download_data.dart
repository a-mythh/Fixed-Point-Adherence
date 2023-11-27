import 'package:Fixed_Point_Adherence/helpers/save_to_excel.dart';
import 'package:Fixed_Point_Adherence/utility/CustomSnackbar.dart';
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
        title: const Text('Save Data'),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(17),
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // download today's data
                    InkWell(
                      onTap: () async {
                        setState(() {
                          downloadedToday = false;
                        });
                        bool status = await excelHelper.saveTodaysDataToExcel();
                        setState(() {
                          downloadedToday = true;
                        });

                        final snackBar = status
                            ? showCustomSnackbar(
                                text: 'Download successful.',
                                colour: 'success',
                              )
                            : showCustomSnackbar(
                                text: 'Download unsuccessful.',
                                colour: 'failure',
                              );

                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                              Colors.black.withOpacity(0.77),
                              Colors.black.withOpacity(0.85),
                              Colors.black.withOpacity(1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: downloadedToday
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.file_download_rounded,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Today\'s Data',
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

                    const SizedBox(height: 80),

                    // text to indicate download by date
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 10,
                      ),
                      decoration: const BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Text(
                        'Download by date',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // download data by date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          width: 200,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please choose a date.';
                              }
                              return null;
                            },
                            controller: _dateController,
                            readOnly: true,
                            onTap: () => _selectDate(),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              fillColor: Theme.of(context).colorScheme.surface,
                              filled: true,
                              floatingLabelAlignment:
                                  FloatingLabelAlignment.center,
                              contentPadding: const EdgeInsets.all(20),
                              labelText: "Select Date",
                              prefixIcon:
                                  const Icon(Icons.calendar_month_rounded),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            if (_dateController.text.isEmpty) {
                              final snackBar = showCustomSnackbar(
                                text: 'Please choose a date.',
                                colour: 'warning',
                              );
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              return;
                            }
                            setState(() {
                              downloadedAnyDate = false;
                            });
                            bool status =
                                await excelHelper.saveGivenDatesDataToExcel(
                                    _dateController.text);
                            setState(() {
                              downloadedAnyDate = true;
                            });

                            final snackBar = status
                                ? showCustomSnackbar(
                                    text: 'Download successful.',
                                    colour: 'success',
                                  )
                                : showCustomSnackbar(
                                    text: 'Download unsuccessful.',
                                    colour: 'failure',
                                  );

                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          },
                          borderRadius: BorderRadius.circular(15),
                          splashColor: Theme.of(context).primaryColor,
                          child: Container(
                            height: 40,
                            width: 60,
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
                            child: downloadedAnyDate
                                ? const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.downloading_rounded,
                                        color: Colors.white,
                                      ),
                                    ],
                                  )
                                : const Center(
                                    child: SizedBox(
                                      width: 15,
                                      height: 15,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
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
              Text(
                'Files are saved in Documents folder of Internal Storage.',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
