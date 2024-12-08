import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gims/api/appCommonVariable.dart';
import 'package:gims/model/Request/courseFilterRequest.dart';
import 'package:gims/model/Request/deleteCollectionRequest.dart';
import 'package:gims/model/Request/feePendingRequest.dart';
import 'package:gims/model/Request/sessionRequest.dart';
import 'package:gims/model/Request/yearRequest.dart';
import 'package:gims/model/Response/SimpleResponse.dart';
import 'package:gims/model/Response/courseResponse.dart';
import 'package:gims/model/Response/degreeResponse.dart';
import 'package:gims/model/Response/feePendingReportResponse.dart';
import 'package:gims/model/Response/sessionResponse.dart';
import 'package:gims/model/Response/yearResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gims/api/webService.dart';
import 'package:gims/controllers/AppUtil.dart';
import 'package:gims/model/Request/simpleRequest.dart';
import 'package:gims/responsive.dart';
import 'package:gims/view/home/sidebar.dart';

class FeePendingReport extends StatefulWidget {
  const FeePendingReport({super.key});

  @override
  State<FeePendingReport> createState() => _FeePendingReportState();
}

class _FeePendingReportState extends State<FeePendingReport> {
  int crocesscount = 0;
  double childAspect = 0.00;
  bool babkbutton = false;
  bool isLoading = false;
  TextEditingController controllerSearch = TextEditingController();
  List pendingList = [];
  List pendingFiltered = [];
  String _searchResult = '';
  bool searching = false;
  TextEditingController _searchController = TextEditingController();
  final Webservice _service = Webservice();
  SimpleModel simpleRequest = SimpleModel("");
  DegreeResponse degreeResponse = DegreeResponse();
  DeleteCollectionRequest deleteCollectionRequest =
      DeleteCollectionRequest("", "");
  SimpleResponse simpleResponse = SimpleResponse();
  FeePendingReportResponse feePendingReportResponse =
      FeePendingReportResponse();
  FeePendingRequest feePendingRequest = FeePendingRequest("", "", "", "");
  String permissions = '';

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
  SimpleModel degreeRequest = SimpleModel("");
  CourseFilterRequest courseFilterRequest = CourseFilterRequest("", "");
  CourseResponse courseResponse = CourseResponse();
  YearRequest yearRequest = YearRequest("", "");
  SessionRequest sessionRequest = SessionRequest("", "");
  YearResponse yearResponse = YearResponse();
  SessionResponse sessionResponse = SessionResponse();
  @override
  void initState() {
    super.initState();

    isLoading = true;

    SharedPreferences.getInstance().then((SharedPreferences sp) {
      permissions = sp.getString(PERMISSIONS)!;

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

      feePendingRequest.type = 'view';
      _service.pendingFee(feePendingRequest).then((value) {
        feePendingReportResponse = value;
        if (value.error == false) {
          setState(() {
            pendingList = feePendingReportResponse.data!;
            pendingFiltered = pendingList;
            isLoading = false;
          });
        } else {
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
    } else if (permissions.contains('fee_pending_report')) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            actions: [
              if (searching == false)
                IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                      semanticLabel: 'Search Students',
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
                        style: TextStyle(color: Colors.white, fontSize: 21),
                        cursorColor: Colors.white,
                        controller: _searchController,
                        decoration: new InputDecoration(
                          hintText: 'Search Students',
                          hintStyle: TextStyle(color: Colors.white),

                          // Add a clear button to the search bar
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _searchController =
                                    TextEditingController(text: '');
                                searching = false;
                                _searchResult = '';
                                pendingFiltered = pendingList;
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

                            pendingFiltered = pendingList
                                .where((pendingList) =>
                                    pendingList.sessionName
                                        .toLowerCase()
                                        .contains(
                                            _searchResult.toLowerCase()) ||
                                    pendingList.stuName.toLowerCase().contains(
                                        _searchResult.toLowerCase()) ||
                                    pendingList.stuMobile
                                        .toLowerCase()
                                        .contains(
                                            _searchResult.toLowerCase()) ||
                                    pendingList.courseName
                                        .toLowerCase()
                                        .contains(
                                            _searchResult.toLowerCase()) ||
                                    pendingList.year
                                        .toLowerCase()
                                        .contains(_searchResult.toLowerCase()))
                                .toList();
                          });
                        }),
                  )
                : Responsive.isDesktop(context)
                    ? const Text(
                        'Fee Pending Report',
                        style: TextStyle(color: Colors.white),
                      )
                    : const Text(
                        'Fee Pending Report',
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
                            : pendingFiltered.isNotEmpty
                                ? Container(
                                    padding: EdgeInsets.all(5.0),
                                    child: DynamicHeightGridView(
                                      itemCount: pendingFiltered.length,
                                      builder: (ctx, index) {
                                        return Card(
                                            elevation: 2,
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: const Color.fromARGB(
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
                                                const SizedBox(
                                                  height: 10,
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
                                                              "Student Name",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                          Text(
                                                              pendingFiltered[
                                                                      index]
                                                                  .stuName!,
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
                                                              "Mobile Number",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                          Text(
                                                              pendingFiltered[
                                                                      index]
                                                                  .stuMobile!,
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
                                                          const Text("Course",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                          Text(
                                                              pendingFiltered[
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
                                                              pendingFiltered[
                                                                      index]
                                                                  .year!,
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
                                                Row(
                                                  children: [
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
                                                              pendingFiltered[
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
                                                    Expanded(
                                                      flex: 1,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text("Amount",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                          Text(
                                                              pendingFiltered[
                                                                      index]
                                                                  .amount!,
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
                                                              "Final Amount",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                          Text(
                                                              pendingFiltered[
                                                                      index]
                                                                  .famount!,
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
                                                          const Text("Paid",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                          Text(
                                                              pendingFiltered[
                                                                      index]
                                                                  .paid!,
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
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text("Due",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                          Text(
                                                              pendingFiltered[
                                                                      index]
                                                                  .due!,
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

  void showMyDialog(String title, String content, String btnPositive,
      String btnNegative, bool cancelable, String id, String id2) {
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
                                callApiToDeleteOrganisation(id, id2);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: new BorderRadius.all(
                                        const Radius.circular(5))),
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
                                decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: new BorderRadius.all(
                                        const Radius.circular(5))),
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

  callApiToDeleteOrganisation(String id, String id2) {
    setState(() {
      isLoading = true;
    });
    deleteCollectionRequest.receipt = id;
    deleteCollectionRequest.advanceFeeId = id2;

    _service.deleteCollection(deleteCollectionRequest).then((value) {
      simpleResponse = value;

      setState(() {
        if (simpleResponse.error == false) {
          isLoading = false;
          AppUtil.showToast(simpleResponse.msg.toString(), "e");
          Navigator.pushNamed(
            context,
            '/feeCollectionReport',
          );
        } else {
          AppUtil.showToast("Internal Server Error", "e");
        }
      });
    });
  }

  void showMyDialog2() {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 400),
      context: context,
      pageBuilder: (_, __, ___) {
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
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
                              labelText: "Degree",
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(6))),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade500),
                              ),
                            ),
                            value: dropdownvalueService4 ?? items4[0],
                            icon: const Icon(Icons.keyboard_arrow_down),
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
                                  isLoading = true;
                                  dropdownvalueService4 = newValue!;
                                  degreeId =
                                      degreeList[items4.indexOf(newValue) - 1]
                                          .id
                                          .toString();
                                  items2.clear();
                                  items2.add("Select Course");

                                  courseFilterRequest.type = 'view';
                                  courseFilterRequest.degree =
                                      degreeId.toString();
                                  _service
                                      .courseManageFilter(courseFilterRequest)
                                      .then((value) {
                                    courseResponse = value;
                                    if (courseResponse.error == false) {
                                      courseList = courseResponse.data!;
                                      List.generate(courseList.length, (index) {
                                        items2.add(courseList[index].name);
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
                          const SizedBox(
                            height: 25,
                          ),
                          DropdownButtonFormField(
                            isExpanded: true,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              labelText: "Course",
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(6))),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade500),
                              ),
                            ),
                            // Ensure the selected value exists in the list or set a fallback if null
                            value: dropdownvalueService2 != null &&
                                    items2.contains(dropdownvalueService2)
                                ? dropdownvalueService2
                                : (items2.isNotEmpty ? items2[0] : null),
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: items2.map((String item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                isLoading = true;
                                courseYear = '';
                                dropdownvalueService2 = newValue!;
                                int index = items2.indexOf(newValue);
                                if (index >= 0 && index <= courseList.length) {
                                  courseId =
                                      courseList[items2.indexOf(newValue) - 1]
                                          .id
                                          .toString();
                                  courseYear =
                                      courseList[items2.indexOf(newValue) - 1]
                                          .year
                                          .toString();
                                }

                                yearRequest.type = 'view';
                                yearRequest.course = courseId;
                                _service.yearFilter(yearRequest).then((value) {
                                  yearResponse = value;
                                  if (yearResponse.error == false) {
                                    yearList = yearResponse.data!;
                                    items3.clear();

                                    items3.add('Select Year');
                                    dropdownvalueService3 =
                                        items3[0]; // Reset dropdown
                                    yearList.forEach((year) {
                                      items3.add(year.subCourse);
                                    });
                                  } else {
                                    items3.clear();

                                    items3.add('Select Year');
                                    dropdownvalueService3 =
                                        items3[0]; // Reset dropdown
                                  }
                                });

                                sessionRequest.type = 'view';
                                sessionRequest.year = courseYear;
                                _service
                                    .sessionFilter(sessionRequest)
                                    .then((value) {
                                  sessionResponse = value;
                                  if (sessionResponse.error == false) {
                                    sessionList = sessionResponse.data!;
                                    items.clear();

                                    items.add('Select Session');
                                    dropdownvalueService =
                                        items[0]; // Reset dropdown
                                    sessionList.forEach((session) {
                                      items.add(session.session);
                                    });
                                    setState(() {
                                      isLoading = false;
                                    });
                                  } else {
                                    setState(() {
                                      items.clear();

                                      items.add('Select Session');
                                      dropdownvalueService =
                                          items[0]; // Reset dropdown
                                      isLoading = false;
                                    });
                                  }
                                });
                              });
                            },
                          ),
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(6))),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade500),
                              ),
                            ),
                            value: dropdownvalueService3 != null &&
                                    items3.contains(dropdownvalueService3)
                                ? dropdownvalueService3
                                : (items3.isNotEmpty ? items3[0] : null),
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: items3.map((String item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownvalueService3 = newValue!;
                                int index = items3.indexOf(newValue);
                                if (index >= 0 && index <= yearList.length) {
                                  yearId =
                                      yearList[items3.indexOf(newValue) - 1]
                                          .id
                                          .toString();
                                }
                              });
                            },
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          DropdownButtonFormField(
                            isExpanded: true,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              labelText: "Session",
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(6))),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade500),
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
                                sessionId =
                                    sessionList[items.indexOf(newValue) - 1]
                                        .id
                                        .toString();
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
                                      pendingList.clear();
                                      pendingFiltered.clear();
                                    });

                                    feePendingRequest.type = 'view';
                                    if (courseId.isNotEmpty) {
                                      feePendingRequest.course = courseId;
                                    }
                                    if (yearId.isNotEmpty) {
                                      feePendingRequest.year = yearId;
                                    }
                                    if (sessionId.isNotEmpty) {
                                      feePendingRequest.session = sessionId;
                                    }
                                    _service
                                        .pendingFee(feePendingRequest)
                                        .then((value) {
                                      feePendingReportResponse = value;
                                      if (value.error == false) {
                                        setState(() {
                                          pendingList =
                                              feePendingReportResponse.data!;
                                          pendingFiltered = pendingList;
                                          isLoading = false;
                                          Navigator.pop(context);
                                        });
                                      } else {
                                        setState(() {
                                          isLoading = false;
                                          Navigator.pop(context);
                                        });
                                      }
                                    });
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
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
}
