import 'dart:io';

import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gims/model/Request/blockStuRequest.dart';
import 'package:gims/model/Request/deleteStudentRequest.dart';
import 'package:gims/model/Request/simpleRequest.dart';
import 'package:gims/model/Response/sessionResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gims/api/appCommonVariable.dart';
import 'package:gims/api/webService.dart';
import 'package:gims/controllers/AppUtil.dart';
import 'package:gims/model/Request/studentRequest.dart';
import 'package:gims/model/Response/SimpleResponse.dart';
import 'package:gims/model/Response/studentResponse.dart';
import 'package:gims/responsive.dart';
import 'package:gims/view/home/sidebar.dart';
import 'package:url_launcher/url_launcher.dart';

class ManageStudent extends StatefulWidget {
  const ManageStudent({super.key});

  @override
  State<ManageStudent> createState() => _ManageStudentState();
}

class _ManageStudentState extends State<ManageStudent> {
  int crocesscount = 0;
  double childAspect = 0.00;
  bool babkbutton = false;
  bool isLoading = false;
  TextEditingController controllerSearch = TextEditingController();
  List studentList = [];

  List studentFiltered = [];
  String _searchResult = '';
  bool searching = false;
  TextEditingController _searchController = TextEditingController();
  final Webservice _service = Webservice();
  ManageStudentRequest simpleRequest = ManageStudentRequest("", "");
  StudentResponse studentResponse = StudentResponse();
  DeleteStudentRequest deleteRequest = DeleteStudentRequest("", "", "");
  BlockStudentRequest blockStudentRequest = BlockStudentRequest("", "", "");
  SimpleResponse simpleResponse = SimpleResponse();
  SessionResponse sessionResponse = SessionResponse();
  SimpleModel sessionRequest = SimpleModel("");
  String permissions = '';
  List<String> items = ['Select Year'];
  String? dropdownvalueService;
  List sessionList = [];
  String sessionId = '';
  String argumentYear = '';
  @override
  void initState() {
    super.initState();

    isLoading = true;

    SharedPreferences.getInstance().then((SharedPreferences sp) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        initializeDepartmentData(context);
      });
      permissions = sp.getString(PERMISSIONS)!;

