import 'dart:io';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gims/model/Request/addStudentRequest.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;
import 'package:http/http.dart' as http;

import 'package:gims/Api/AppCommonVariable.dart';
import 'package:gims/api/webService.dart';
import 'package:gims/controllers/AppUtil.dart';
import 'package:gims/model/Request/addDegreeRequest.dart';
import 'package:gims/model/Request/courseFilterRequest.dart';
import 'package:gims/model/Request/sessionRequest.dart';
import 'package:gims/model/Request/simpleRequest.dart';
import 'package:gims/model/Request/yearRequest.dart';
import 'package:gims/model/Response/SimpleResponse.dart';
import 'package:gims/model/Response/courseResponse.dart';
import 'package:gims/model/Response/degreeResponse.dart';
import 'package:gims/model/Response/sessionResponse.dart';
import 'package:gims/model/Response/yearResponse.dart';
import 'package:gims/responsive.dart';
import 'package:gims/view/home/sidebar.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({super.key});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  bool isLoading = false;
  int crocesscount = 0;
  double childAspect = 0.00;
  bool babkbutton = false;
  String permissions = '';
  var _selectedImage;
  var _selectedImage2;
  var _selectedImage3;
  late ImagePicker _picker;
  late ImagePicker _picker2;
  late ImagePicker _picker3;
  TextEditingController nameController = TextEditingController();
  final FocusNode nameFocusNode = FocusNode();
  TextEditingController fathernameController = TextEditingController();
  final FocusNode fathernameFocusNode = FocusNode();
  TextEditingController mothernameController = TextEditingController();
  final FocusNode mothernameFocusNode = FocusNode();
  TextEditingController aadharController = TextEditingController();
  final FocusNode aadharFocusNode = FocusNode();
  TextEditingController mobileController = TextEditingController();
  final FocusNode mobileFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();
  TextEditingController parentNoController = TextEditingController();
  TextEditingController casteController = TextEditingController();
  TextEditingController enrollmentController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> items4 = ['Select Degree'];
  String? dropdownvalueService4 = 'Select Degree';
  List degreeList = [];
  String degreeId = '';

  List<String> items = ['Select Session'];
  String? dropdownvalueService = 'Select Session';
  List sessionList = [];
  String sessionId = '';

  List<String> items2 = ['Select Course'];
  String? dropdownvalueService2 = 'Select Course';
  List courseList = [];
  String courseId = '';
  String courseYear = '';

  List<String> items3 = ['Select Year'];
  String? dropdownvalueService3 = 'Select Year';
  List yearList = [];
  String yearId = '';

  List<String> items5 = ["Select Gender", "Male", "Female"];
  String? dropdownvalueService5 = 'Select Gender';

  List<String> items6 = ['Select Religion'];
  String? dropdownvalueService6 = 'Select Religion';
  List religionList = [];
  String religionId = '';

  List<String> items7 = ['Select Category'];
  String? dropdownvalueService7 = 'Select Category';
  List categoryList = [];
  String categoryId = '';

  List<String> items8 = ["Select Medium", "English", "Hindi"];
  String? dropdownvalueService8 = 'Select Medium';

  final AddDegreeRequest addDegreeRequest = AddDegreeRequest("");
  SimpleResponse addResponse = SimpleResponse();

  YearRequest yearRequest = YearRequest("", "");
  SessionRequest sessionRequest = SessionRequest("", "");
  CourseResponse courseResponse = CourseResponse();
  YearResponse yearResponse = YearResponse();
  SessionResponse sessionResponse = SessionResponse();

  SimpleModel degreeRequest = SimpleModel("");
  DegreeResponse degreeResponse = DegreeResponse();

  CourseFilterRequest courseFilterRequest = CourseFilterRequest("", "");

  SimpleModel simpleModel = SimpleModel("");

  AddStudentRequest addStudentRequest = AddStudentRequest("", "", "", "", "",
      "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "");

  final Webservice _service = Webservice();
  String logo = "";
  var _selectedFile;
  var _selectedFile2;
  var _selectedFile3;
  Uint8List? _imageBytes;
  Uint8List? _imageBytes2;
  Uint8List? _imageBytes3;

  void _handleImageUpload(html.File file) {
    final reader = html.FileReader();
    reader.onLoadEnd.listen((e) {
      setState(() {
        _imageBytes = reader.result as Uint8List?;
      });
    });

    reader.readAsArrayBuffer(file);
  }

  void _openFilePicker() {
    final input = html.FileUploadInputElement()..accept = 'image/*';
    input.click();

    input.onChange.listen((e) {
      final files = input.files;
      if (files!.isNotEmpty) {
        setState(() {
          _selectedFile = files[0];
        });
        _handleImageUpload(_selectedFile!);
      }
    });
  }

  void _handleImageUpload2(html.File file) {
    final reader = html.FileReader();
    reader.onLoadEnd.listen((e) {
      setState(() {
        _imageBytes2 = reader.result as Uint8List?;
      });
    });

    reader.readAsArrayBuffer(file);
  }

  void _openFilePicker2() {
    final input = html.FileUploadInputElement()..accept = 'image/*';
    input.click();

    input.onChange.listen((e) {
      final files = input.files;
      if (files!.isNotEmpty) {
        setState(() {
          _selectedFile2 = files[0];
        });
        _handleImageUpload2(_selectedFile2!);
      }
    });
  }

  void _handleImageUpload3(html.File file) {
    final reader = html.FileReader();
    reader.onLoadEnd.listen((e) {
      setState(() {
        _imageBytes3 = reader.result as Uint8List?;
      });
    });

    reader.readAsArrayBuffer(file);
  }

  void _openFilePicker3() {
    final input = html.FileUploadInputElement()..accept = 'image/*';
    input.click();

    input.onChange.listen((e) {
      final files = input.files;
      if (files!.isNotEmpty) {
        setState(() {
          _selectedFile3 = files[0];
        });
        _handleImageUpload3(_selectedFile3!);
      }
    });
  }

  @override
  void dispose() {
    // Dispose controllers and focus nodes
    nameFocusNode.dispose();
    fathernameFocusNode.dispose();
    mothernameFocusNode.dispose();
    aadharFocusNode.dispose();
    mobileFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _picker = ImagePicker();
    _picker2 = ImagePicker();
    _picker3 = ImagePicker();
    isLoading = true;
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      setState(() {
        permissions = sp.getString(PERMISSIONS)!;
      });
      degreeRequest.type = 'view';
      _service.degree(degreeRequest).then((value) {
        degreeResponse = value;
        if (degreeResponse.error == false) {
          degreeList = degreeResponse.data!;
          List.generate(degreeList.length, (index) {
            items4.add(degreeList[index].name);
          });
        }
      });

      simpleModel.type = 'view';
      _service.religion(simpleModel).then((value) {
        degreeResponse = value;
        religionList = degreeResponse.data!;
        List.generate(religionList.length, (index) {
          items6.add(religionList[index].name);
        });
      });
      simpleModel.type = 'view';
      _service.category(simpleModel).then((value) {
        degreeResponse = value;
        categoryList = degreeResponse.data!;
        List.generate(categoryList.length, (index) {
          items7.add(categoryList[index].name);
        });
        setState(() {
          isLoading = false;
        });
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
    } else if (permissions.contains('add_student')) {
      return SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            automaticallyImplyLeading: babkbutton,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/ManageStudent');
                }),
            title: Responsive.isDesktop(context)
                ? const Text(
                    'Add Student',
                    style: TextStyle(color: Colors.white),
                  )
                : const Text(
                    'Add Student',
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
                                    child: permissions.contains('add_student')
                                        ? Column(
                                            children: [
                                              GridView.count(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                crossAxisCount: crocesscount,
                                                childAspectRatio: childAspect,
                                                shrinkWrap: true,
                                                mainAxisSpacing: 20,
                                                crossAxisSpacing: 15,
                                                children: [
                                                  TextFormField(
                                                    controller: nameController,
                                                    focusNode: nameFocusNode,
                                                    keyboardType:
                                                        TextInputType.name,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText: ' Name',
                                                      hintText: 'Enter Name',
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        fathernameController,
                                                    focusNode:
                                                        fathernameFocusNode,
                                                    keyboardType:
                                                        TextInputType.name,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText:
                                                          "Father's Name",
                                                      hintText:
                                                          "Enter Father's Name",
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        mothernameController,
                                                    focusNode:
                                                        mothernameFocusNode,
                                                    keyboardType:
                                                        TextInputType.name,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText:
                                                          "Mother's Name",
                                                      hintText:
                                                          "Enter Mother's Name",
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        aadharController,
                                                    focusNode: aadharFocusNode,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    maxLength: 12,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText: "Aadhar No",
                                                      hintText:
                                                          "Enter Aadhar No",
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        mobileController,
                                                    focusNode: mobileFocusNode,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    maxLength: 10,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText:
                                                          "Mobile Number (Whatsapp)",
                                                      hintText:
                                                          "Enter Mobile Number",
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller: emailController,
                                                    keyboardType: TextInputType
                                                        .emailAddress,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText: "Email Adress",
                                                      hintText:
                                                          "Enter Email Address",
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        parentNoController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    maxLength: 10,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText:
                                                          "Parents Mobile Number",
                                                      hintText:
                                                          "Enter Parents Mobile Number",
                                                    ),
                                                  ),
                                                  DateTimePicker(
                                                    fieldHintText: "DOB",
                                                    controller: dobController,
                                                    style: const TextStyle(
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      color: Colors.black,
                                                    ),
                                                    type:
                                                        DateTimePickerType.date,
                                                    firstDate: DateTime(1700),
                                                    lastDate: DateTime.now(),
                                                    decoration: InputDecoration(
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(11),
                                                        borderSide: BorderSide(
                                                          color:
                                                              Theme.of(context)
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
                                                            BorderRadius
                                                                .circular(11),
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(11),
                                                      ),
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                        horizontal: 10,
                                                        vertical: 2,
                                                      ),
                                                      label: const Text("DOB"),
                                                      hintText:
                                                          'Select Date of Birth',
                                                      hintStyle: TextStyle(
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        color: Colors
                                                            .grey.shade400,
                                                      ),
                                                    ),
                                                  ),
                                                  DropdownButtonFormField(
                                                    isExpanded: true,
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 10,
                                                              vertical: 0),
                                                      labelText: "Degree",
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
                                                          isLoading = true;
                                                          dropdownvalueService4 =
                                                              newValue!;
                                                          degreeId = degreeList[
                                                                  items4.indexOf(
                                                                          newValue) -
                                                                      1]
                                                              .id
                                                              .toString();
                                                          items2.clear();
                                                          items2.add(
                                                              "Select Course");

                                                          courseFilterRequest
                                                              .type = 'view';
                                                          courseFilterRequest
                                                                  .degree =
                                                              degreeId
                                                                  .toString();
                                                          _service
                                                              .courseManageFilter(
                                                                  courseFilterRequest)
                                                              .then((value) {
                                                            courseResponse =
                                                                value;
                                                            if (courseResponse
                                                                    .error ==
                                                                false) {
                                                              courseList =
                                                                  courseResponse
                                                                      .data!;
                                                              List.generate(
                                                                  courseList
                                                                      .length,
                                                                  (index) {
                                                                items2.add(
                                                                    courseList[
                                                                            index]
                                                                        .name);
                                                              });

                                                              setState(() {
                                                                isLoading =
                                                                    false;
                                                              });
                                                            } else {
                                                              setState(() {
                                                                isLoading =
                                                                    false;
                                                              });
                                                            }
                                                          });
                                                        },
                                                      );
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
                                                        int index = items2
                                                            .indexOf(newValue);
                                                        if (index >= 0 &&
                                                            index <=
                                                                courseList
                                                                    .length) {
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
                                                        }

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
                                                        int index = items3
                                                            .indexOf(newValue);
                                                        if (index >= 0 &&
                                                            index <=
                                                                yearList
                                                                    .length) {
                                                          yearId = yearList[
                                                                  items3.indexOf(
                                                                          newValue) -
                                                                      1]
                                                              .id
                                                              .toString();
                                                        }
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
                                                      labelText: "Gender",
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
                                                    value: dropdownvalueService5 !=
                                                                null &&
                                                            items5.contains(
                                                                dropdownvalueService5)
                                                        ? dropdownvalueService5
                                                        : (items5.isNotEmpty
                                                            ? items5[0]
                                                            : null),
                                                    icon: const Icon(Icons
                                                        .keyboard_arrow_down),
                                                    items: items5
                                                        .map((String item) {
                                                      return DropdownMenuItem(
                                                        value: item,
                                                        child: Text(item),
                                                      );
                                                    }).toList(),
                                                    onChanged:
                                                        (String? newValue) {
                                                      setState(() {
                                                        dropdownvalueService5 =
                                                            newValue!;
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
                                                      labelText: "Religion",
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
                                                    value: dropdownvalueService6 !=
                                                                null &&
                                                            items.contains(
                                                                dropdownvalueService6)
                                                        ? dropdownvalueService6
                                                        : (items6.isNotEmpty
                                                            ? items6[0]
                                                            : null),
                                                    icon: const Icon(Icons
                                                        .keyboard_arrow_down),
                                                    items: items6
                                                        .map((String item) {
                                                      return DropdownMenuItem(
                                                        value: item,
                                                        child: Text(item),
                                                      );
                                                    }).toList(),
                                                    onChanged:
                                                        (String? newValue) {
                                                      setState(() {
                                                        dropdownvalueService6 =
                                                            newValue!;
                                                        int index = items6
                                                            .indexOf(newValue);
                                                        if (index >= 0 &&
                                                            index <=
                                                                religionList
                                                                    .length) {
                                                          religionId = religionList[
                                                                  items6.indexOf(
                                                                          newValue) -
                                                                      1]
                                                              .id
                                                              .toString();
                                                        }
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
                                                      labelText: "Category",
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
                                                    value: dropdownvalueService7 !=
                                                                null &&
                                                            items.contains(
                                                                dropdownvalueService7)
                                                        ? dropdownvalueService7
                                                        : (items7.isNotEmpty
                                                            ? items7[0]
                                                            : null),
                                                    icon: const Icon(Icons
                                                        .keyboard_arrow_down),
                                                    items: items7
                                                        .map((String item) {
                                                      return DropdownMenuItem(
                                                        value: item,
                                                        child: Text(item),
                                                      );
                                                    }).toList(),
                                                    onChanged:
                                                        (String? newValue) {
                                                      setState(() {
                                                        dropdownvalueService7 =
                                                            newValue!;
                                                        int index = items7
                                                            .indexOf(newValue);
                                                        if (index >= 0 &&
                                                            index <=
                                                                categoryList
                                                                    .length) {
                                                          categoryId = categoryList[
                                                                  items7.indexOf(
                                                                          newValue) -
                                                                      1]
                                                              .id
                                                              .toString();
                                                        }
                                                      });
                                                    },
                                                  ),
                                                  TextFormField(
                                                    controller: casteController,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText: "Caste",
                                                      hintText: "Enter Caste",
                                                    ),
                                                  ),
                                                  DropdownButtonFormField(
                                                    isExpanded: true,
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 10,
                                                              vertical: 0),
                                                      labelText: "Medium",
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
                                                    value: dropdownvalueService8 !=
                                                                null &&
                                                            items8.contains(
                                                                dropdownvalueService8)
                                                        ? dropdownvalueService8
                                                        : (items8.isNotEmpty
                                                            ? items8[0]
                                                            : null),
                                                    icon: const Icon(Icons
                                                        .keyboard_arrow_down),
                                                    items: items8
                                                        .map((String item) {
                                                      return DropdownMenuItem(
                                                        value: item,
                                                        child: Text(item),
                                                      );
                                                    }).toList(),
                                                    onChanged:
                                                        (String? newValue) {
                                                      setState(() {
                                                        dropdownvalueService8 =
                                                            newValue!;
                                                      });
                                                    },
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        enrollmentController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText:
                                                          "Enrollment Number",
                                                      hintText:
                                                          "Enter Enrollment Number",
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    maxLines: null,
                                                    controller:
                                                        addressController,
                                                    keyboardType:
                                                        TextInputType.multiline,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText: "Address",
                                                      hintText: "Enter Address",
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller: cityController,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText: "City",
                                                      hintText:
                                                          "Enter City Name",
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller: stateController,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText: "State",
                                                      hintText:
                                                          "Enter State Name",
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        pincodeController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText: "Pincode",
                                                      hintText: "Enter Pincode",
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        width: 1,
                                                        color: const Color
                                                            .fromARGB(
                                                          255,
                                                          163,
                                                          163,
                                                          163,
                                                        ),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 8,
                                                          horizontal: 15),
                                                      child: Row(
                                                        children: [
                                                          ElevatedButton(
                                                            style: ButtonStyle(
                                                              elevation:
                                                                  WidgetStateProperty
                                                                      .resolveWith<
                                                                          double?>(
                                                                (Set<WidgetState>
                                                                    states) {
                                                                  return 10;
                                                                },
                                                              ),
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
                                                                      .primaryColor;
                                                                },
                                                              ),
                                                            ),
                                                            onPressed: kIsWeb
                                                                ? _openFilePicker
                                                                : _showPicker,
                                                            child: const Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .add_a_photo,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                  'Student Photo',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: Responsive
                                                                    .isDesktop(
                                                                        context)
                                                                ? 200
                                                                : 160,
                                                            height: Responsive
                                                                    .isDesktop(
                                                                        context)
                                                                ? 200
                                                                : 160,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              child: kIsWeb
                                                                  ? _imageBytes !=
                                                                          null
                                                                      ? Image
                                                                          .memory(
                                                                          _imageBytes!,
                                                                        )
                                                                      : Image.asset(
                                                                          "assets/images/def_image.png")
                                                                  : _selectedImage !=
                                                                          null
                                                                      ? Image
                                                                          .file(
                                                                          _selectedImage,
                                                                          fit: BoxFit
                                                                              .contain,
                                                                        )
                                                                      : Image.asset(
                                                                          "assets/images/def_image.png"),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        width: 1,
                                                        color: const Color
                                                            .fromARGB(
                                                          255,
                                                          163,
                                                          163,
                                                          163,
                                                        ),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 8,
                                                          horizontal: 15),
                                                      child: Row(
                                                        children: [
                                                          ElevatedButton(
                                                            style: ButtonStyle(
                                                              elevation:
                                                                  WidgetStateProperty
                                                                      .resolveWith<
                                                                          double?>(
                                                                (Set<WidgetState>
                                                                    states) {
                                                                  return 10;
                                                                },
                                                              ),
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
                                                                      .primaryColor;
                                                                },
                                                              ),
                                                            ),
                                                            onPressed: kIsWeb
                                                                ? _openFilePicker2
                                                                : _showPicker2,
                                                            child: const Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .add_a_photo,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                  'Student Signature',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: Responsive
                                                                    .isDesktop(
                                                                        context)
                                                                ? 200
                                                                : 130,
                                                            height: Responsive
                                                                    .isDesktop(
                                                                        context)
                                                                ? 200
                                                                : 130,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              child: kIsWeb
                                                                  ? _imageBytes2 !=
                                                                          null
                                                                      ? Image
                                                                          .memory(
                                                                          _imageBytes2!,
                                                                        )
                                                                      : Image.asset(
                                                                          "assets/images/def_image.png")
                                                                  : _selectedImage2 !=
                                                                          null
                                                                      ? Image
                                                                          .file(
                                                                          _selectedImage2,
                                                                          fit: BoxFit
                                                                              .contain,
                                                                        )
                                                                      : Image.asset(
                                                                          "assets/images/def_image.png"),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        width: 1,
                                                        color: const Color
                                                            .fromARGB(
                                                          255,
                                                          163,
                                                          163,
                                                          163,
                                                        ),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 8,
                                                          horizontal: 15),
                                                      child: Row(
                                                        children: [
                                                          ElevatedButton(
                                                            style: ButtonStyle(
                                                              elevation:
                                                                  WidgetStateProperty
                                                                      .resolveWith<
                                                                          double?>(
                                                                (Set<WidgetState>
                                                                    states) {
                                                                  return 10;
                                                                },
                                                              ),
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
                                                                      .primaryColor;
                                                                },
                                                              ),
                                                            ),
                                                            onPressed: kIsWeb
                                                                ? _openFilePicker3
                                                                : _showPicker3,
                                                            child: const Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .add_a_photo,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                  'Aadhar Card',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: Responsive
                                                                    .isDesktop(
                                                                        context)
                                                                ? 200
                                                                : 130,
                                                            height: Responsive
                                                                    .isDesktop(
                                                                        context)
                                                                ? 200
                                                                : 130,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              child: kIsWeb
                                                                  ? _imageBytes3 !=
                                                                          null
                                                                      ? Image
                                                                          .memory(
                                                                          _imageBytes3!,
                                                                        )
                                                                      : Image.asset(
                                                                          "assets/images/def_image.png")
                                                                  : _selectedImage3 !=
                                                                          null
                                                                      ? Image
                                                                          .file(
                                                                          _selectedImage3,
                                                                          fit: BoxFit
                                                                              .contain,
                                                                        )
                                                                      : Image.asset(
                                                                          "assets/images/def_image.png"),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
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
                                                            if (nameController
                                                                .text.isEmpty) {
                                                              AppUtil.showToast(
                                                                  "Please Enter Name",
                                                                  "e");
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      nameFocusNode);
                                                            } else if (fathernameController
                                                                .text.isEmpty) {
                                                              AppUtil.showToast(
                                                                  "Please Enter Father's Name",
                                                                  "e");
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      fathernameFocusNode);
                                                            } else if (mothernameController
                                                                .text.isEmpty) {
                                                              AppUtil.showToast(
                                                                  "Please Enter Mother's Name",
                                                                  "e");
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      mothernameFocusNode);
                                                            } else if (aadharController
                                                                .text.isEmpty) {
                                                              AppUtil.showToast(
                                                                  "Please Enter Aadhar Number",
                                                                  "e");
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      aadharFocusNode);
                                                            } else if (mobileController
                                                                .text.isEmpty) {
                                                              AppUtil.showToast(
                                                                  "Please Enter Mobile Number",
                                                                  "e");
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      mobileFocusNode);
                                                            } else if (dropdownvalueService4 ==
                                                                'Select Degree') {
                                                              AppUtil.showToast(
                                                                  "Please Select Degree",
                                                                  "e");
                                                            } else if (dropdownvalueService2 ==
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
                                                            } else {
                                                              SharedPreferences
                                                                      .getInstance()
                                                                  .then(
                                                                      (SharedPreferences
                                                                          sp) {
                                                                addStudentRequest
                                                                        .name =
                                                                    nameController
                                                                        .text
                                                                        .trim();
                                                                addStudentRequest
                                                                        .fatherName =
                                                                    fathernameController
                                                                        .text
                                                                        .trim();

                                                                addStudentRequest
                                                                        .motherName =
                                                                    mothernameController
                                                                        .text
                                                                        .trim();
                                                                addStudentRequest
                                                                        .aadharNo =
                                                                    aadharController
                                                                        .text
                                                                        .trim();
                                                                addStudentRequest
                                                                        .mobileNumber =
                                                                    mobileController
                                                                        .text
                                                                        .trim();
                                                                addStudentRequest
                                                                        .email =
                                                                    emailController
                                                                        .text
                                                                        .trim();
                                                                addStudentRequest
                                                                        .parentNo =
                                                                    parentNoController
                                                                        .text
                                                                        .trim();
                                                                addStudentRequest
                                                                        .dob =
                                                                    dobController
                                                                        .text
                                                                        .trim();
                                                                addStudentRequest
                                                                        .degree =
                                                                    degreeId
                                                                        .trim();
                                                                addStudentRequest
                                                                        .course =
                                                                    courseId
                                                                        .trim();
                                                                addStudentRequest
                                                                        .year =
                                                                    yearId
                                                                        .trim();
                                                                addStudentRequest
                                                                        .session =
                                                                    dropdownvalueService
                                                                        .toString();
                                                                addStudentRequest
                                                                        .sessionIdd =
                                                                    sessionId
                                                                        .toString();

                                                                addStudentRequest
                                                                        .name =
                                                                    nameController
                                                                        .text
                                                                        .trim();

                                                                if (dropdownvalueService5 !=
                                                                    'Select Gender') {
                                                                  addStudentRequest
                                                                          .gender =
                                                                      dropdownvalueService5
                                                                          .toString();
                                                                }
                                                                if (dropdownvalueService6 !=
                                                                    'Select Religion') {
                                                                  addStudentRequest
                                                                          .religion =
                                                                      religionId
                                                                          .toString();
                                                                }
                                                                if (dropdownvalueService7 !=
                                                                    'Select Category') {
                                                                  addStudentRequest
                                                                          .category =
                                                                      categoryId
                                                                          .toString();
                                                                }
                                                                addStudentRequest
                                                                        .caste =
                                                                    casteController
                                                                        .text
                                                                        .trim();
                                                                if (dropdownvalueService8 !=
                                                                    'Select Medium') {
                                                                  addStudentRequest
                                                                          .medium =
                                                                      dropdownvalueService8
                                                                          .toString();
                                                                }
                                                                addStudentRequest
                                                                        .enrollmentNo =
                                                                    enrollmentController
                                                                        .text
                                                                        .trim();
                                                                addStudentRequest
                                                                        .address =
                                                                    addressController
                                                                        .text
                                                                        .trim();
                                                                addStudentRequest
                                                                        .city =
                                                                    cityController
                                                                        .text
                                                                        .trim();
                                                                addStudentRequest
                                                                        .state =
                                                                    stateController
                                                                        .text
                                                                        .trim();
                                                                addStudentRequest
                                                                        .pincode =
                                                                    pincodeController
                                                                        .text
                                                                        .trim();

                                                                var mFile;
                                                                try {
                                                                  if (kIsWeb) {
                                                                    if (_imageBytes !=
                                                                        null) {
                                                                      mFile = http.MultipartFile.fromBytes(
                                                                          'image',
                                                                          _imageBytes!,
                                                                          //filename: _selectedFile.toString(),
                                                                          filename: _imageBytes
                                                                              .toString()
                                                                              .split("/")
                                                                              .last);
                                                                    }
                                                                  } else {
                                                                    if (_selectedImage !=
                                                                        null) {
                                                                      mFile = http.MultipartFile.fromBytes(
                                                                          'image',
                                                                          _selectedImage
                                                                              .readAsBytesSync(),
                                                                          filename: _selectedImage
                                                                              .toString()
                                                                              .split("/")
                                                                              .last);
                                                                    }
                                                                  }
                                                                } catch (e) {
                                                                  AppUtil.showToast(
                                                                      'Error creating multipart file: $e',
                                                                      'e');
                                                                }
                                                                var mFile2;
                                                                try {
                                                                  if (kIsWeb) {
                                                                    if (_imageBytes2 !=
                                                                        null) {
                                                                      mFile2 = http.MultipartFile.fromBytes(
                                                                          'image2',
                                                                          _imageBytes2!,
                                                                          //filename: _selectedFile.toString(),
                                                                          filename: _imageBytes2
                                                                              .toString()
                                                                              .split("/")
                                                                              .last);
                                                                    }
                                                                  } else {
                                                                    if (_selectedImage2 !=
                                                                        null) {
                                                                      mFile2 = http.MultipartFile.fromBytes(
                                                                          'image2',
                                                                          _selectedImage2
                                                                              .readAsBytesSync(),
                                                                          filename: _selectedImage2
                                                                              .toString()
                                                                              .split("/")
                                                                              .last);
                                                                    }
                                                                  }
                                                                } catch (e) {
                                                                  AppUtil.showToast(
                                                                      'Error creating multipart file: $e',
                                                                      'e');
                                                                }
                                                                var mFile3;
                                                                try {
                                                                  if (kIsWeb) {
                                                                    if (_imageBytes3 !=
                                                                        null) {
                                                                      mFile3 = http.MultipartFile.fromBytes(
                                                                          'image3',
                                                                          _imageBytes3!,
                                                                          //filename: _selectedFile.toString(),
                                                                          filename: _imageBytes3
                                                                              .toString()
                                                                              .split("/")
                                                                              .last);
                                                                    }
                                                                  } else {
                                                                    if (_selectedImage3 !=
                                                                        null) {
                                                                      mFile3 = http.MultipartFile.fromBytes(
                                                                          'image3',
                                                                          _selectedImage3
                                                                              .readAsBytesSync(),
                                                                          filename: _selectedImage3
                                                                              .toString()
                                                                              .split("/")
                                                                              .last);
                                                                    }
                                                                  }
                                                                } catch (e) {
                                                                  AppUtil.showToast(
                                                                      'Error creating multipart file: $e',
                                                                      'e');
                                                                }

                                                                Webservice
                                                                    _service =
                                                                    Webservice();
                                                                _service
                                                                    .addStudent(
                                                                        addStudentRequest,
                                                                        mFile,
                                                                        mFile2,
                                                                        mFile3)
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
                                                                        '/AddStudent');
                                                                  } else {
                                                                    AppUtil.showToast(
                                                                        addResponse
                                                                            .msg!,
                                                                        'e');
                                                                  }
                                                                });
                                                                setState(() {});
                                                              });
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

  void _showPicker() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Photo Library'),
                  onTap: () async {
                    Navigator.of(context)
                        .pop(); // Close the modal before opening the picker
                    await _imgFromGallery();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () async {
                    Navigator.of(context)
                        .pop(); // Close the modal before opening the picker
                    await _imgFromCamera();
                  },
                ),
              ],
            ),
          );
        });
  }

  Future<void> _requestPermissions() async {
    if (await Permission.camera.isDenied) {
      await Permission.camera.request();
    }

    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    }
  }

  Future<void> _imgFromGallery() async {
    await _requestPermissions(); // Request permissions first

    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _imgFromCamera() async {
    await _requestPermissions(); // Request permissions first

    final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        preferredCameraDevice: CameraDevice.rear);

    if (photo != null) {
      setState(() {
        _selectedImage = File(photo.path);
      });
    }
  }

  void _showPicker2() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Photo Library'),
                  onTap: () async {
                    Navigator.of(context)
                        .pop(); // Close the modal before opening the picker
                    await _imgFromGallery2();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () async {
                    Navigator.of(context)
                        .pop(); // Close the modal before opening the picker
                    await _imgFromCamera2();
                  },
                ),
              ],
            ),
          );
        });
  }

  Future<void> _imgFromGallery2() async {
    await _requestPermissions(); // Request permissions first

    final XFile? image2 = await _picker2.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (image2 != null) {
      setState(() {
        _selectedImage2 = File(image2.path);
      });
    }
  }

  Future<void> _imgFromCamera2() async {
    await _requestPermissions(); // Request permissions first

    final XFile? photo2 = await _picker2.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        preferredCameraDevice: CameraDevice.rear);

    if (photo2 != null) {
      setState(() {
        _selectedImage2 = File(photo2.path);
      });
    }
  }

  void _showPicker3() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Photo Library'),
                  onTap: () async {
                    Navigator.of(context)
                        .pop(); // Close the modal before opening the picker
                    await _imgFromGallery3();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () async {
                    Navigator.of(context)
                        .pop(); // Close the modal before opening the picker
                    await _imgFromCamera3();
                  },
                ),
              ],
            ),
          );
        });
  }

  Future<void> _imgFromGallery3() async {
    await _requestPermissions(); // Request permissions first

    final XFile? image3 = await _picker3.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (image3 != null) {
      setState(() {
        _selectedImage3 = File(image3.path);
      });
    }
  }

  Future<void> _imgFromCamera3() async {
    await _requestPermissions(); // Request permissions first

    final XFile? photo3 = await _picker3.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        preferredCameraDevice: CameraDevice.rear);

    if (photo3 != null) {
      setState(() {
        _selectedImage3 = File(photo3.path);
      });
    }
  }
}
