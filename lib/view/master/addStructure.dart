import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gims/model/Request/addStructureRequest.dart';
import 'package:gims/model/Request/yearRequest.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gims/Api/AppCommonVariable.dart';
import 'package:gims/api/webService.dart';
import 'package:gims/controllers/AppUtil.dart';
import 'package:gims/model/Request/sessionRequest.dart';
import 'package:gims/model/Request/simpleRequest.dart';
import 'package:gims/model/Response/SimpleResponse.dart';
import 'package:gims/model/Response/courseResponse.dart';
import 'package:gims/model/Response/degreeResponse.dart';
import 'package:gims/model/Response/sessionResponse.dart';
import 'package:gims/model/Response/yearResponse.dart';
import 'package:gims/responsive.dart';
import 'package:gims/view/home/sidebar.dart';

class AddStructure extends StatefulWidget {
  const AddStructure({super.key});

  @override
  State<AddStructure> createState() => _AddStructureState();
}

class _AddStructureState extends State<AddStructure> {
  int crocesscount = 0;
  double childAspect = 0.00;
  bool babkbutton = false;
  String permissions = '';
  TextEditingController nameController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> items = ['Select Session'];
  String? dropdownvalueService;
  List sessionList = [];
  String sessionId = '';

  List<String> items2 = ['Select Course'];
  String? dropdownvalueService2;
  List courseList = [];
  String courseId = '';
  String courseYear = '';

  List<String> items3 = ['Select Year'];
  String? dropdownvalueService3;
  List yearList = [];
  String yearId = '';

  List<String> items4 = ['Select Fee'];
  String? dropdownvalueService4;
  List feeList = [];
  String feesId = '';

