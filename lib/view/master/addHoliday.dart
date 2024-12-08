import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gims/model/Request/addHolidayRequest.dart';
import 'package:gims/model/Response/SimpleResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gims/Api/AppCommonVariable.dart';
import 'package:gims/api/webService.dart';
import 'package:gims/controllers/AppUtil.dart';
import 'package:gims/responsive.dart';
import 'package:gims/view/home/sidebar.dart';

class AddHoliday extends StatefulWidget {
  const AddHoliday({super.key});

  @override
  State<AddHoliday> createState() => _AddHolidayState();
}

class _AddHolidayState extends State<AddHoliday> {
  int crocesscount = 0;
  double childAspect = 0.00;
  bool babkbutton = false;
  String permissions = '';
  TextEditingController nameController = TextEditingController();
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final AddHolidayRequest addHolidayRequest = AddHolidayRequest("", "", "");
  SimpleResponse addResponse = SimpleResponse();
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      setState(() {
        permissions = sp.getString(PERMISSIONS)!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Responsive.isDesktop(context)) {
      crocesscount = 2;
      childAspect = 10 / 1.5;
      babkbutton = false;
    } else if (Responsive.isTablet(context)) {
      crocesscount = 2;
      childAspect = 10 / 0.9;
      babkbutton = false;
    } else {
      crocesscount = 1;
      childAspect = 8 / 2;
      babkbutton = true;
    }
    if (permissions.isEmpty) {
      // Permissions not fetched yet, return a loading indicator or empty container
      return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SpinKitCircle(
            color: Theme.of(context).primaryColor,
            size: 70.0,
            duration: const Duration(milliseconds: 1200),
          ));
    } else if (permissions.contains('add_holiday')) {
      return SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            automaticallyImplyLeading: babkbutton,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/ManageHoliday');
                }),
            title: Responsive.isDesktop(context)
                ? const Text(
                    'Add Holiday',
                    style: TextStyle(color: Colors.white),
                  )
                : const Text(
                    'Add Holiday',
                    style: TextStyle(color: Colors.white),
                  ),
          ),
          // drawer: Responsive.isDesktop(context) ? null : DrawerMenu(),
          body: SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // We want this side menu only for large screen
                if (Responsive.isDesktop(context))
                  const Expanded(
                    // default flex = 1
                    // and it takes 1/6 part of the screen
                    child: DrawerMenu(),
                  ),

                Expanded(
                    // It takes 5/6 part of the screen
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: SizedBox(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: permissions.contains('add_holiday')
                                  ? Column(
                                      children: [
                                        GridView.count(
                                          crossAxisCount: crocesscount,
                                          childAspectRatio: childAspect,
                                          shrinkWrap: true,
                                          mainAxisSpacing: 20,
                                          crossAxisSpacing: 15,
                                          children: [
                                            TextFormField(
                                              controller: nameController,
                                              keyboardType: TextInputType.name,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: ' Name',
                                                hintText: 'Enter Holiday Name*',
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 8, bottom: 4),
                                                  child: Text(
                                                    'Holiday From',
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                                DateTimePicker(
                                                  controller: fromController,
                                                  style: const TextStyle(
                                                    fontStyle: FontStyle.normal,
                                                    color: Colors.black,
                                                  ),
                                                  type: DateTimePickerType.date,
                                                  firstDate: DateTime(2023),
                                                  lastDate: DateTime(2050),
                                                  decoration: InputDecoration(
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              11),
                                                      borderSide: BorderSide(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors
                                                            .grey.shade400,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              11),
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              11),
                                                    ),
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                      horizontal: 10,
                                                      vertical: 2,
                                                    ),
                                                    hintText:
                                                        'Select From Date',
                                                    labelStyle: TextStyle(
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      color:
                                                          Colors.grey.shade400,
                                                    ),
                                                    hintStyle: TextStyle(
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      color:
                                                          Colors.grey.shade400,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 8, bottom: 4),
                                                  child: Text(
                                                    'Holiday Till',
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                                DateTimePicker(
                                                  controller: toController,
                                                  style: const TextStyle(
                                                    fontStyle: FontStyle.normal,
                                                    color: Colors.black,
                                                  ),
                                                  type: DateTimePickerType.date,
                                                  firstDate: DateTime(2023),
                                                  lastDate: DateTime(2050),
                                                  decoration: InputDecoration(
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              11),
                                                      borderSide: BorderSide(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors
                                                            .grey.shade400,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              11),
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              11),
                                                    ),
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                      horizontal: 10,
                                                      vertical: 2,
                                                    ),
                                                    hintText: 'Select To Date',
                                                    labelStyle: TextStyle(
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      color:
                                                          Colors.grey.shade400,
                                                    ),
                                                    hintStyle: TextStyle(
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      color:
                                                          Colors.grey.shade400,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 25,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                width: 130.0,
                                                child: ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          WidgetStateProperty
                                                              .resolveWith<
                                                                  Color?>(
                                                        (Set<WidgetState>
                                                            states) {
                                                          if (states.contains(
                                                              WidgetState
                                                                  .pressed)) {
                                                            return Theme.of(
                                                                    context)
                                                                .primaryColor;
                                                          }
                                                          return Theme.of(
                                                                  context)
                                                              .primaryColor; // Use the component's default.
                                                        },
                                                      ),
                                                    ),
                                                    child: const Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 9.0,
                                                          bottom: 9.0),
                                                      child: Text(
                                                        'Submit',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      if (nameController
                                                          .text.isEmpty) {
                                                        AppUtil.showToast(
                                                            "Please Enter Holiday Name",
                                                            "e");
                                                      } else if (fromController
                                                          .text.isEmpty) {
                                                        AppUtil.showToast(
                                                            "Please Select Start Date",
                                                            "e");
                                                      } else if (toController
                                                          .text.isEmpty) {
                                                        AppUtil.showToast(
                                                            "Please Select End Date",
                                                            "e");
                                                      } else {
                                                        addHolidayRequest
                                                                .holiday =
                                                            nameController.text
                                                                .trim();
                                                        addHolidayRequest.from =
                                                            fromController.text
                                                                .trim();
                                                        addHolidayRequest.to =
                                                            toController.text
                                                                .trim();

                                                        Webservice _service =
                                                            Webservice();
                                                        _service
                                                            .addHoliday(
                                                                addHolidayRequest)
                                                            .then(
                                                                (value) async {
                                                          addResponse = value;

                                                          if (addResponse
                                                                  .error ==
                                                              false) {
                                                            AppUtil.showToast(
                                                                addResponse
                                                                    .msg!,
                                                                "s");

                                                            Navigator
                                                                .pushReplacementNamed(
                                                                    context,
                                                                    '/ManageHoliday');
                                                          } else {
                                                            AppUtil.showToast(
                                                                addResponse
                                                                    .msg!,
                                                                'e');
                                                          }
                                                        });
                                                        setState(() {});
                                                      }
                                                    }),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : const SizedBox()),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      );
    } else {
      Future.delayed(Duration.zero, (() => filterDialog()));
      return const SizedBox.shrink();
    }
  }

  filterDialog() {
    showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              actions: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Icon(
                          Icons.highlight_remove,
                          color: Theme.of(context).primaryColor,
                          size: 80.0,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        const Text(
                          "You don't have the permissions to do that!",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Theme.of(context).primaryColor;
                                }
                                return Theme.of(context)
                                    .primaryColor; // Use the component's default.
                              },
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(top: 9.0, bottom: 9.0),
                            child: Text(
                              'Go Back',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/home');
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
