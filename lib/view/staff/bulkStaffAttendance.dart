import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gims/controllers/appUtil.dart';
import 'package:gims/model/Request/addStaffAttendanceRequest.dart';
import 'package:gims/model/Request/staffFilterRequest.dart';
import 'package:gims/model/Response/SimpleResponse.dart';
import 'package:gims/model/Response/degreeResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gims/Api/AppCommonVariable.dart';
import 'package:gims/api/webService.dart';
import 'package:gims/responsive.dart';
import 'package:gims/view/home/sidebar.dart';

class BulkStaffAttendance extends StatefulWidget {
  const BulkStaffAttendance({super.key});

  @override
  State<BulkStaffAttendance> createState() => _BulkStaffAttendanceState();
}

class _BulkStaffAttendanceState extends State<BulkStaffAttendance> {
  int crocesscount = 0;
  double childAspect = 0.00;
  bool babkbutton = false;
  String permissions = '';
  TextEditingController yearController = TextEditingController();
  TextEditingController workingDaysController = TextEditingController();
  TextEditingController holidaysController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final Webservice _service = Webservice();

  bool isLoading = false;
  List additionList = [];
  List additionFiltered = [];
  List deductionList = [];
  List deductionFiltered = [];
  String additionResult = "";
  String deductionResult = "";

  List<String> items = [
    'Select Month',
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12'
  ];

