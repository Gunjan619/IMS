import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gims/model/Request/addSalaryStructureRequest.dart';
import 'package:gims/model/Request/simpleRequest.dart';
import 'package:gims/model/Response/manageFilterSlab.dart';
import 'package:gims/model/Response/staffResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gims/Api/AppCommonVariable.dart';
import 'package:gims/api/webService.dart';
import 'package:gims/controllers/AppUtil.dart';
import 'package:gims/model/Request/addSlabRequest.dart';
import 'package:gims/model/Response/SimpleResponse.dart';
import 'package:gims/responsive.dart';
import 'package:gims/view/home/sidebar.dart';

class GenerateSalary extends StatefulWidget {
  const GenerateSalary({super.key});

  @override
  State<GenerateSalary> createState() => _GenerateSalaryState();
}

class _GenerateSalaryState extends State<GenerateSalary> {
  int crocesscount = 0;
  double childAspect = 0.00;
  bool babkbutton = false;
  String permissions = '';
  TextEditingController yearController = TextEditingController();
  TextEditingController workingDaysController = TextEditingController();
  TextEditingController holidaysController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final AddSlabRequest addSlabRequest = AddSlabRequest("", "", "");
  SimpleResponse addResponse = SimpleResponse();
  SimpleModel simpleRequest = SimpleModel("");
  final Webservice _service = Webservice();
  StaffResponse feeStructureResponse = StaffResponse();
  ManageFilterSlab manageFilterSlab = ManageFilterSlab();
  AddSalaryStructureRequest addSalaryStructureRequest =
      AddSalaryStructureRequest("", "", "", "", "", "");
  bool isLoading = false;
  List additionList = [];
  List additionFiltered = [];
  List deductionList = [];
  List deductionFiltered = [];
  String additionResult = "";
  String deductionResult = "";

