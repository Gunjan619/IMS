import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gims/controllers/appUtil.dart';
import 'package:gims/model/Request/addStaffAttendanceRequest.dart';
import 'package:gims/model/Request/editStaffAttendanceRequest.dart';
import 'package:gims/model/Request/filterStaffAttendanceRequest.dart';
import 'package:gims/model/Request/staffFilterRequest.dart';
import 'package:gims/model/Response/SimpleResponse.dart';
import 'package:gims/model/Response/degreeResponse.dart';
import 'package:gims/model/Response/manageStaffAttendanceResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gims/Api/AppCommonVariable.dart';
import 'package:gims/api/webService.dart';
import 'package:gims/responsive.dart';
import 'package:gims/view/home/sidebar.dart';

class EditBulkStaffAttendance extends StatefulWidget {
  const EditBulkStaffAttendance({super.key});

  @override
  State<EditBulkStaffAttendance> createState() =>
      _EditBulkStaffAttendanceState();
}

class _EditBulkStaffAttendanceState extends State<EditBulkStaffAttendance> {
  int crocesscount = 0;
  double childAspect = 0.00;
  bool babkbutton = false;
  String permissions = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final Webservice _service = Webservice();

  bool isLoading = false;
  List additionList = [];
  List additionFiltered = [];
  List deductionList = [];
  List deductionFiltered = [];
  String additionResult = "";
  String deductionResult = "";

  String editId = '';
  String category = '';
  String date = '';
  String status = '';
  StaffFilterRequest staffFilterRequest = StaffFilterRequest("", "");
  EditStaffAttendanceRequest addStaffAttendanceRequest =
      EditStaffAttendanceRequest("", "", "", "", "");
  DegreeResponse staffResponse = DegreeResponse();
  SimpleResponse simpleResponse = SimpleResponse();
  final List<Map<String, dynamic>> employees = [];
  Map<int, String> attendanceStatus = {};
  FilterStaffAttendanceRequest filterStaffAttendanceRequest =
      FilterStaffAttendanceRequest("", "");
  ManageStaffAttendanceResponse manageStaffAttendanceResponse =
      ManageStaffAttendanceResponse();
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

    if (arguments['id'] != null) {
      date = arguments['date'];
      category = arguments['category'];

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

          filterStaffAttendanceRequest.type = 'edit';
          filterStaffAttendanceRequest.date = date;

          _service
              .manageStaffAttendanceFilter(filterStaffAttendanceRequest)
              .then((value) {
            manageStaffAttendanceResponse = value;
            if (manageStaffAttendanceResponse.error == false) {
              for (var data in manageStaffAttendanceResponse.data!) {
                if (data.attend == 'present') {
                  status = 'Present';
                } else if (data.attend == 'absent') {
                  status = 'Absent';
                } else if (data.attend == 'holiday') {
                  status = 'Holiday';
                } else if (data.attend == 'paid_leaves') {
                  status = 'Paid Leaves';
                } else if (data.attend == 'half_day') {
                  status = 'Half day';
                }

                attendanceStatus[int.tryParse(data.empId ?? '0') ?? 0] = status;
              }
            }
            setState(() {
              isLoading = false;
            });
          });
        }
      });

      fetchEmployees();
    } else {
      Navigator.pushReplacementNamed(context, '/staffAttendance');
    }
  }

  void fetchEmployees() {}

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
                    'Edit Attendance',
                    style: TextStyle(color: Colors.white),
                  )
                : const Text(
                    'Edit Attendance',
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
                                              SizedBox(height: 10),

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
                                                          .type = 'edit';

                                                      addStaffAttendanceRequest
                                                          .date = date;
                                                      addStaffAttendanceRequest
                                                          .category = category;

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
                                                          .editStaffAttendance(
                                                              addStaffAttendanceRequest)
                                                          .then((value) {
                                                        simpleResponse = value;

                                                        if (simpleResponse
                                                                .error ==
                                                            false) {
                                                          AppUtil.showToast(
                                                              simpleResponse
                                                                  .msg!,
                                                              'i');
                                                          Navigator
                                                              .pushReplacementNamed(
                                                                  context,
                                                                  '/manageStaffAttend');
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