  List<String> items2 = [
    'Select Day',
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
    '31',
  ];
  String? dropdownvalueService = 'Select Month';
  String? dropdownvalueService2 = 'Select Day';
  String editId = '';
  String day = '';
  String month = '';
  String year = '';
  String workDays = '';
  String holiday = '';
  String category = '';
  Map<String, TextEditingController> additionControllers = {};
  Map<String, TextEditingController> deductionControllers = {};
  StaffFilterRequest staffFilterRequest = StaffFilterRequest("", "");
  AddStaffAttendanceRequest addStaffAttendanceRequest =
      AddStaffAttendanceRequest("", "", "", "", "", "");
  DegreeResponse staffResponse = DegreeResponse();
  SimpleResponse simpleResponse = SimpleResponse();
  final List<Map<String, dynamic>> employees = [];
  Map<int, String> attendanceStatus = {};
  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((SharedPreferences sp) {
      setState(() {
        isLoading = true;
      });
      permissions = sp.getString(PERMISSIONS)!;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        initializeDepartmentData(context);
      });
    });
  }

  void initializeDepartmentData(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;

    if (arguments['day'] != null) {
      day = arguments['day'];
      month = arguments['month'];
      year = arguments['year'];
      category = arguments['category'];

      dropdownvalueService2 = day;
      dropdownvalueService = month;
      yearController.text = year;

      fetchEmployees();
    } else {
      Navigator.pushReplacementNamed(context, '/staffAttendance');
    }
  }

  void fetchEmployees() {
    staffFilterRequest.type = 'view';
    staffFilterRequest.cat = category;
    _service.filterStaff(staffFilterRequest).then((value) {
      staffResponse = value;

      if (staffResponse.error == false) {
        employees.clear();

        for (var staff in staffResponse.data!) {
          employees.add({
            'name': staff.name,
            'id': int.tryParse(staff.id ?? '0') ?? 0,
          });
        }

        for (var employee in employees) {
          attendanceStatus[employee['id']] = 'Present';
        }

        setState(() {
          isLoading = false;
        });
      }
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
      return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SpinKitCircle(
            color: Theme.of(context).primaryColor,
            size: 70.0,
            duration: const Duration(milliseconds: 1200),
          ));
    } else if (permissions.contains('add_structure')) {
      return SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            automaticallyImplyLeading: babkbutton,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                }),
            title: Responsive.isDesktop(context)
                ? const Text(
                    'Mark Attendance',
                    style: TextStyle(color: Colors.white),
                  )
                : const Text(
                    'Mark Attendance',
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
                    child: isLoading
                        ? SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: SpinKitCircle(
                              color: Theme.of(context).primaryColor,
                              size: 70.0,
                              duration: const Duration(milliseconds: 1200),
                            ))
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              child: SizedBox(
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: permissions.contains('add_structure')
                                        ? Column(
                                            mainAxisSize: MainAxisSize
                                                .min, // Set mainAxisSize to MainAxisSize.min
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Text(
                                                "(Enter Date Only if You want To Make a Back Date Entry By Default It Will Take System Date if You Do Not Select Any Date)",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey[700]),
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 10),
                                                      child:
                                                          DropdownButtonFormField(
                                                        isExpanded: true,
                                                        decoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          0),
                                                          labelText:
                                                              "Select Day",
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
                                                                    .grey
                                                                    .shade500),
                                                          ),
                                                        ),
                                                        value:
                                                            dropdownvalueService2 ??
                                                                items2[0],
                                                        icon: const Icon(Icons
                                                            .keyboard_arrow_down),
                                                        items: items2.map(
                                                          (String items) {
                                                            return DropdownMenuItem(
                                                              value: items,
                                                              child:
                                                                  Text(items),
                                                            );
                                                          },
                                                        ).toList(),
                                                        onChanged:
                                                            (String? newValue) {
                                                          setState(
                                                            () {
                                                              dropdownvalueService2 =
                                                                  newValue!;
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 10),
                                                      child:
                                                          DropdownButtonFormField(
                                                        isExpanded: true,
                                                        decoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          0),
                                                          labelText:
                                                              "Select Month",
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
                                                                    .grey
                                                                    .shade500),
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
                                                              child:
                                                                  Text(items),
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
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: TextFormField(
                                                      controller:
                                                          yearController,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          const InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 6,
                                                                vertical: 5),
                                                        border:
                                                            OutlineInputBorder(),
                                                        labelText: ' Year',
                                                        hintText: 'Enter Year',
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 20),
                                              // Wrapping the DataTable in a Scrollable container if there are many rows
                                              SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                      maxWidth:
                                                          double.infinity),
                                                  child: DataTable(
                                                    columns: [
                                                      DataColumn(
                                                          label: Text(
                                                              'Employee Name')),
                                                      DataColumn(
                                                          label: Text(
                                                              'Attendance')),
                                                    ],
                                                    rows: employees
                                                        .map((employee) {
                                                      return DataRow(
                                                        cells: [
                                                          DataCell(Text(
                                                              '${employee['name']} (${employee['id']})')),
                                                          DataCell(
                                                            AttendanceOptions(
                                                              employeeId:
                                                                  employee[
                                                                      'id'],
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  attendanceStatus[
                                                                          employee[
                                                                              'id']] =
                                                                      value!;
                                                                });
                                                              },
                                                              selectedOption:
                                                                  attendanceStatus[
                                                                      employee[
                                                                          'id']],
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              // No Expanded or Flexible needed here; Button will take only necessary space
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
                                                      addStaffAttendanceRequest
                                                          .type = 'add';
                                                      addStaffAttendanceRequest
                                                              .day =
                                                          dropdownvalueService2
                                                              .toString();
                                                      addStaffAttendanceRequest
                                                              .month =
                                                          dropdownvalueService
                                                              .toString();
                                                      addStaffAttendanceRequest
                                                              .year =
                                                          yearController.text
                                                              .trim();
                                                      addStaffAttendanceRequest
                                                              .year =
                                                          yearController.text
                                                              .trim();
                                                      addStaffAttendanceRequest
                                                              .status =
                                                          employees
                                                              .map((employee) {
                                                        // Here, we're assuming that the attendanceStatus map exists and is populated
                                                        return attendanceStatus[
                                                            employee['id']];
                                                      }).join(',');
                                                      addStaffAttendanceRequest
                                                              .empId =
                                                          employees
                                                              .map((employee) =>
                                                                  employee['id']
                                                                      .toString())
                                                              .join(',');
                                                      ;
                                                      _service
                                                          .bulkStaffAttendance(
                                                              addStaffAttendanceRequest)
                                                          .then((value) {
                                                        simpleResponse = value;

                                                        if (simpleResponse
                                                                .error ==
                                                            false) {
                                                          AppUtil.showToast(
                                                              simpleResponse
                                                                  .msg!,
                                                              's');
                                                          Navigator
                                                              .pushReplacementNamed(
                                                                  context,
                                                                  '/staffAttendance');
                                                        }
                                                      });
                                                    }),
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

class DateDropdown extends StatelessWidget {
  final String label;
  final int max;

  DateDropdown({required this.label, required this.max});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      items: List.generate(max, (index) => index + 1)
          .map((e) => DropdownMenuItem(value: e, child: Text(e.toString())))
          .toList(),
      onChanged: (value) {
        // Handle date change
      },
    );
  }
}

class AttendanceOptions extends StatelessWidget {
  final int employeeId;
  final String? selectedOption;
  final ValueChanged<String?> onChanged;

  AttendanceOptions({
    required this.employeeId,
    required this.selectedOption,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (String option in [
          'Present',
          'Absent',
          'Holiday',
          'Half day',
          'Paid Leaves'
        ])
          Expanded(
            child: RadioListTile<String?>(
              title: Text(option, style: TextStyle(fontSize: 12)),
              value: option,
              groupValue: selectedOption,
              onChanged: onChanged,
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
      ],
    );
  }
}
