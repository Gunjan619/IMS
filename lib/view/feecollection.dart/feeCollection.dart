import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gims/controllers/appUtil.dart';
import 'package:gims/model/Request/addCollectionRequest.dart';
import 'package:gims/model/Request/stuDueRequest.dart';
import 'package:gims/model/Request/studentFilterRequest.dart';
import 'package:gims/model/Response/collectionResponse.dart';
import 'package:gims/model/Response/invoiceResponse.dart';
import 'package:gims/model/Response/stuDueResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gims/Api/AppCommonVariable.dart';
import 'package:gims/api/webService.dart';
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

class FeeCollection extends StatefulWidget {
  const FeeCollection({super.key});

  @override
  State<FeeCollection> createState() => _FeeCollectionState();
}

class _FeeCollectionState extends State<FeeCollection> {
  bool isLoading = false;
  bool isVisible = false;
  bool isInv = false;
  int crocesscount = 0;
  double childAspect = 0.00;
  bool babkbutton = false;
  String permissions = '';
  List<String> feeIds = [];
  List<String> paidAmounts = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String totalAmount = '';
  List<TextEditingController> feeId = [];
  List<TextEditingController> amountController = [];
  List<TextEditingController> paidAmountController = [];
  List<TextEditingController> oldAmountController = [];
  TextEditingController totalController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController payDateController = TextEditingController();
  TextEditingController refNumberController = TextEditingController();
  TextEditingController refAmountController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController dueController = TextEditingController();
  TextEditingController paidController = TextEditingController();
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

  List<String> items5 = ['Select Student'];
  String? dropdownvalueService5 = 'Select Student';
  List stuList = [];
  String stuId = '';

  List stuDueList = [];

  List invList = [];

  List<String> items6 = [
    "Select Pay Mode",
    "Cash",
    "Cheque",
    "Online",
    "Debit Card",
    "Credit Card"
  ];
  String? dropdownvalueService6 = 'Select Pay Mode';

  final AddDegreeRequest addDegreeRequest = AddDegreeRequest("");
  SimpleResponse addResponse = SimpleResponse();
  CollectionResponse collectionResponse = CollectionResponse();

  YearRequest yearRequest = YearRequest("", "");
  SessionRequest sessionRequest = SessionRequest("", "");
  CourseResponse courseResponse = CourseResponse();
  YearResponse yearResponse = YearResponse();
  SessionResponse sessionResponse = SessionResponse();

  SimpleModel degreeRequest = SimpleModel("");
  DegreeResponse degreeResponse = DegreeResponse();

