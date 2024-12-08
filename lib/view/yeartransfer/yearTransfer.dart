import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gims/Api/AppCommonVariable.dart';
import 'package:gims/api/webService.dart';
import 'package:gims/controllers/appUtil.dart';
import 'package:gims/model/Request/addCollectionRequest.dart';
import 'package:gims/model/Request/addDegreeRequest.dart';
import 'package:gims/model/Request/courseFilterRequest.dart';
import 'package:gims/model/Request/sessionRequest.dart';
import 'package:gims/model/Request/simpleRequest.dart';
import 'package:gims/model/Request/stuDueRequest.dart';
import 'package:gims/model/Request/studentFilterRequest.dart';
import 'package:gims/model/Request/studentListRequest.dart';
import 'package:gims/model/Request/transferYearRequest.dart';
import 'package:gims/model/Request/yearRequest.dart';
import 'package:gims/model/Response/SimpleResponse.dart';
import 'package:gims/model/Response/collectionResponse.dart';
import 'package:gims/model/Response/courseResponse.dart';
import 'package:gims/model/Response/degreeResponse.dart';
import 'package:gims/model/Response/invoiceResponse.dart';
import 'package:gims/model/Response/sessionResponse.dart';
import 'package:gims/model/Response/stuDueResponse.dart';
import 'package:gims/model/Response/studentListResponse.dart';
import 'package:gims/model/Response/yearResponse.dart';
import 'package:gims/responsive.dart';
import 'package:gims/view/home/sidebar.dart';

class YearTransfer extends StatefulWidget {
  const YearTransfer({super.key});

  @override
  State<YearTransfer> createState() => _YearTransferState();
}

class _YearTransferState extends State<YearTransfer> {
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

  List<String> items7 = ['Select Promotion Year'];
  String? dropdownvalueService7 = 'Select Promotion Year';
  String promotionId = '';
  List<String> filteredItems7 = [];
  List promotionList = [];

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
  StudentListsRequest studentListsRequest = StudentListsRequest("", "", "");
  StudentListResponse studentListResponse = StudentListResponse();
  StuDueResponse stuDueResponse = StuDueResponse();
  InvoiceResponse invoiceResponse = InvoiceResponse();

  SimpleModel simpleModel = SimpleModel("");

  final Webservice _service = Webservice();

  List StuList = [];
  bool value = false;