  final AddStructureRequest addStructureRequest =
      AddStructureRequest("", "", "", "", "");
  SimpleResponse addResponse = SimpleResponse();
  SimpleModel degreeRequest = SimpleModel("");
  YearRequest yearRequest = YearRequest("", "");
  SessionRequest sessionRequest = SessionRequest("", "");
  CourseResponse courseResponse = CourseResponse();
  YearResponse yearResponse = YearResponse();
  SessionResponse sessionResponse = SessionResponse();
  DegreeResponse feeResponse = DegreeResponse();
  final Webservice _service = Webservice();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    isLoading = true;
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      setState(() {
        permissions = sp.getString(PERMISSIONS)!;
      });
    });
    degreeRequest.type = 'view';
    _service.courseManage(degreeRequest).then((value) {
      courseResponse = value;
      if (courseResponse.error == false) {
        courseList = courseResponse.data!;
        List.generate(courseList.length, (index) {
          items2.add(courseList[index].name);
        });

        setState(() {});
      }
    });
    degreeRequest.type = 'view';
    _service.manageFeeName(degreeRequest).then((value) {
      feeResponse = value;
      if (feeResponse.error == false) {
        feeList = feeResponse.data!;
        List.generate(feeList.length, (index) {
          items4.add(feeList[index].name);
        });
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
      // Permissions not fetched yet, return a loading indicator or empty container
      return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SpinKitCircle(
            color: Theme.of(context).primaryColor,
            size: 70.0,
            duration: const Duration(milliseconds: 1200),
          ));
    } else if (permissions.contains('add_fee_structure')) {
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
                            context, '/FeeStructure');
                      }),
                  title: Responsive.isDesktop(context)
                      ? const Text(
                          'Add Fee Structure',
                          style: TextStyle(color: Colors.white),
                        )
                      : const Text(
                          'Add Fee Structure',
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
                                    child: permissions
                                            .contains('add_fee_structure')
                                        ? Column(
                                            children: [
                                              GridView.count(
                                                crossAxisCount: crocesscount,
                                                childAspectRatio: childAspect,
                                                shrinkWrap: true,
                                                mainAxisSpacing: 20,
                                                crossAxisSpacing: 15,
                                                children: [
                                                  DropdownButtonFormField(
                                                    isExpanded: true,
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 10,
                                                              vertical: 0),
                                                      labelText: "Course",
                                                      focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor),
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          6))),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .grey.shade500),
                                                      ),
                                                    ),
                                                    // Ensure the selected value exists in the list or set a fallback if null
                                                    value: dropdownvalueService2 !=
                                                                null &&
                                                            items2.contains(
                                                                dropdownvalueService2)
                                                        ? dropdownvalueService2
                                                        : (items2.isNotEmpty
                                                            ? items2[0]
                                                            : null),
                                                    icon: const Icon(Icons
                                                        .keyboard_arrow_down),
                                                    items: items2
                                                        .map((String item) {
                                                      return DropdownMenuItem(
                                                        value: item,
                                                        child: Text(item),
                                                      );
                                                    }).toList(),
                                                    onChanged:
                                                        (String? newValue) {
                                                      setState(() {
                                                        isLoading = true;
                                                        courseYear = '';
                                                        dropdownvalueService2 =
                                                            newValue!;

                                                        courseId = courseList[
                                                                items2.indexOf(
                                                                        newValue) -
                                                                    1]
                                                            .id
                                                            .toString();
                                                        courseYear = courseList[
                                                                items2.indexOf(
                                                                        newValue) -
                                                                    1]
                                                            .year
                                                            .toString();

                                                        yearRequest.type =
                                                            'view';
                                                        yearRequest.course =
                                                            courseId;
                                                        _service
                                                            .yearFilter(
                                                                yearRequest)
                                                            .then((value) {
                                                          yearResponse = value;
                                                          if (yearResponse
                                                                  .error ==
                                                              false) {
                                                            yearList =
                                                                yearResponse
                                                                    .data!;
                                                            items3.clear();

                                                            items3.add(
                                                                'Select Year');
                                                            dropdownvalueService3 =
                                                                items3[
                                                                    0]; // Reset dropdown
                                                            yearList.forEach(
                                                                (year) {
                                                              items3.add(year
                                                                  .subCourse);
                                                            });
                                                          } else {
                                                            items3.clear();

                                                            items3.add(
                                                                'Select Year');
                                                            dropdownvalueService3 =
                                                                items3[
                                                                    0]; // Reset dropdown
                                                          }
                                                        });

                                                        sessionRequest.type =
                                                            'view';
                                                        sessionRequest.year =
                                                            courseYear;
                                                        _service
                                                            .sessionFilter(
                                                                sessionRequest)
                                                            .then((value) {
                                                          sessionResponse =
                                                              value;
                                                          if (sessionResponse
                                                                  .error ==
                                                              false) {
                                                            sessionList =
                                                                sessionResponse
                                                                    .data!;
                                                            items.clear();

                                                            items.add(
                                                                'Select Session');
                                                            dropdownvalueService =
                                                                items[
                                                                    0]; // Reset dropdown
                                                            sessionList.forEach(
                                                                (session) {
                                                              items.add(session
                                                                  .session);
                                                            });
                                                            setState(() {
                                                              isLoading = false;
                                                            });
                                                          } else {
                                                            setState(() {
                                                              items.clear();

                                                              items.add(
                                                                  'Select Session');
                                                              dropdownvalueService =
                                                                  items[
                                                                      0]; // Reset dropdown
                                                              isLoading = false;
                                                            });
                                                          }
                                                        });
                                                      });
                                                    },
                                                  ),
                                                  DropdownButtonFormField(
                                                    isExpanded: true,
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 10,
                                                              vertical: 0),
                                                      labelText: "Year",
                                                      focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor),
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          6))),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .grey.shade500),
                                                      ),
                                                    ),
                                                    value: dropdownvalueService3 !=
                                                                null &&
                                                            items3.contains(
                                                                dropdownvalueService3)
                                                        ? dropdownvalueService3
                                                        : (items3.isNotEmpty
                                                            ? items3[0]
                                                            : null),
                                                    icon: const Icon(Icons
                                                        .keyboard_arrow_down),
                                                    items: items3
                                                        .map((String item) {
                                                      return DropdownMenuItem(
                                                        value: item,
                                                        child: Text(item),
                                                      );
                                                    }).toList(),
                                                    onChanged:
                                                        (String? newValue) {
                                                      setState(() {
                                                        dropdownvalueService3 =
                                                            newValue!;
                                                        yearId = yearList[
                                                                items3.indexOf(
                                                                        newValue) -
                                                                    1]
                                                            .id
                                                            .toString();
                                                      });
                                                    },
                                                  ),
                                                  DropdownButtonFormField(
                                                    isExpanded: true,
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 10,
                                                              vertical: 0),
                                                      labelText: "Session",
                                                      focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor),
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          6))),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .grey.shade500),
                                                      ),
                                                    ),
                                                    value: dropdownvalueService !=
                                                                null &&
                                                            items.contains(
                                                                dropdownvalueService)
                                                        ? dropdownvalueService
                                                        : (items.isNotEmpty
                                                            ? items[0]
                                                            : null),
                                                    icon: const Icon(Icons
                                                        .keyboard_arrow_down),
                                                    items: items
                                                        .map((String item) {
                                                      return DropdownMenuItem(
                                                        value: item,
                                                        child: Text(item),
                                                      );
                                                    }).toList(),
                                                    onChanged:
                                                        (String? newValue) {
                                                      setState(() {
                                                        dropdownvalueService =
                                                            newValue!;
                                                        sessionId = sessionList[
                                                                items.indexOf(
                                                                        newValue) -
                                                                    1]
                                                            .id
                                                            .toString();
                                                      });
                                                    },
                                                  ),
                                                  DropdownButtonFormField(
                                                    isExpanded: true,
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 10,
                                                              vertical: 0),
                                                      labelText: "Fee",
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
                                                        dropdownvalueService4 ??
                                                            items4[0],
                                                    icon: const Icon(Icons
                                                        .keyboard_arrow_down),
                                                    items: items4.map(
                                                      (String items4) {
                                                        return DropdownMenuItem(
                                                          value: items4,
                                                          child: Text(items4),
                                                        );
                                                      },
                                                    ).toList(),
                                                    onChanged:
                                                        (String? newValue) {
                                                      setState(
                                                        () {
                                                          dropdownvalueService4 =
                                                              newValue!;
                                                          feesId = feeList[
                                                                  items4.indexOf(
                                                                          newValue) -
                                                                      1]
                                                              .id
                                                              .toString();
                                                        },
                                                      );
                                                    },
                                                  ),
                                                  TextFormField(
                                                    controller: nameController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText: ' Amount',
                                                      hintText: 'Enter Amount*',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 25,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
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
                                                            padding:
                                                                EdgeInsets.only(
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
                                                            if (dropdownvalueService2 ==
                                                                'Select Course') {
                                                              AppUtil.showToast(
                                                                  "Please Select Course",
                                                                  "e");
                                                            } else if (dropdownvalueService3 ==
                                                                'Select Year') {
                                                              AppUtil.showToast(
                                                                  "Please Select Year",
                                                                  "e");
                                                            } else if (dropdownvalueService ==
                                                                'Select Session') {
                                                              AppUtil.showToast(
                                                                  "Please Select Session",
                                                                  "e");
                                                            } else if (dropdownvalueService4 ==
                                                                'Select Fee') {
                                                              AppUtil.showToast(
                                                                  "Please Select Fee",
                                                                  "e");
                                                            } else if (nameController
                                                                .text.isEmpty) {
                                                              AppUtil.showToast(
                                                                  "Please Enter Amount",
                                                                  "e");
                                                            } else {
                                                              addStructureRequest
                                                                      .course =
                                                                  courseId
                                                                      .toString();

                                                              addStructureRequest
                                                                      .subCourse =
                                                                  yearId
                                                                      .toString();

                                                              addStructureRequest
                                                                      .session =
                                                                  sessionId
                                                                      .toString();

                                                              addStructureRequest
                                                                      .feeId =
                                                                  feesId
                                                                      .toString();

                                                              addStructureRequest
                                                                      .amount =
                                                                  nameController
                                                                      .text
                                                                      .trim();

                                                              Webservice
                                                                  _service =
                                                                  Webservice();
                                                              _service
                                                                  .addStructure(
                                                                      addStructureRequest)
                                                                  .then(
                                                                      (value) async {
                                                                addResponse =
                                                                    value;

                                                                if (addResponse
                                                                        .error ==
                                                                    false) {
                                                                  AppUtil.showToast(
                                                                      addResponse
                                                                          .msg!,
                                                                      "s");

                                                                  Navigator.pushReplacementNamed(
                                                                      context,
                                                                      '/FeeStructure');
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
