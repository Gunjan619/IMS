import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gims/Api/AppCommonVariable.dart';
import 'package:gims/api/webService.dart';
import 'package:gims/controllers/AppUtil.dart';
import 'package:gims/model/Request/addYearRequest.dart';
import 'package:gims/model/Request/simpleRequest.dart';
import 'package:gims/model/Response/SimpleResponse.dart';
import 'package:gims/model/Response/courseResponse.dart';
import 'package:gims/responsive.dart';
import 'package:gims/view/home/sidebar.dart';

class AddYear extends StatefulWidget {
  const AddYear({super.key});

  @override
  State<AddYear> createState() => _AddYearState();
}

class _AddYearState extends State<AddYear> {
  int crocesscount = 0;
  double childAspect = 0.00;
  bool babkbutton = false;
  String permissions = '';
  TextEditingController yearController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> items = ['Select Course'];
  String? dropdownvalueService;
  List courseList = [];
  String courseId = '';
  final AddYearRequest addYearRequest = AddYearRequest("", "");
  SimpleResponse addResponse = SimpleResponse();
  SimpleModel courseRequest = SimpleModel("");
  CourseResponse courseResponse = CourseResponse();
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
    courseRequest.type = 'view';
    _service.course(courseRequest).then((value) {
      courseResponse = value;
      if (courseResponse.error == false) {
        courseList = courseResponse.data!;
        List.generate(courseList.length, (index) {
          items.add(courseList[index].name);
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
    } else if (permissions.contains('add_year')) {
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
                        Navigator.pushReplacementNamed(context, '/ManageYear');
                      }),
                  title: Responsive.isDesktop(context)
                      ? const Text(
                          'Add Year',
                          style: TextStyle(color: Colors.white),
                        )
                      : const Text(
                          'Add Year',
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
                                    child: permissions.contains('add_year')
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
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 0),
                                                      labelText: "Course",
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
                                                          courseId = courseList[
                                                                  items.indexOf(
                                                                          newValue) -
                                                                      1]
                                                              .id
                                                              .toString();
                                                        },
                                                      );
                                                    },
                                                  ),
                                                  TextFormField(
                                                    controller: yearController,
                                                    keyboardType:
                                                        TextInputType.name,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText: ' Year',
                                                      hintText: 'Enter Year*',
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
                                                            if (dropdownvalueService ==
                                                                'Select Course') {
                                                              AppUtil.showToast(
                                                                  "Please Select Course",
                                                                  "e");
                                                            } else if (yearController
                                                                .text.isEmpty) {
                                                              AppUtil.showToast(
                                                                  "Please Enter Year",
                                                                  "e");
                                                            } else {
                                                              addYearRequest
                                                                      .course =
                                                                  courseId
                                                                      .toString();

                                                              addYearRequest
                                                                      .subCourse =
                                                                  yearController
                                                                      .text
                                                                      .trim();

                                                              Webservice
                                                                  _service =
                                                                  Webservice();
                                                              _service
                                                                  .addYear(
                                                                      addYearRequest)
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
                                                                      '/ManageYear');
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
