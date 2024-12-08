import 'dart:io';

import 'package:csv/csv.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gims/api/appCommonVariable.dart';
import 'package:gims/api/webService.dart';
import 'package:gims/controllers/AppUtil.dart';
import 'package:gims/model/Request/deleteCollectionRequest.dart';
import 'package:gims/model/Request/feeCollectionReportRequest.dart';
import 'package:gims/model/Request/simpleRequest.dart';
import 'package:gims/model/Response/SimpleResponse.dart';
import 'package:gims/model/Response/degreeResponse.dart';
import 'package:gims/model/Response/feeCollectionReportResponse.dart';
import 'package:gims/responsive.dart';
import 'package:gims/view/home/sidebar.dart';

class FeeCollectionReport extends StatefulWidget {
  const FeeCollectionReport({super.key});

  @override
  State<FeeCollectionReport> createState() => _FeeCollectionReportState();
}

class _FeeCollectionReportState extends State<FeeCollectionReport> {
  int crocesscount = 0;
  double childAspect = 0.00;
  bool babkbutton = false;
  bool isLoading = false;
  TextEditingController controllerSearch = TextEditingController();
  List degreeList = [];
  List degreeFiltered = [];
  String _searchResult = '';
  bool searching = false;
  TextEditingController _searchController = TextEditingController();
  final Webservice _service = Webservice();
  SimpleModel simpleRequest = SimpleModel("");
  DegreeResponse degreeResponse = DegreeResponse();
  DeleteCollectionRequest deleteCollectionRequest =
      DeleteCollectionRequest("", "");
  SimpleResponse simpleResponse = SimpleResponse();
  FeeCollectionReportResponse feeCollectionReportResponse =
      FeeCollectionReportResponse();
  FeeCollectionReportRequest feeCollectionReportRequest =
      FeeCollectionReportRequest("", "");
  String permissions = '';
  @override
  void initState() {
    super.initState();

    isLoading = true;

    SharedPreferences.getInstance().then((SharedPreferences sp) {
      permissions = sp.getString(PERMISSIONS)!;
      feeCollectionReportRequest.type = 'view';

      _service.feeCollectReport(feeCollectionReportRequest).then((value) {
        feeCollectionReportResponse = value;

        if (value.error == false) {
          setState(() {
            degreeList = feeCollectionReportResponse.data!;
            degreeFiltered = degreeList;
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
    } else if (permissions.contains('fee_collection_report')) {
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
                      semanticLabel: 'Search Collection',
                    ),
                    onPressed: () {
                      setState(() {
                        searching = true;
                      });
                    }),
              IconButton(
                  icon: const Icon(
                    Icons.file_download,
                    color: Colors.white,
                    semanticLabel: 'Export Excel',
                  ),
                  onPressed: () {
                    exportData();
                  }),
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
                          hintText: 'Search Collection',
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
                                degreeFiltered = degreeList;
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

                            degreeFiltered = degreeList
                                .where((degreeList) =>
                                    degreeList.pay_date.toLowerCase().contains(
                                        _searchResult.toLowerCase()) ||
                                    degreeList.stuName.toLowerCase().contains(
                                        _searchResult.toLowerCase()) ||
                                    degreeList.receipt_no
                                        .toLowerCase()
                                        .contains(
                                            _searchResult.toLowerCase()) ||
                                    degreeList.amount.toLowerCase().contains(
                                        _searchResult.toLowerCase()) ||
                                    degreeList.pay_type
                                        .toLowerCase()
                                        .contains(_searchResult.toLowerCase()))
                                .toList();
                          });
                        }),
                  )
                : Responsive.isDesktop(context)
                    ? const Text(
                        'Fee Collection Report',
                        style: TextStyle(color: Colors.white),
                      )
                    : const Text(
                        'Fee Collection Report',
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
                            : degreeFiltered.isNotEmpty
                                ? Container(
                                    padding: EdgeInsets.all(5.0),
                                    child: DynamicHeightGridView(
                                      itemCount: degreeFiltered.length,
                                      builder: (ctx, index) {
                                        return Card(
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
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text("Date",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                          Text(
                                                              degreeFiltered[
                                                                      index]
                                                                  .pay_date!,
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
                                                              "Receipt No",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                          Text(
                                                              degreeFiltered[
                                                                      index]
                                                                  .receipt_no!,
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
                                                              degreeFiltered[
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
                                                          const Text("Session",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                          Text(
                                                              degreeFiltered[
                                                                      index]
                                                                  .session!,
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
                                                          const Text("Course",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                          Text(
                                                              degreeFiltered[
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
                                                              degreeFiltered[
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
                                                          const Text("Amount",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                          Text(
                                                              degreeFiltered[
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
                                                              degreeFiltered[
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
                                                          const Text("Pay Type",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                          Text(
                                                              degreeFiltered[
                                                                      index]
                                                                  .pay_type!,
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
                                                /*3rd*/
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          if (permissions.contains(
                                                              'print_receipt_report'))
                                                            Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        4.0),
                                                                child:
                                                                    IconButton(
                                                                  tooltip: "Print Receipt " +
                                                                      degreeFiltered[
                                                                              index]
                                                                          .receipt_no
                                                                          .toString(),
                                                                  icon:
                                                                      const Icon(
                                                                    Icons.print,
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator
                                                                        .pushNamed(
                                                                      context,
                                                                      '/invoiceView',
                                                                      arguments: {
                                                                        'receipt': degreeFiltered[index]
                                                                            .receipt_no
                                                                            .toString(),
                                                                      },
                                                                    );
                                                                  },
                                                                )),
                                                          if (permissions.contains(
                                                              'delete_print_receipt_report'))
                                                            Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        4.0),
                                                                child:
                                                                    IconButton(
                                                                  tooltip: "Delete " +
                                                                      degreeFiltered[
                                                                              index]
                                                                          .receipt_no
                                                                          .toString(),
                                                                  icon:
                                                                      const Icon(
                                                                    Icons
                                                                        .delete,
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    showMyDialog(
                                                                        "Delete Receipt?",
                                                                        "Alert! Are you sure you want to delete the receipt ." +
                                                                            degreeFiltered[index]
                                                                                .receipt_no
                                                                                .toString(),
                                                                        "Yes",
                                                                        "No",
                                                                        true,
                                                                        degreeFiltered[index]
                                                                            .receipt_no,
                                                                        degreeFiltered[index]
                                                                            .advance_fid);
                                                                  },
                                                                )),
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

  void exportData() async {
    try {
      int icount = 0;
      List<List<dynamic>> data = [
        [
          'S.N.',
          'Date',
          'Receipt No',
          'Student Name',
          'Session',
          'Course',
          'Year',
          'Amount',
          'Paid',
          'Pay Type'
        ],
        for (icount = 0; icount < degreeFiltered.length; icount++)
          [
            icount + 1,
            degreeFiltered[icount].pay_date.toString(),
            degreeFiltered[icount].receipt_no.toString(),
            degreeFiltered[icount].stuName.toString(),
            degreeFiltered[icount].session.toString(),
            degreeFiltered[icount].courseName.toString(),
            degreeFiltered[icount].year.toString(),
            degreeFiltered[icount].amount.toString(),
            degreeFiltered[icount].amount.toString(),
            degreeFiltered[icount].pay_type.toString(),
          ],
      ];

      await exportToExcel(data);
    } catch (e) {}
  }

  Future<void> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Future<void> exportToExcel(List<List<dynamic>> data) async {
    try {
      await requestStoragePermission();

      String csv = const ListToCsvConverter().convert(data);

      // Create a timestamp to append to the filename
      String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());

      // Generate a unique file name with timestamp
      String filePath =
          '/storage/emulated/0/Download/fee_collection_$timestamp.csv';

      print('Saving file to: $filePath');

      File file = File(filePath);
      await file.writeAsString(csv);
      AppUtil.showToast("File Saved Successfuly to Downloads", 's');
    } catch (e) {
      print('Error exporting to Excel: $e');
    }
  }
}