  List<String> userChecked = [];

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
    } else if (permissions.contains('year_transfer')) {
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
                    'Year Transfer',
                    style: TextStyle(color: Colors.white),
                  )
                : const Text(
                    'Year Transfer',
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
                                child: permissions.contains('year_transfer')
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
                                                    StuList.clear();
                                                    items.clear();
                                                    items.add("Select Session");

                                                    items2.clear();
                                                    items2.add("Select Course");
                                                    items3.clear();
                                                    items3.add("Select Year");
                                                    items7.clear();
                                                    items7.add(
                                                        "Select Promotion Year");

                                                    sessionId = '';
                                                    courseId = '';
                                                    yearId = '';
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
                                                  StuList.clear();
                                                  items.clear();
                                                  items.add("Select Session");

                                                  items3.clear();
                                                  items3.add("Select Year");
                                                  items7.clear();
                                                  items7.add(
                                                      "Select Promotion Year");
                                                  sessionId = '';
                                                  courseId = '';
                                                  yearId = '';
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

                                                      items7.clear();

                                                      items7.add(
                                                          'Select Promotion Year');
                                                      dropdownvalueService7 =
                                                          items7[
                                                              0]; // Reset dropdown
                                                      yearList.forEach((year) {
                                                        items7.add(
                                                            year.subCourse);
                                                      });

                                                      filteredItems7 =
                                                          List.from(items7);
                                                    } else {
                                                      items3.clear();

                                                      items3.add('Select Year');
                                                      items4.clear();

                                                      items3.add(
                                                          'Select Promotion Year');
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
                                                  StuList.clear();
                                                  sessionId = '';
                                                  yearId = '';
                                                  dropdownvalueService3 =
                                                      newValue!;
                                                  String selectedYearId =
                                                      yearList
                                                          .firstWhere((year) =>
                                                              year.subCourse ==
                                                              newValue)
                                                          .id;
                                                  updatePromotionList(
                                                      selectedYearId);

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
                                                  filteredItems7 = items7
                                                      .where((item) =>
                                                          item != newValue)
                                                      .toList();
                                                  if (!filteredItems7.contains(
                                                      dropdownvalueService7)) {
                                                    dropdownvalueService7 =
                                                        null;
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
                                                labelText: "Promotion Year",
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(6)),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade500),
                                                ),
                                              ),
                                              value: dropdownvalueService7 !=
                                                          null &&
                                                      filteredItems7.contains(
                                                          dropdownvalueService7)
                                                  ? dropdownvalueService7
                                                  : (filteredItems7.isNotEmpty
                                                      ? filteredItems7[0]
                                                      : null),
                                              icon: const Icon(
                                                  Icons.keyboard_arrow_down),
                                              items: filteredItems7
                                                  .map((String item) {
                                                return DropdownMenuItem(
                                                  value: item,
                                                  child: Text(item),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  dropdownvalueService7 =
                                                      newValue!;
                                                  promotionId = promotionList[
                                                          filteredItems7.indexOf(
                                                                  newValue) -
                                                              1]
                                                      .id
                                                      .toString();
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
                                                  StuList.clear();
                                                  sessionId = '';
                                                  isLoading = true;
                                                  dropdownvalueService =
                                                      newValue!;
                                                  sessionId = sessionList[
                                                          items.indexOf(
                                                                  newValue) -
                                                              1]
                                                      .id
                                                      .toString();

                                                  _getStudent(courseId, yearId,
                                                      sessionId);
                                                });
                                              },
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            if (StuList.isNotEmpty)
                                              Text(
                                                "Select Students",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            if (StuList.isNotEmpty)
                                              ListView.builder(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 00,
                                                          right: 00,
                                                          top: 00,
                                                          bottom: 00),
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemCount: StuList.length,
                                                  itemBuilder:
                                                      (BuildContext ctx,
                                                          int i) {
                                                    return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(6.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Expanded(
                                                              flex: 3,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Text(
                                                                    StuList[i]
                                                                        .name
                                                                        .toString()),
                                                              ),
                                                            ),
                                                            Expanded(
                                                                flex: 1,
                                                                child: Checkbox(
                                                                  value: userChecked
                                                                      .contains(
                                                                          StuList[i]
                                                                              .id),
                                                                  onChanged:
                                                                      (val) {
                                                                    _onSelected(
                                                                        val!,
                                                                        StuList[i]
                                                                            .id);
                                                                  },
                                                                ) //Ch,
                                                                ),
                                                          ],
                                                        ));
                                                  }),
                                            if (StuList.isNotEmpty)
                                              const Divider(
                                                color: Color.fromARGB(
                                                    197, 45, 59, 162),
                                                thickness: 2,
                                              ),
                                            if (StuList.isNotEmpty)
                                              SizedBox(
                                                height: 20,
                                              ),
                                            if (StuList.isNotEmpty)
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          197, 45, 59, 162),
                                                  shadowColor:
                                                      const Color.fromARGB(
                                                          198, 71, 49, 50),
                                                ),
                                                onPressed: () {
                                                  if (degreeId == '') {
                                                    AppUtil.showToast(
                                                        'Please Select Degree',
                                                        'e');
                                                  } else if (courseId == '') {
                                                    AppUtil.showToast(
                                                        'Please Select Course',
                                                        'e');
                                                  } else if (yearId == '') {
                                                    AppUtil.showToast(
                                                        'Please Select Year',
                                                        'e');
                                                  } else if (dropdownvalueService7 ==
                                                      'Select Promotion Year') {
                                                    AppUtil.showToast(
                                                        'Please Select Promotion Year',
                                                        'e');
                                                  } else if (sessionId == '') {
                                                    AppUtil.showToast(
                                                        'Please Select Session',
                                                        'e');
                                                  } else if (userChecked
                                                          .length ==
                                                      0) {
                                                    AppUtil.showToast(
                                                        'Please Select Student',
                                                        'e');
                                                  } else {
                                                    TransferYearRequest
                                                        transferYearRequest =
                                                        TransferYearRequest(
                                                            "", "", "", "", "");

                                                    String stContent = '';
                                                    for (int i = 0;
                                                        i < userChecked.length;
                                                        i++) {
                                                      stContent +=
                                                          userChecked[i] + ',';
                                                    }

                                                    print(stContent);

                                                    transferYearRequest.course =
                                                        courseId;
                                                    transferYearRequest.year =
                                                        yearId;
                                                    transferYearRequest
                                                            .newYear =
                                                        promotionId.toString();
                                                    transferYearRequest
                                                        .session = sessionId;
                                                    transferYearRequest
                                                        .stuList = stContent;

                                                    setState(() {
                                                      isLoading = true;
                                                    });

                                                    _service
                                                        .transferYear(
                                                            transferYearRequest)
                                                        .then((value) async {
                                                      addResponse = value;
                                                      setState(() {
                                                        isLoading = false;
                                                        AppUtil.showToast(
                                                            addResponse.msg
                                                                .toString(),
                                                            's');
                                                        Navigator
                                                            .pushReplacementNamed(
                                                                context,
                                                                '/yearTransfer');
                                                      });
                                                    });
                                                  }
                                                },
                                                child: const Center(
                                                  child: Text(
                                                    'Transfer Students',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Color(0xffffffff),
                                                      letterSpacing:
                                                          -0.3858822937011719,
                                                    ),
                                                    textAlign: TextAlign.center,
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

  void _getStudent(
    course,
    subcourse,
    session,
  ) {
    setState(() {
      isLoading = true;
    });
    studentListsRequest.course = course;
    studentListsRequest.year = subcourse;
    studentListsRequest.session = session;

    _service.studentListApi(studentListsRequest).then((value) async {
      studentListResponse = value;
      setState(() {
        StuList = studentListResponse.data!;
        isLoading = false;
        AppUtil.showToast(studentListResponse.msg.toString(), 's');
      });
    });
  }

  void _onSelected(bool selected, String dataName) {
    if (selected == true) {
      setState(() {
        userChecked.add(dataName);
      });
    } else {
      setState(() {
        userChecked.remove(dataName);
      });
    }
  }

  void updatePromotionList(String selectedYearId) {
    promotionList =
        yearList.where((year) => year.id != selectedYearId).toList();
  }
}