      sessionRequest.type = 'view';
      _service.sessionGroup(sessionRequest).then((value) {
        sessionResponse = value;

        if (value.error == false) {
          setState(() {
            sessionList = sessionResponse.data!;
            sessionList.forEach((session) {
              items.add(session.from);
            });
            simpleRequest.type = 'view';
            if (argumentYear.isNotEmpty) {
              dropdownvalueService = argumentYear;
            } else {
              dropdownvalueService = items.last;
            }

            simpleRequest.year = dropdownvalueService.toString();

            _service.manageStudent(simpleRequest).then((value) {
              studentResponse = value;

              if (value.error == false) {
                setState(() {
                  studentList = studentResponse.data!;
                  studentFiltered = studentList;
                  isLoading = false;
                });
              } else {
                setState(() {
                  isLoading = false;
                });
              }
            });
          });
        } else {}
      });
    });
  }

  void initializeDepartmentData(BuildContext context) {
    setState(() {
      isLoading = true;
    });
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    if (arguments['year'] != null) {
      setState(() {
        isLoading = false;
        argumentYear = arguments['year'].toString();
        dropdownvalueService = arguments['year'].toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Responsive.isDesktop(context)) {
      crocesscount = 3;
      childAspect = 10 / 0.8;
      babkbutton = false;
    } else if (Responsive.isTablet(context)) {
      crocesscount = 2;
      childAspect = 10 / 0.9;
      babkbutton = true;
    } else {
      crocesscount = 1;
      childAspect = 13 / 1.3;
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
    } else if (permissions.contains('manage_student')) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            actions: [
              if (permissions.contains('add_student'))
                IconButton(
                  onPressed: (() {
                    Navigator.pushReplacementNamed(context, '/AddStudent');
                  }),
                  tooltip: "Add Student",
                  icon: const Icon(
                    Icons.add_box_rounded,
                    color: Colors.white,
                  ),
                ),
              if (searching == false)
                IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                      semanticLabel: 'Search Student',
                    ),
                    onPressed: () {
                      setState(() {
                        searching = true;
                      });
                    }),
              IconButton(
                onPressed: (() {
                  showMyDialog2();
                }),
                tooltip: "Filter",
                icon: const Icon(
                  Icons.sort,
                  color: Colors.white,
                ),
              ),
            ],
            automaticallyImplyLeading: babkbutton,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                }),
            title: searching
                ? Container(
                    // Add padding around the search bar
                    padding: const EdgeInsets.symmetric(horizontal: 1.0),
                    // Use a Material design search bar
                    child: TextField(
                        style:
                            const TextStyle(color: Colors.white, fontSize: 21),
                        cursorColor: Colors.white,
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search Student',
                          hintStyle: const TextStyle(color: Colors.white),

                          // Add a clear button to the search bar
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _searchController =
                                    TextEditingController(text: '');
                                searching = false;
                                studentList = studentResponse.data!;
                                studentFiltered = studentList;
                              });
                            },
                          ),

                          // border: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(20.0),
                          // ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchResult = value;

                            studentFiltered = studentList
                                .where((studentList) =>
                                    studentList.name.toLowerCase().contains(_searchResult.toLowerCase()) ||
                                    studentList.fatherName.toLowerCase().contains(
                                        _searchResult.toLowerCase()) ||
                                    studentList.motherName.toLowerCase().contains(
                                        _searchResult.toLowerCase()) ||
                                    studentList.whatsappNo.toLowerCase().contains(
                                        _searchResult.toLowerCase()) ||
                                    studentList.whatsappNo.toLowerCase().contains(
                                        _searchResult.toLowerCase()) ||
                                    studentList.aadharNo.toLowerCase().contains(
                                        _searchResult.toLowerCase()) ||
                                    studentList.admissionDate
                                        .toLowerCase()
                                        .contains(
                                            _searchResult.toLowerCase()) ||
                                    studentList.dob.toLowerCase().contains(
                                        _searchResult.toLowerCase()) ||
                                    studentList.degName.toLowerCase().contains(
                                        _searchResult.toLowerCase()) ||
                                    studentList.courseName
                                        .toLowerCase()
                                        .contains(_searchResult.toLowerCase()) ||
                                    studentList.subCourseName.toLowerCase().contains(_searchResult.toLowerCase()) ||
                                    studentList.sessionName.toLowerCase().contains(_searchResult.toLowerCase()))
                                .toList();
                          });
                        }),
                  )
                : Responsive.isDesktop(context)
                    ? const Text(
                        'Manage Student',
                        style: TextStyle(color: Colors.white),
                      )
                    : const Text(
                        'Manage Student',
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
                    child: SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: isLoading
                            ? SizedBox(
                                width: double.infinity,
                                height: double.infinity,
                                child: SpinKitCircle(
                                  color: Theme.of(context).primaryColor,
                                  size: 70.0,
                                  duration: const Duration(milliseconds: 1200),
                                ))
                            : studentFiltered.isNotEmpty
                                ? Container(
                                    padding: const EdgeInsets.all(5.0),
                                    child: DynamicHeightGridView(
                                      itemCount: studentFiltered.length,
                                      builder: (ctx, index) {
                                        return Card(
                                            elevation: 5,
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 250, 250, 250),
                                                width: 0.1, //<-- SEE HERE
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(11.0),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(children: [
                                                /*1st*/
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text("Name",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                          Text(
                                                              studentFiltered[
                                                                      index]
                                                                  .name!,
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  height: 1.5,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500))
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text(
                                                              "Father's Name",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                          Text(
                                                              studentFiltered[
                                                                      index]
                                                                  .fatherName!,
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  height: 1.5,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500))
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text(
                                                              "Mobile Number",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                          Text(
                                                              studentFiltered[
                                                                      index]
                                                                  .whatsappNo!,
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  height: 1.5,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500))
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text(
                                                              "Aadhar Number",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                          Text(
                                                              studentFiltered[
                                                                      index]
                                                                  .aadharNo!,
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  height: 1.5,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500))
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text(
                                                              "Admission Date",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                          Text(
                                                              studentFiltered[
                                                                      index]
                                                                  .admissionDate!,
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  height: 1.5,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500))
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text("Session",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                          Text(
                                                              studentFiltered[
                                                                      index]
                                                                  .sessionName!,
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  height: 1.5,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500))
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text("Degree",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                          Text(
                                                              studentFiltered[
                                                                      index]
                                                                  .degName!,
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  height: 1.5,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500))
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text("Course",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                          Text(
                                                              studentFiltered[
                                                                      index]
                                                                  .courseName!,
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  height: 1.5,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500))
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text("Year",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                          Text(
                                                              studentFiltered[
                                                                      index]
                                                                  .subCourseName!,
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  height: 1.5,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500))
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text("D.O.B",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                          Text(
                                                              studentFiltered[
                                                                      index]
                                                                  .dob!,
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  height: 1.5,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500))
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                const Divider(
                                                  height: 3,
                                                ),

                                                /*3rd*/
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          if (permissions
                                                              .contains(
                                                                  'view_student'))
                                                            IconButton(
                                                              tooltip: "View " +
                                                                  studentFiltered[
                                                                          index]
                                                                      .name
                                                                      .toString(),
                                                              icon: const Icon(
                                                                Icons
                                                                    .account_circle,
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                              onPressed: () {
                                                                Navigator
                                                                    .pushNamed(
                                                                  context,
                                                                  '/ProfileView',
                                                                  arguments: {
                                                                    'data':
                                                                        studentFiltered[
                                                                            index],
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                          if (permissions.contains(
                                                              'block_student'))
                                                            IconButton(
                                                              tooltip: "Block " +
                                                                  studentFiltered[
                                                                          index]
                                                                      .name
                                                                      .toString(),
                                                              icon: const Icon(
                                                                Icons.block,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                              onPressed: () {
                                                                showMyDialog(
                                                                    "Block?",
                                                                    "Alert! Are you sure you want to block the." +
                                                                        studentFiltered[index]
                                                                            .name
                                                                            .toString(),
                                                                    "Yes",
                                                                    "No",
                                                                    true,
                                                                    studentFiltered[
                                                                            index]
                                                                        .id,
                                                                    studentFiltered[
                                                                            index]
                                                                        .sessionName);
                                                              },
                                                            ),
                                                          if (permissions.contains(
                                                              'whatsapp_student'))
                                                            const SizedBox(
                                                              width: 8,
                                                            ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              launchWhatsApp(
                                                                  studentFiltered[
                                                                          index]
                                                                      .whatsappNo,
                                                                  "Hello");
                                                            },
                                                            child: const Image(
                                                              image: AssetImage(
                                                                  "assets/icons/whatsapp.png"),
                                                              width: 22,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          if (permissions
                                                              .contains(
                                                                  'edit_student'))
                                                            IconButton(
                                                              tooltip: "Edit " +
                                                                  studentFiltered[
                                                                          index]
                                                                      .name
                                                                      .toString(),
                                                              icon: const Icon(
                                                                Icons.edit,
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                              onPressed: () {
                                                                Navigator
                                                                    .pushNamed(
                                                                  context,
                                                                  '/EditStudent',
                                                                  arguments: {
                                                                    'data':
                                                                        studentFiltered[
                                                                            index],
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                          if (permissions.contains(
                                                              'delete_student'))
                                                            IconButton(
                                                              tooltip: "Delete " +
                                                                  studentFiltered[
                                                                          index]
                                                                      .name
                                                                      .toString(),
                                                              icon: const Icon(
                                                                Icons.delete,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                              onPressed: () {
                                                                showMyDialog(
                                                                    "Delete?",
                                                                    "Alert! Are you sure you want to delete the." +
                                                                        studentFiltered[index]
                                                                            .name
                                                                            .toString(),
                                                                    "Yes",
                                                                    "No",
                                                                    true,
                                                                    studentFiltered[
                                                                            index]
                                                                        .id,
                                                                    studentFiltered[
                                                                            index]
                                                                        .sessionName);
                                                              },
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                /*actions*/
                                              ]),
                                            ));
                                      },
                                      crossAxisCount: crocesscount,
                                    ))
                                : Column(
                                    children: [
                                      const SizedBox(
                                        height: 40,
                                      ),
                                      Column(
                                        children: [
                                          Image(
                                            image: AssetImage(
                                                "assets/images/no-data.png"),
                                            width: 150,
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            "No data found",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
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

  void showMyDialog(String title, String content, String btnPositive,
      String btnNegative, bool cancelable, String id, String session) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: cancelable,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 400),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                width: 350,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /*title*/
                      Visibility(
                        visible: title.isEmpty ? false : true,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          child: Text(title,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontSize: 20.0, height: 1.5)),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      /*content*/
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        child: Text(content,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontSize: 14.0, height: 1.5)),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      /*actions*/
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                                if (title == 'Block?') {
                                  callApiToBlockStudent(id, session);
                                } else {
                                  callApiToDeleteOrganisation(id, session);
                                }
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.green,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(btnPositive,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              fontSize: 14.0,
                                              height: 1.5,
                                              color: Colors.white)),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(btnNegative,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              fontSize: 14.0,
                                              height: 1.5,
                                              color: Colors.white)),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
              .animate(anim),
          child: child,
        );
      },
    );
  }

  void showMyDialog2() {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 400),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Material(
              // Wrap the container with Material
              color: Colors.transparent,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                width: 350,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      DropdownButtonFormField(
                        isExpanded: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0),
                          labelText: "Year",
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade500),
                          ),
                        ),
                        value: dropdownvalueService != null &&
                                items.contains(dropdownvalueService)
                            ? dropdownvalueService
                            : (items.isNotEmpty ? items[0] : null),
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: items.map((String item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalueService = newValue!;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      /*content*/
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isLoading = true;
                                  studentList.clear();
                                  studentFiltered.clear();
                                  simpleRequest.year =
                                      dropdownvalueService.toString();
                                  simpleRequest.type = 'view';

                                  _service
                                      .manageStudent(simpleRequest)
                                      .then((value) {
                                    studentResponse = value;

                                    if (value.error == false) {
                                      studentList = studentResponse.data!;
                                      studentFiltered = studentList;
                                      isLoading = false;
                                      Navigator.pop(context);
                                    } else {
                                      isLoading = false;
                                      Navigator.pop(context);
                                    }
                                  });
                                });
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.green,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Submit",
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              fontSize: 14.0,
                                              height: 1.5,
                                              color: Colors.white)),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
              .animate(anim),
          child: child,
        );
      },
    );
  }

  callApiToDeleteOrganisation(String id, String session) {
    setState(() {
      isLoading = true;
    });
    deleteRequest.id = id;
    deleteRequest.type = 'delete';
    deleteRequest.session = session;

    _service.deleteStudent(deleteRequest).then((value) {
      simpleResponse = value;

      setState(() {
        if (simpleResponse.error == false) {
          isLoading = false;
          AppUtil.showToast(simpleResponse.msg.toString(), "e");
          Navigator.pushNamed(
            context,
            '/ManageStudent',
          );
        } else {
          AppUtil.showToast("Internal Server Error", "e");
        }
      });
    });
  }

  callApiToBlockStudent(String id, String session) {
    setState(() {
      isLoading = true;
    });
    var exp = session.split('-');
    var newYear = exp[0].trim();

    blockStudentRequest.id = id;
    blockStudentRequest.type = 'block';
    blockStudentRequest.session = newYear;

    _service.blockStudent(blockStudentRequest).then((value) {
      simpleResponse = value;

      setState(() {
        if (simpleResponse.error == false) {
          isLoading = false;
          AppUtil.showToast(simpleResponse.msg.toString(), "e");
          Navigator.pushNamed(
            context,
            '/ManageStudent',
            arguments: {
              'year': newYear,
            },
          );
        } else {
          isLoading = false;
          AppUtil.showToast("Internal Server Error", "e");
        }
      });
    });
  }

  launchWhatsApp(String phone, String msg) async {
    String mob = '';

    if (phone.contains('+')) {
      mob = phone;
    } else {
      mob = '+91' + phone;
    }

    mob = mob.replaceAll('+', '').trim();

    Uri sendUrl;

    if (Platform.isIOS) {
      sendUrl =
          Uri.parse("https://wa.me/$mob?text=${Uri.encodeComponent(msg)}");
    } else {
      sendUrl = Uri.parse(
          "whatsapp://send?phone=$mob&text=${Uri.encodeComponent(msg)}");
    }

    await canLaunchUrl(sendUrl)
        ? launchUrl(sendUrl)
        : AppUtil.showToast('WhatsApp not Installed', 'i');
  }
}