  CourseFilterRequest courseFilterRequest = CourseFilterRequest("", "");
  StudentFilterRequest studentFilterRequest =
      StudentFilterRequest("", "", "", "", "", "");
  AddCollectionRequest addCollectionRequest = AddCollectionRequest(
      "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "");

  StuDueRequest stuDueRequest = StuDueRequest("", "", "", "", "");
  StuDueResponse stuDueResponse = StuDueResponse();
  InvoiceResponse invoiceResponse = InvoiceResponse();

  SimpleModel simpleModel = SimpleModel("");

  final Webservice _service = Webservice();

  @override
  void initState() {
    super.initState();
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
          setState(() {
            isLoading = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Responsive.isDesktop(context)) {
      crocesscount = 3;
      childAspect = 10 / 1.5;
      babkbutton = false;
    } else if (Responsive.isTablet(context)) {
      crocesscount = 2;
      childAspect = 10 / 0.9;
      babkbutton = false;
    } else {
      crocesscount = 1;
      childAspect = 18 / 2;
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
    } else if (permissions.contains('feeCollection')) {
      return SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            automaticallyImplyLeading: babkbutton,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                }),
            title: Responsive.isDesktop(context)
                ? const Text(
                    'Fee Collection',
                    style: TextStyle(color: Colors.white),
                  )
                : const Text(
                    'Fee Collection',
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
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: permissions.contains('feeCollection')
                                    ? SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            DropdownButtonFormField(
                                              isExpanded: true,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 0),
                                                labelText: "Degree",
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                              Theme.of(context)
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
                                                      color:
                                                          Colors.grey.shade500),
                                                ),
                                              ),
                                              value: dropdownvalueService4 ??
                                                  items4[0],
                                              icon: const Icon(
                                                  Icons.keyboard_arrow_down),
                                              items: items4.map(
                                                (String items4) {
                                                  return DropdownMenuItem(
                                                    value: items4,
                                                    child: Text(items4),
                                                  );
                                                },
                                              ).toList(),
                                              onChanged: (String? newValue) {
                                                setState(
                                                  () {
                                                    invList.clear();
                                                    items.clear();
                                                    items.add("Select Session");

                                                    items2.clear();
                                                    items2.add("Select Course");
                                                    items3.clear();
                                                    items3.add("Select Year");
                                                    items5.clear();
                                                    items5
                                                        .add("Select Student");
                                                    sessionId = '';
                                                    courseId = '';
                                                    yearId = '';
                                                    stuId = '';
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
                                                    items2.add("Select Course");

                                                    courseFilterRequest.type =
                                                        'view';
                                                    courseFilterRequest.degree =
                                                        degreeId.toString();
                                                    _service
                                                        .courseManageFilter(
                                                            courseFilterRequest)
                                                        .then((value) {
                                                      courseResponse = value;
                                                      if (courseResponse
                                                              .error ==
                                                          false) {
                                                        courseList =
                                                            courseResponse
                                                                .data!;
                                                        List.generate(
                                                            courseList.length,
                                                            (index) {
                                                          items2.add(
                                                              courseList[index]
                                                                  .name);
                                                        });

                                                        setState(() {
                                                          isLoading = false;
                                                        });
                                                      } else {
                                                        setState(() {
                                                          isLoading = false;
                                                        });
                                                      }
                                                    });
                                                  },
                                                );
                                              },
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            DropdownButtonFormField(
                                              isExpanded: true,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 0),
                                                labelText: "Course",
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    6))),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade500),
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
                                              icon: const Icon(
                                                  Icons.keyboard_arrow_down),
                                              items: items2.map((String item) {
                                                return DropdownMenuItem(
                                                  value: item,
                                                  child: Text(item),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  invList.clear();
                                                  items.clear();
                                                  items.add("Select Session");

                                                  items3.clear();
                                                  items3.add("Select Year");
                                                  items5.clear();
                                                  items5.add("Select Student");
                                                  sessionId = '';
                                                  courseId = '';
                                                  yearId = '';
                                                  stuId = '';
                                                  isLoading = true;
                                                  courseYear = '';
                                                  dropdownvalueService2 =
                                                      newValue!;
                                                  int index =
                                                      items2.indexOf(newValue);
                                                  if (index >= 0 &&
                                                      index <=
                                                          courseList.length) {
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

                                                  yearRequest.type = 'view';
                                                  yearRequest.course = courseId;
                                                  _service
                                                      .yearFilter(yearRequest)
                                                      .then((value) {
                                                    yearResponse = value;
                                                    if (yearResponse.error ==
                                                        false) {
                                                      yearList =
                                                          yearResponse.data!;
                                                      items3.clear();

                                                      items3.add('Select Year');
                                                      dropdownvalueService3 =
                                                          items3[
                                                              0]; // Reset dropdown
                                                      yearList.forEach((year) {
                                                        items3.add(
                                                            year.subCourse);
                                                      });
                                                    } else {
                                                      items3.clear();

                                                      items3.add('Select Year');
                                                      dropdownvalueService3 =
                                                          items3[
                                                              0]; // Reset dropdown
                                                    }
                                                  });

                                                  sessionRequest.type = 'view';
                                                  sessionRequest.year =
                                                      courseYear;
                                                  _service
                                                      .sessionFilter(
                                                          sessionRequest)
                                                      .then((value) {
                                                    sessionResponse = value;
                                                    if (sessionResponse.error ==
                                                        false) {
                                                      sessionList =
                                                          sessionResponse.data!;
                                                      items.clear();

                                                      items.add(
                                                          'Select Session');
                                                      dropdownvalueService = items[
                                                          0]; // Reset dropdown
                                                      sessionList
                                                          .forEach((session) {
                                                        items.add(
                                                            session.session);
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
                                            SizedBox(
                                              height: 20,
                                            ),
                                            DropdownButtonFormField(
                                              isExpanded: true,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 0),
                                                labelText: "Year",
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    6))),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade500),
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
                                              icon: const Icon(
                                                  Icons.keyboard_arrow_down),
                                              items: items3.map((String item) {
                                                return DropdownMenuItem(
                                                  value: item,
                                                  child: Text(item),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  invList.clear();
                                                  items5.clear();
                                                  items5.add("Select Student");
                                                  sessionId = '';
                                                  yearId = '';
                                                  stuId = '';
                                                  dropdownvalueService3 =
                                                      newValue!;
                                                  int index =
                                                      items3.indexOf(newValue);
                                                  if (index >= 0 &&
                                                      index <=
                                                          yearList.length) {
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
                                            SizedBox(
                                              height: 20,
                                            ),
                                            DropdownButtonFormField(
                                              isExpanded: true,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 0),
                                                labelText: "Session",
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    6))),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade500),
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
                                              icon: const Icon(
                                                  Icons.keyboard_arrow_down),
                                              items: items.map((String item) {
                                                return DropdownMenuItem(
                                                  value: item,
                                                  child: Text(item),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  invList.clear();
                                                  items5.clear();
                                                  items5.add("Select Student");
                                                  sessionId = '';
                                                  stuId = '';
                                                  isLoading = true;
                                                  dropdownvalueService =
                                                      newValue!;
                                                  sessionId = sessionList[
                                                          items.indexOf(
                                                                  newValue) -
                                                              1]
                                                      .id
                                                      .toString();

                                                  items5.clear();
                                                  items5.add("Select Student");

                                                  studentFilterRequest.type =
                                                      'view';
                                                  studentFilterRequest.degree =
                                                      degreeId.toString();
                                                  studentFilterRequest.course =
                                                      courseId.toString();
                                                  studentFilterRequest.year =
                                                      yearId.toString();
                                                  studentFilterRequest.session =
                                                      sessionId.toString();
                                                  studentFilterRequest
                                                          .sessionName =
                                                      dropdownvalueService
                                                          .toString();

                                                  _service
                                                      .manageStudentFilter(
                                                          studentFilterRequest)
                                                      .then((value) {
                                                    degreeResponse = value;
                                                    if (degreeResponse.error ==
                                                        false) {
                                                      stuList =
                                                          degreeResponse.data!;
                                                      List.generate(
                                                          stuList.length,
                                                          (index) {
                                                        items5.add(
                                                            stuList[index]
                                                                .name);
                                                      });

                                                      setState(() {
                                                        isLoading = false;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        isLoading = false;
                                                      });
                                                    }
                                                  });
                                                });
                                              },
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            DropdownButtonFormField(
                                              isExpanded: true,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 0),
                                                labelText: "Student",
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    6))),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade500),
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
                                              icon: const Icon(
                                                  Icons.keyboard_arrow_down),
                                              items: items5.map((String item) {
                                                return DropdownMenuItem(
                                                  value: item,
                                                  child: Text(item),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  dropdownvalueService5 =
                                                      newValue!;
                                                  if (dropdownvalueService5 ==
                                                      'Select Student') {
                                                    isVisible = false;
                                                  } else {
                                                    stuId = stuList[
                                                            items5.indexOf(
                                                                    newValue) -
                                                                1]
                                                        .id
                                                        .toString();

                                                    stuDueRequest.degree =
                                                        degreeId.toString();
                                                    stuDueRequest.course =
                                                        courseId.toString();
                                                    stuDueRequest.year =
                                                        yearId.toString();
                                                    stuDueRequest.session =
                                                        sessionId.toString();
                                                    stuDueRequest.stuid =
                                                        stuId.toString();
                                                    _service
                                                        .stuDue(stuDueRequest)
                                                        .then((value) {
                                                      stuDueResponse = value;
                                                      if (stuDueResponse
                                                              .error ==
                                                          false) {
                                                        stuDueList =
                                                            stuDueResponse
                                                                .data!;

                                                        totalController.text =
                                                            stuDueResponse.total
                                                                .toString();
                                                        amountController =
                                                            List.generate(
                                                                stuDueList
                                                                    .length,
                                                                (index) =>
                                                                    TextEditingController());
                                                        paidAmountController =
                                                            List.generate(
                                                                stuDueList
                                                                    .length,
                                                                (index) =>
                                                                    TextEditingController());
                                                        feeId = List.generate(
                                                            stuDueList.length,
                                                            (index) =>
                                                                TextEditingController());
                                                        oldAmountController =
                                                            List.generate(
                                                                stuDueList
                                                                    .length,
                                                                (index) =>
                                                                    TextEditingController());
                                                        for (int i = 0;
                                                            i <
                                                                stuDueList
                                                                    .length;
                                                            i++) {
                                                          feeId[i].text =
                                                              stuDueList[i].id;
                                                          oldAmountController[i]
                                                                  .text =
                                                              stuDueList[i]
                                                                  .oldAmount;
                                                          amountController[i]
                                                                  .text =
                                                              stuDueList[i]
                                                                  .amount;
                                                          paidAmountController[
                                                                  i]
                                                              .text = stuDueList[
                                                                      i]
                                                                  .paidAmount ??
                                                              '0';
                                                        }

                                                        _updateTotals();

                                                        setState(() {
                                                          isLoading = false;
                                                          isVisible = true;
                                                        });
                                                      } else {
                                                        setState(() {
                                                          AppUtil.showToast(
                                                              stuDueResponse.msg
                                                                  .toString(),
                                                              'e');
                                                          isLoading = false;
                                                          isVisible = false;
                                                        });
                                                      }
                                                    });

                                                    _service
                                                        .stuInvoice(
                                                            stuDueRequest)
                                                        .then((value) {
                                                      invList.clear();
                                                      invoiceResponse = value;
                                                      if (invoiceResponse
                                                              .error ==
                                                          false) {
                                                        invList =
                                                            invoiceResponse
                                                                .data!;
                                                      }
                                                    });
                                                  }
                                                });
                                              },
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            if (stuDueResponse.error == true)
                                              SizedBox(
                                                height: 35,
                                              ),
                                            if (stuDueResponse.error == true)
                                              Text(
                                                "Receipts",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            if (stuDueResponse.error == true)
                                              SizedBox(
                                                height: 35,
                                              ),
                                            if (stuDueResponse.error == true)
                                              SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: DataTable(
                                                  headingRowColor: WidgetStateColor
                                                      .resolveWith((states) =>
                                                          Theme.of(context)
                                                              .primaryColor),
                                                  showBottomBorder: true,
                                                  border:
                                                      TableBorder.all(width: 1),
                                                  headingTextStyle:
                                                      const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  columns: _underCreateColums(),
                                                  rows: _underCreateRows(),
                                                ),
                                              ),
                                            Visibility(
                                              visible: isVisible,
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount: stuDueList.length,
                                                itemBuilder: (context, index) {
                                                  return Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 2,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: Text(
                                                            stuDueList[index]
                                                                .feeName
                                                                .toString(),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: TextFormField(
                                                            enabled: false,
                                                            controller:
                                                                amountController[
                                                                    index],
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            inputFormatters: <TextInputFormatter>[
                                                              FilteringTextInputFormatter
                                                                  .digitsOnly
                                                            ],
                                                            decoration:
                                                                const InputDecoration(
                                                              isDense: true,
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .all(10),
                                                              disabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              border:
                                                                  OutlineInputBorder(),
                                                              labelStyle: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                              labelText:
                                                                  '  Amount',
                                                              hintText:
                                                                  'Enter Amount',
                                                            ),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ),
                                                      if (int.parse(
                                                              stuDueList[index]
                                                                  .oldAmount) >
                                                          0)
                                                        Expanded(
                                                          flex: 2,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5.0),
                                                            child:
                                                                TextFormField(
                                                              enabled: false,
                                                              controller:
                                                                  oldAmountController[
                                                                      index],
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              inputFormatters: <TextInputFormatter>[
                                                                FilteringTextInputFormatter
                                                                    .digitsOnly
                                                              ],
                                                              decoration:
                                                                  const InputDecoration(
                                                                isDense: true,
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                disabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              Colors.black),
                                                                ),
                                                                border:
                                                                    OutlineInputBorder(),
                                                                labelStyle: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                                labelText:
                                                                    '  Old Paid',
                                                                hintText:
                                                                    'Enter Old Paid Amount',
                                                              ),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                        ),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: TextFormField(
                                                            controller:
                                                                paidAmountController[
                                                                    index],
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            inputFormatters: <TextInputFormatter>[
                                                              FilteringTextInputFormatter
                                                                  .digitsOnly
                                                            ],
                                                            decoration:
                                                                const InputDecoration(
                                                              isDense: true,
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .all(10),
                                                              border:
                                                                  OutlineInputBorder(),
                                                              labelText:
                                                                  ' Paid Amount',
                                                              hintText:
                                                                  'Enter Paid Amount',
                                                            ),
                                                            onChanged: (value) {
                                                              setState(() {
                                                                int?
                                                                    enteredValue =
                                                                    int.tryParse(
                                                                        value);
                                                                int oldPaidAmount =
                                                                    int.tryParse(
                                                                            oldAmountController[index].text) ??
                                                                        0;
                                                                int totalAmount =
                                                                    int.tryParse(
                                                                            stuDueList[index].amount) ??
                                                                        0;

                                                                // Maximum allowable new payment is (totalAmount - oldPaidAmount)
                                                                int maxAmount =
                                                                    totalAmount -
                                                                        oldPaidAmount;

                                                                if (enteredValue !=
                                                                    null) {
                                                                  if (enteredValue <
                                                                          0 ||
                                                                      value ==
                                                                          '') {
                                                                    // If entered value is less than 0 or invalid, set it to 0
                                                                    paidAmountController[
                                                                            index]
                                                                        .text = '0';
                                                                  } else if (enteredValue >
                                                                      maxAmount) {
                                                                    // If entered value exceeds the maxAmount, set it to maxAmount
                                                                    paidAmountController[index]
                                                                            .text =
                                                                        maxAmount
                                                                            .toString();
                                                                  }
                                                                } else {
                                                                  paidAmountController[
                                                                          index]
                                                                      .text = '0';
                                                                }

                                                                // Recalculate totals after adjusting the input
                                                                _updateTotals();
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10, right: 10),
                                                    child: Visibility(
                                                      visible: isVisible,
                                                      child: TextFormField(
                                                        enabled: false,
                                                        controller:
                                                            totalController,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        inputFormatters: <TextInputFormatter>[
                                                          FilteringTextInputFormatter
                                                              .digitsOnly
                                                        ],
                                                        decoration:
                                                            const InputDecoration(
                                                          isDense: true,
                                                          contentPadding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          disabledBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .black),
                                                          ),
                                                          border:
                                                              OutlineInputBorder(),
                                                          labelStyle: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                          labelText: '  Total',
                                                          hintText:
                                                              'Enter Total',
                                                        ),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 10),
                                                    child: Visibility(
                                                      visible: isVisible,
                                                      child: TextFormField(
                                                        enabled: false,
                                                        controller:
                                                            paidController,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        inputFormatters: <TextInputFormatter>[
                                                          FilteringTextInputFormatter
                                                              .digitsOnly
                                                        ],
                                                        decoration:
                                                            const InputDecoration(
                                                          isDense: true,
                                                          contentPadding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          disabledBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .black),
                                                          ),
                                                          border:
                                                              OutlineInputBorder(),
                                                          labelStyle: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                          labelText: ' Paid',
                                                          hintText:
                                                              'Enter Paid Amount',
                                                        ),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 10),
                                                    child: Visibility(
                                                      visible: isVisible,
                                                      child: TextFormField(
                                                        enabled: false,
                                                        controller:
                                                            dueController,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        inputFormatters: <TextInputFormatter>[
                                                          FilteringTextInputFormatter
                                                              .digitsOnly
                                                        ],
                                                        decoration:
                                                            const InputDecoration(
                                                          isDense: true,
                                                          contentPadding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          disabledBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .black),
                                                          ),
                                                          border:
                                                              OutlineInputBorder(),
                                                          labelStyle: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                          labelText: ' Due',
                                                          hintText:
                                                              'Enter Due Amount',
                                                        ),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 25,
                                            ),
                                            Visibility(
                                              visible: isVisible,
                                              child: Column(
                                                children: [
                                                  DropdownButtonFormField(
                                                    isExpanded: true,
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 10,
                                                              vertical: 0),
                                                      labelText: "Pay Mode",
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
                                                            items6.contains(
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
                                                        dateController.text =
                                                            '';
                                                        refAmountController
                                                            .text = '';
                                                        refNumberController
                                                            .text = '';
                                                        dropdownvalueService6 =
                                                            newValue!;
                                                      });
                                                    },
                                                  ),
                                                  if (dropdownvalueService6 ==
                                                      'Cheque')
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                  if (dropdownvalueService6 ==
                                                      'Cheque')
                                                    TextFormField(
                                                      controller:
                                                          refNumberController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      decoration:
                                                          const InputDecoration(
                                                        isDense: true,
                                                        contentPadding:
                                                            EdgeInsets.all(10),
                                                        disabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .black), // Border color when disabled
                                                        ),
                                                        border:
                                                            OutlineInputBorder(),
                                                        labelStyle: TextStyle(
                                                            color: Colors
                                                                .black), // Label color
                                                        fillColor: Colors.black,
                                                        labelText: ' Cheque No',
                                                        hintText:
                                                            'Enter Cheque No',
                                                      ),
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  if (dropdownvalueService6 ==
                                                      'Cheque')
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                  if (dropdownvalueService6 ==
                                                      'Cheque')
                                                    TextFormField(
                                                      controller:
                                                          refAmountController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      decoration:
                                                          const InputDecoration(
                                                        isDense: true,
                                                        contentPadding:
                                                            EdgeInsets.all(10),
                                                        disabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .black), // Border color when disabled
                                                        ),
                                                        border:
                                                            OutlineInputBorder(),
                                                        labelStyle: TextStyle(
                                                            color: Colors
                                                                .black), // Label color
                                                        fillColor: Colors.black,
                                                        labelText:
                                                            ' Cheque Amount',
                                                        hintText:
                                                            'Enter Cheque Amount',
                                                      ),
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  if (dropdownvalueService6 ==
                                                      'Cheque')
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                  if (dropdownvalueService6 ==
                                                      'Cheque')
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 8,
                                                                  bottom: 4),
                                                          child: Text(
                                                            'Cheque Date',
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                        DateTimePicker(
                                                          controller:
                                                              dateController,
                                                          style:
                                                              const TextStyle(
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            color: Colors.black,
                                                          ),
                                                          type:
                                                              DateTimePickerType
                                                                  .date,
                                                          firstDate:
                                                              DateTime(1990),
                                                          lastDate:
                                                              DateTime.now(),
                                                          decoration:
                                                              InputDecoration(
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          11),
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Colors
                                                                    .grey
                                                                    .shade400,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          11),
                                                            ),
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          11),
                                                            ),
                                                            isDense: true,
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            hintText:
                                                                'Select Date',
                                                            labelStyle:
                                                                TextStyle(
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              color: Colors.grey
                                                                  .shade400,
                                                            ),
                                                            hintStyle:
                                                                TextStyle(
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              color: Colors.grey
                                                                  .shade400,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  if (dropdownvalueService6 ==
                                                      'Online')
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                  if (dropdownvalueService6 ==
                                                      'Online')
                                                    TextFormField(
                                                      controller:
                                                          refNumberController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      decoration:
                                                          const InputDecoration(
                                                        isDense: true,
                                                        contentPadding:
                                                            EdgeInsets.all(10),
                                                        disabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .black), // Border color when disabled
                                                        ),
                                                        border:
                                                            OutlineInputBorder(),
                                                        labelStyle: TextStyle(
                                                            color: Colors
                                                                .black), // Label color
                                                        fillColor: Colors.black,
                                                        labelText:
                                                            ' Reference No',
                                                        hintText:
                                                            'Enter Reference No',
                                                      ),
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  if (dropdownvalueService6 ==
                                                      'Online')
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                  if (dropdownvalueService6 ==
                                                      'Online')
                                                    TextFormField(
                                                      controller:
                                                          refAmountController,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          const InputDecoration(
                                                        isDense: true,
                                                        contentPadding:
                                                            EdgeInsets.all(10),
                                                        disabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .black), // Border color when disabled
                                                        ),
                                                        border:
                                                            OutlineInputBorder(),
                                                        labelStyle: TextStyle(
                                                            color: Colors
                                                                .black), // Label color
                                                        fillColor: Colors.black,
                                                        labelText: ' Amount',
                                                        hintText:
                                                            'Enter Amount',
                                                      ),
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  if (dropdownvalueService6 ==
                                                      'Online')
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                  if (dropdownvalueService6 ==
                                                      'Online')
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 8,
                                                                  bottom: 4),
                                                          child: Text(
                                                            'Transaction Date',
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                        DateTimePicker(
                                                          controller:
                                                              dateController,
                                                          style:
                                                              const TextStyle(
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            color: Colors.black,
                                                          ),
                                                          type:
                                                              DateTimePickerType
                                                                  .date,
                                                          firstDate:
                                                              DateTime(1990),
                                                          lastDate:
                                                              DateTime.now(),
                                                          decoration:
                                                              InputDecoration(
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          11),
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Colors
                                                                    .grey
                                                                    .shade400,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          11),
                                                            ),
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          11),
                                                            ),
                                                            isDense: true,
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            hintText:
                                                                'Select  Date',
                                                            labelStyle:
                                                                TextStyle(
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              color: Colors.grey
                                                                  .shade400,
                                                            ),
                                                            hintStyle:
                                                                TextStyle(
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              color: Colors.grey
                                                                  .shade400,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  if (dropdownvalueService6 ==
                                                      'Credit Card')
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                  if (dropdownvalueService6 ==
                                                      'Credit Card')
                                                    TextFormField(
                                                      controller:
                                                          refNumberController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      decoration:
                                                          const InputDecoration(
                                                        isDense: true,
                                                        contentPadding:
                                                            EdgeInsets.all(10),
                                                        disabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .black), // Border color when disabled
                                                        ),
                                                        border:
                                                            OutlineInputBorder(),
                                                        labelStyle: TextStyle(
                                                            color: Colors
                                                                .black), // Label color
                                                        fillColor: Colors.black,
                                                        labelText:
                                                            ' Txn Ref. No',
                                                        hintText:
                                                            'Enter Transaction Reference No',
                                                      ),
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  if (dropdownvalueService6 ==
                                                      'Credit Card')
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                  if (dropdownvalueService6 ==
                                                      'Credit Card')
                                                    TextFormField(
                                                      controller:
                                                          refAmountController,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          const InputDecoration(
                                                        isDense: true,
                                                        contentPadding:
                                                            EdgeInsets.all(10),
                                                        disabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .black), // Border color when disabled
                                                        ),
                                                        border:
                                                            OutlineInputBorder(),
                                                        labelStyle: TextStyle(
                                                            color: Colors
                                                                .black), // Label color
                                                        fillColor: Colors.black,
                                                        labelText:
                                                            ' Txn. Amount',
                                                        hintText:
                                                            'Enter Transaction Amount',
                                                      ),
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  if (dropdownvalueService6 ==
                                                      'Credit Card')
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                  if (dropdownvalueService6 ==
                                                      'Credit Card')
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 8,
                                                                  bottom: 4),
                                                          child: Text(
                                                            'Transaction Date',
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                        DateTimePicker(
                                                          controller:
                                                              dateController,
                                                          style:
                                                              const TextStyle(
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            color: Colors.black,
                                                          ),
                                                          type:
                                                              DateTimePickerType
                                                                  .date,
                                                          firstDate:
                                                              DateTime(1990),
                                                          lastDate:
                                                              DateTime.now(),
                                                          decoration:
                                                              InputDecoration(
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          11),
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Colors
                                                                    .grey
                                                                    .shade400,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          11),
                                                            ),
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          11),
                                                            ),
                                                            isDense: true,
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            hintText:
                                                                'Select  Date',
                                                            labelStyle:
                                                                TextStyle(
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              color: Colors.grey
                                                                  .shade400,
                                                            ),
                                                            hintStyle:
                                                                TextStyle(
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              color: Colors.grey
                                                                  .shade400,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  if (dropdownvalueService6 ==
                                                      'Debit Card')
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                  if (dropdownvalueService6 ==
                                                      'Debit Card')
                                                    TextFormField(
                                                      controller:
                                                          refNumberController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      decoration:
                                                          const InputDecoration(
                                                        isDense: true,
                                                        contentPadding:
                                                            EdgeInsets.all(10),
                                                        disabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .black), // Border color when disabled
                                                        ),
                                                        border:
                                                            OutlineInputBorder(),
                                                        labelStyle: TextStyle(
                                                            color: Colors
                                                                .black), // Label color
                                                        fillColor: Colors.black,
                                                        labelText:
                                                            ' Txn Ref. No',
                                                        hintText:
                                                            'Enter Transaction Reference No',
                                                      ),
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  if (dropdownvalueService6 ==
                                                      'Debit Card')
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                  if (dropdownvalueService6 ==
                                                      'Debit Card')
                                                    TextFormField(
                                                      controller:
                                                          refAmountController,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          const InputDecoration(
                                                        isDense: true,
                                                        contentPadding:
                                                            EdgeInsets.all(10),
                                                        disabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .black), // Border color when disabled
                                                        ),
                                                        border:
                                                            OutlineInputBorder(),
                                                        labelStyle: TextStyle(
                                                            color: Colors
                                                                .black), // Label color
                                                        fillColor: Colors.black,
                                                        labelText:
                                                            ' Txn. Amount',
                                                        hintText:
                                                            'Enter Transaction Amount',
                                                      ),
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  if (dropdownvalueService6 ==
                                                      'Debit Card')
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                  if (dropdownvalueService6 ==
                                                      'Debit Card')
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 8,
                                                                  bottom: 4),
                                                          child: Text(
                                                            'Transaction Date',
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                        DateTimePicker(
                                                          controller:
                                                              dateController,
                                                          style:
                                                              const TextStyle(
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            color: Colors.black,
                                                          ),
                                                          type:
                                                              DateTimePickerType
                                                                  .date,
                                                          firstDate:
                                                              DateTime(1990),
                                                          lastDate:
                                                              DateTime.now(),
                                                          decoration:
                                                              InputDecoration(
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          11),
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Colors
                                                                    .grey
                                                                    .shade400,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          11),
                                                            ),
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          11),
                                                            ),
                                                            isDense: true,
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            hintText:
                                                                'Select  Date',
                                                            labelStyle:
                                                                TextStyle(
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              color: Colors.grey
                                                                  .shade400,
                                                            ),
                                                            hintStyle:
                                                                TextStyle(
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              color: Colors.grey
                                                                  .shade400,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Visibility(
                                              visible: isVisible,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8, bottom: 4),
                                                    child: Text(
                                                      'Pay Date',
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                  DateTimePicker(
                                                    controller:
                                                        payDateController,
                                                    style: const TextStyle(
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      color: Colors.black,
                                                    ),
                                                    type:
                                                        DateTimePickerType.date,
                                                    firstDate: DateTime(1990),
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
                                                      isDense: true,
                                                      contentPadding:
                                                          EdgeInsets.all(10),
                                                      hintText:
                                                          'Select Pay Date',
                                                      labelStyle: TextStyle(
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        color: Colors
                                                            .grey.shade400,
                                                      ),
                                                      hintStyle: TextStyle(
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        color: Colors
                                                            .grey.shade400,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Visibility(
                                              visible: isVisible,
                                              child: TextFormField(
                                                controller: remarkController,
                                                minLines: 2,
                                                maxLines: 7,
                                                keyboardType:
                                                    TextInputType.multiline,
                                                decoration:
                                                    const InputDecoration(
                                                  disabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .black), // Border color when disabled
                                                  ),
                                                  border: OutlineInputBorder(),
                                                  labelStyle: TextStyle(
                                                      color: Colors
                                                          .black), // Label color
                                                  fillColor: Colors.black,
                                                  labelText: ' Remark',
                                                  hintText: 'Enter  Remark',
                                                ),
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            Visibility(
                                              visible: isVisible,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                                                  bottom: 9.0),
                                                          child: Text(
                                                            'Submit',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          String stContent = '';
                                                          for (int i = 0;
                                                              i <
                                                                  stuDueList
                                                                      .length;
                                                              i++) {
                                                            stContent += feeId[
                                                                        i]
                                                                    .text
                                                                    .trim() +
                                                                "~" +
                                                                paidAmountController[
                                                                        i]
                                                                    .text
                                                                    .trim() +
                                                                "|";
                                                          }
                                                          if (dropdownvalueService4 ==
                                                              'Select Degree') {
                                                            AppUtil.showToast(
                                                                "Please select degree first",
                                                                'e');
                                                          } else if (dropdownvalueService2 ==
                                                              'Select Course') {
                                                            AppUtil.showToast(
                                                                "Please select course first",
                                                                'e');
                                                          } else if (dropdownvalueService3 ==
                                                              'Select Year') {
                                                            AppUtil.showToast(
                                                                "Please select year first",
                                                                'e');
                                                          } else if (dropdownvalueService ==
                                                              'Select Session') {
                                                            AppUtil.showToast(
                                                                "Please select session first",
                                                                'e');
                                                          } else if (dropdownvalueService5 ==
                                                              'Select Student') {
                                                            AppUtil.showToast(
                                                                "Please select student first",
                                                                'e');
                                                          } else if (dropdownvalueService6 ==
                                                              'Select Pay Mode') {
                                                            AppUtil.showToast(
                                                                "Please select pay mode",
                                                                'e');
                                                          } else if (dropdownvalueService6 ==
                                                              'Select Pay Mode') {
                                                            AppUtil.showToast(
                                                                "Please select pay mode",
                                                                'e');
                                                          } else if (payDateController
                                                              .text.isEmpty) {
                                                            AppUtil.showToast(
                                                                "Please select pay date",
                                                                'e');
                                                          } else {
                                                            setState(() {
                                                              isLoading = true;
                                                            });
                                                            addCollectionRequest
                                                                .type = 'add';
                                                            addCollectionRequest
                                                                    .degree =
                                                                degreeId
                                                                    .toString();
                                                            addCollectionRequest
                                                                    .course =
                                                                courseId
                                                                    .toString();
                                                            addCollectionRequest
                                                                    .year =
                                                                yearId
                                                                    .toString();
                                                            addCollectionRequest
                                                                    .session =
                                                                sessionId
                                                                    .toString();
                                                            addCollectionRequest
                                                                    .student =
                                                                stuId
                                                                    .toString();
                                                            addCollectionRequest
                                                                    .feeData =
                                                                stContent;

                                                            addCollectionRequest
                                                                    .total =
                                                                totalController
                                                                    .text;
                                                            addCollectionRequest
                                                                    .totalPaid =
                                                                paidController
                                                                    .text;
                                                            addCollectionRequest
                                                                    .due =
                                                                dueController
                                                                    .text;
                                                            addCollectionRequest
                                                                    .payMode =
                                                                dropdownvalueService6
                                                                    .toString();
                                                            addCollectionRequest
                                                                    .refNo =
                                                                refNumberController
                                                                    .text;
                                                            addCollectionRequest
                                                                    .refAmount =
                                                                refAmountController
                                                                    .text;
                                                            addCollectionRequest
                                                                    .refDate =
                                                                dateController
                                                                    .text;
                                                            addCollectionRequest
                                                                    .payDate =
                                                                payDateController
                                                                    .text;
                                                            addCollectionRequest
                                                                    .remark =
                                                                remarkController
                                                                    .text;

                                                            _service
                                                                .feeCollect(
                                                                    addCollectionRequest)
                                                                .then((value) {
                                                              collectionResponse =
                                                                  value;
                                                              if (collectionResponse
                                                                      .error ==
                                                                  false) {
                                                                setState(() {
                                                                  isLoading =
                                                                      false;
                                                                });
                                                                AppUtil.showToast(
                                                                    collectionResponse
                                                                        .msg
                                                                        .toString(),
                                                                    's');
                                                                Navigator
                                                                    .pushReplacementNamed(
                                                                        context,
                                                                        '/feeCollection');
                                                              } else {}
                                                              setState(() {
                                                                isLoading =
                                                                    false;
                                                                AppUtil.showToast(
                                                                    collectionResponse
                                                                        .msg
                                                                        .toString(),
                                                                    's');
                                                              });
                                                            });
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    Visibility(
                                                      visible: isVisible,
                                                      child: SizedBox(
                                                        height: 35,
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: isVisible,
                                                      child: Text(
                                                        "Receipts",
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: isVisible,
                                                      child: SizedBox(
                                                        height: 35,
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: isVisible,
                                                      child:
                                                          SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: DataTable(
                                                          headingRowColor: WidgetStateColor
                                                              .resolveWith((states) =>
                                                                  Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                          showBottomBorder:
                                                              true,
                                                          border:
                                                              TableBorder.all(
                                                                  width: 1),
                                                          headingTextStyle:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                          columns:
                                                              _underCreateColums(),
                                                          rows:
                                                              _underCreateRows(),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox()),
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

  void _updateTotals() {
    int totalPaid = 0;
    int totalDue = 0;

    for (int i = 0; i < stuDueList.length; i++) {
      int newPaidAmount = int.tryParse(paidAmountController[i].text) ?? 0;
      int oldPaidAmount = int.tryParse(oldAmountController[i].text) ?? 0;
      int totalAmount = int.tryParse(amountController[i].text) ?? 0;

      totalPaid += (newPaidAmount + oldPaidAmount);

      totalDue += (totalAmount - (newPaidAmount + oldPaidAmount));
    }

    setState(() {
      paidController.text = totalPaid.toString();
      dueController.text = totalDue.toString();
    });
  }

  List<DataColumn> _underCreateColums() {
    return const [
      DataColumn(
          label: Center(
              child: Text(
        'Date',
        style: TextStyle(color: Colors.white),
      ))),
      DataColumn(
          label: Center(
              child: Text(
        'Receipt No',
        style: TextStyle(color: Colors.white),
      ))),
      DataColumn(
          label: Center(
              child: Text(
        'Amount',
        style: TextStyle(color: Colors.white),
      ))),
      DataColumn(
          label: Center(
              child: Text(
        'Pay Mode',
        style: TextStyle(color: Colors.white),
      ))),
      DataColumn(
          label: SizedBox(
              width: 75,
              child: Center(
                  child: Text(
                'Action',
                style: TextStyle(color: Colors.white),
              )))),
    ];
  }

  List<DataRow> _underCreateRows() {
    if (invList.isEmpty) {
      return List.generate(1, (index) {
        return const DataRow(cells: [
          DataCell(Center(
            child: Text(
              '-',
              textAlign: TextAlign.center,
            ),
          )),
          DataCell(Center(
            child: Text(
              '-',
              textAlign: TextAlign.center,
            ),
          )),
          DataCell(Center(
            child: Text(
              '-',
              textAlign: TextAlign.center,
            ),
          )),
          DataCell(Center(
            child: Text(
              '-',
              textAlign: TextAlign.center,
            ),
          )),
          DataCell(SizedBox(
            width: 75,
            child: Center(
              child: Text('-'),
            ),
          )),
        ]);
      });
    } else {
      return List.generate(invList.length, (index) {
        return DataRow(cells: [
          DataCell(Center(
            child: Text(
              invList[index].payDate!,
              textAlign: TextAlign.center,
            ),
          )),
          DataCell(Center(
            child: Text(
              invList[index].receiptNo!,
              textAlign: TextAlign.center,
            ),
          )),
          DataCell(Center(
            child: Text(
              invList[index].payType!,
              textAlign: TextAlign.center,
            ),
          )),
          DataCell(Center(
            child: Text(
              invList[index].paid!,
              textAlign: TextAlign.center,
            ),
          )),
          DataCell(SizedBox(
            width: 75,
            child: Center(
              child: IconButton(
                tooltip: "Print " + invList[index].receiptNo!,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/invoiceView',
                    arguments: {
                      'receipt': invList[index].receiptNo!,
                    },
                  );
                },
                icon: const Icon(
                  Icons.print,
                  size: 30,
                  color: Colors.green,
                ),
              ),
            ),
          )),
        ]);
      });
    }
  }
}