  List<String> items = [
    'Select Month',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12'
  ];
  List<String> items1 = [
    'Select Category',
    'All',
    'Teaching',
    'Non-Teaching',
  ];
  String? dropdownvalueService = 'Select Month';
  String? dropdownvalueService1 = 'Select Category';
  String EmpId = '';
  Map<String, TextEditingController> additionControllers = {};
  Map<String, TextEditingController> deductionControllers = {};
  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((SharedPreferences sp) {
      setState(() {
        isLoading = true;
      });
      permissions = sp.getString(PERMISSIONS)!;

      simpleRequest.type = 'additions';
      _service.filterSlab(simpleRequest).then((value) {
        manageFilterSlab = value;

        if (value.error == false) {
          setState(() {
            additionList = manageFilterSlab.data!;
            additionFiltered = additionList;
          });
        }
      });
      simpleRequest.type = 'deductions';
      _service.filterSlab(simpleRequest).then((value) {
        manageFilterSlab = value;

        if (value.error == false) {
          setState(() {
            deductionList = manageFilterSlab.data!;
            deductionFiltered = deductionList;

            for (var addition in additionFiltered) {
              additionControllers[addition.id] = TextEditingController();
            }
            for (var deduction in deductionFiltered) {
              deductionControllers[deduction.id] = TextEditingController();
            }

            isLoading = false;
          });
        }
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
      childAspect = 11 / 2;
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
    } else if (permissions.contains('add_structure')) {
      return isLoading
          ? SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: SpinKitCircle(
                color: Theme.of(context).primaryColor,
                size: 70.0,
                duration: const Duration(milliseconds: 1200),
              ))
          : SafeArea(
              child: Scaffold(
                key: _scaffoldKey,
                appBar: AppBar(
                  backgroundColor: Theme.of(context).primaryColor,
                  automaticallyImplyLeading: babkbutton,
                  leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, '/manageStructure');
                      }),
                  title: Responsive.isDesktop(context)
                      ? const Text(
                          'Generate Salary',
                          style: TextStyle(color: Colors.white),
                        )
                      : const Text(
                          'Generate Salary',
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
                                    child: permissions.contains('add_structure')
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              GridView.count(
                                                crossAxisCount: crocesscount,
                                                childAspectRatio: childAspect,
                                                shrinkWrap: true,
                                                mainAxisSpacing: 5,
                                                crossAxisSpacing: 15,
                                                children: [
                                                  DropdownButtonFormField(
                                                    isExpanded: true,
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 0),
                                                      labelText: "Select Month",
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                              ),
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .all(
                                                                      Radius.circular(
                                                                          6))),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .grey.shade500),
                                                      ),
                                                    ),
                                                    value:
                                                        dropdownvalueService ??
                                                            items[0],
                                                    icon: const Icon(Icons
                                                        .keyboard_arrow_down),
                                                    items: items.map(
                                                      (String items) {
                                                        return DropdownMenuItem(
                                                          value: items,
                                                          child: Text(items),
                                                        );
                                                      },
                                                    ).toList(),
                                                    onChanged:
                                                        (String? newValue) {
                                                      setState(
                                                        () {
                                                          dropdownvalueService =
                                                              newValue!;
                                                        },
                                                      );
                                                    },
                                                  ),
                                                  TextFormField(
                                                    controller: yearController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    maxLength: 4,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText: ' Year',
                                                      hintText: 'Enter Year',
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        workingDaysController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText:
                                                          ' Working Days',
                                                      hintText:
                                                          'Enter Working Days',
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        holidaysController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText: ' Holidays',
                                                      hintText:
                                                          'Enter Holidays',
                                                    ),
                                                  ),
                                                  DropdownButtonFormField(
                                                    isExpanded: true,
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 0),
                                                      labelText:
                                                          "Select Category",
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                              ),
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .all(
                                                                      Radius.circular(
                                                                          6))),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .grey.shade500),
                                                      ),
                                                    ),
                                                    value:
                                                        dropdownvalueService1 ??
                                                            items1[0],
                                                    icon: const Icon(Icons
                                                        .keyboard_arrow_down),
                                                    items: items1.map(
                                                      (String items) {
                                                        return DropdownMenuItem(
                                                          value: items,
                                                          child: Text(items),
                                                        );
                                                      },
                                                    ).toList(),
                                                    onChanged:
                                                        (String? newValue) {
                                                      setState(
                                                        () {
                                                          dropdownvalueService1 =
                                                              newValue!;
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Center(
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
                                                            child:
                                                                const Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 9.0,
                                                                      bottom:
                                                                          9.0),
                                                              child: Text(
                                                                'Submit',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              if (dropdownvalueService ==
                                                                  'Select Month') {
                                                                AppUtil.showToast(
                                                                    "Please Select Month",
                                                                    "e");
                                                              } else if (yearController
                                                                  .text
                                                                  .isEmpty) {
                                                                AppUtil.showToast(
                                                                    "Please Enter Year",
                                                                    "e");
                                                              } else if (workingDaysController
                                                                  .text
                                                                  .isEmpty) {
                                                                AppUtil.showToast(
                                                                    "Please Enter Working Days",
                                                                    "e");
                                                              } else if (holidaysController
                                                                  .text
                                                                  .isEmpty) {
                                                                AppUtil.showToast(
                                                                    "Please Enter Holidays",
                                                                    "e");
                                                              } else {
                                                                var month =
                                                                    dropdownvalueService;
                                                                var year =
                                                                    yearController
                                                                        .text;
                                                                var workDays =
                                                                    workingDaysController
                                                                        .text;

                                                                var holiday =
                                                                    holidaysController
                                                                        .text;

                                                                var category =
                                                                    dropdownvalueService1;

                                                                Navigator
                                                                    .pushNamed(
                                                                  context,
                                                                  '/paySalary',
                                                                  arguments: {
                                                                    'month':
                                                                        month,
                                                                    'year':
                                                                        year,
                                                                    'workDays':
                                                                        workDays,
                                                                    'holiday':
                                                                        holiday,
                                                                    'category':
                                                                        category,
                                                                  },
                                                                );

                                                                setState(() {});
                                                              }
                                                            }),
                                                      ),
                                                    ],
                                                  ),
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
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.pressed)) {
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
