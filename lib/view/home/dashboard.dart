// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gims/model/Response/courseResponse.dart';
import 'package:gims/model/Response/dashCollectionResponse.dart';
import 'package:gims/model/Response/dashExpenseResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gims/api/appCommonVariable.dart';
import 'package:gims/api/webService.dart';
import 'package:gims/model/Request/simpleRequest.dart';
import 'package:gims/model/Response/organisationResponse.dart';
import 'package:gims/model/Response/sessionResponse.dart';
import 'package:gims/responsive.dart';
import 'package:gims/view/home/sidebar.dart';

class Dashboard extends StatefulWidget {
  final Color barBackgroundColor = Colors.white10;
  final Color barColor = Colors.white;

  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with WidgetsBindingObserver {
  int crocesscount = 0;
  double childAspect = 0.00;
  double cardHeight = 0;
  double cardWidth = 0;
  String userId = "";
  String userName = "";
  String name = "";
  String accountType = "";
  bool isLoading = false;
  List sessionList = [];
  List courseList = [];

  final Webservice _service = Webservice();
  SimpleModel simpleRequest = SimpleModel("");
  organisationResponse OrganisationResponse = organisationResponse();
  SessionResponse sessionResponse = SessionResponse();
  CourseResponse courseResponse = CourseResponse();
  DashCollectionResponse dashCollectionResponse = DashCollectionResponse();
  DashExpenseResponse dashExpenseResponse = DashExpenseResponse();
  String orgName = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences sp = await SharedPreferences.getInstance();
    userId = sp.getString(USER_ID) ?? "";
    if (userId.isEmpty) {
      Navigator.pushReplacementNamed(context, '/Login');
      return;
    }

    userName = sp.getString(USERNAME) ?? "";
    name = sp.getString(NAME) ?? "";
    accountType = sp.getString(ACCOUNT_TYPE) ?? "";

    try {
      simpleRequest.type = 'view';

      // Fetch organisation data
      var organisationData = await _service.organisation(simpleRequest);
      setState(() {
        OrganisationResponse = organisationData;
        if (organisationData.error == false) {
          orgName = OrganisationResponse.name ?? '';
        }
      });

      // Fetch session data
      var sessionData = await _service.session(simpleRequest);
      setState(() {
        sessionResponse = sessionData;
        if (sessionResponse.error == false) {
          sessionList = sessionResponse.data!;
        }
      });

      // Fetch course data
      var courseData = await _service.course(simpleRequest);
      setState(() {
        courseResponse = courseData;
        if (courseResponse.error == false) {
          courseList = courseResponse.data!;
        }
      });

      // Fetch collection data
      var dashCollectData = await _service.dashCollection(simpleRequest);
      setState(() {
        dashCollectionResponse = dashCollectData;
      });

      // Fetch expense data
      var dashExpenseData = await _service.dashExpense(simpleRequest);
      setState(() {
        dashExpenseResponse = dashExpenseData;
      });
    } catch (error) {
      // Handle error
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (Responsive.isDesktop(context)) {
      crocesscount = 4;
      cardHeight = 450;
      cardWidth = 250;
      childAspect = 1 / 0.5;
    } else if (Responsive.isTablet(context)) {
      crocesscount = 3;
      cardHeight = 600;
      cardWidth = 300;
      childAspect = 1 / 0.6;
    } else {
      crocesscount = 2;
      cardHeight = 650;
      childAspect = 1 / 0.8;
      cardWidth = 300;
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          automaticallyImplyLeading: false,
          actions: [
            Tooltip(
              message: 'Profile',
              child: IconButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/addToken');
                  },
                  icon: const Icon(
                    Icons.person,
                    color: Colors.white,
                  )),
            ),
          ],
          title: Row(
            children: [
              Visibility(
                visible: Responsive.isDesktop(context) ? false : true,
                child: Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Text(
                  orgName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        drawer: Responsive.isDesktop(context) ? null : const DrawerMenu(),
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (Responsive.isDesktop(context))
                const Expanded(
                  child: DrawerMenu(),
                ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding:
                      EdgeInsets.all(Responsive.isDesktop(context) ? 8 : 0),
                  child: isLoading
                      ? SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: SpinKitCircle(
                            color: Theme.of(context).primaryColor,
                            size: 70.0,
                            duration: const Duration(milliseconds: 1200),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _refreshData,
                          child: SingleChildScrollView(
                            child: SizedBox(
                              child: Padding(
                                padding: EdgeInsets.all(
                                    Responsive.isDesktop(context) ? 8 : 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          left: 15, top: 25, bottom: 10),
                                      child: Text(
                                        'All Session Reports',
                                        style: TextStyle(fontSize: 22),
                                      ),
                                    ),
                                    GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount:
                                                    Responsive.isDesktop(
                                                            context)
                                                        ? 5
                                                        : 3),
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: sessionList.length,
                                        itemBuilder: (BuildContext ctx, int i) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                context,
                                                '/ManageStudent',
                                                arguments: {
                                                  'year': sessionList[i].from,
                                                },
                                              );
                                            },
                                            child: Card(
                                              color: const Color.fromARGB(
                                                  255, 255, 255, 255),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Image.asset(
                                                      'assets/icons/laptop.png',
                                                      height: 45,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Text(
                                                      sessionList[i]
                                                          .session
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          color: Color.fromARGB(
                                                              255, 0, 0, 0),
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            1.0),
                                                    child: Text(
                                                      sessionList[i]
                                                          .students
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          color: Color.fromARGB(
                                                              255, 0, 0, 0),
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          left: 15, top: 25, bottom: 10),
                                      child: Text(
                                        'Collection Reports',
                                        style: TextStyle(fontSize: 22),
                                      ),
                                    ),
                                    GridView.count(
                                        crossAxisCount:
                                            Responsive.isDesktop(context)
                                                ? 5
                                                : 3,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        children: [
                                          Card(
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Image.asset(
                                                    'assets/icons/rupee.png',
                                                    height: 45,
                                                  ),
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Text(
                                                    'Total Amount',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(1.0),
                                                  child: Text(
                                                    dashCollectionResponse
                                                        .totalAmount
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Card(
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Image.asset(
                                                    'assets/icons/rupee.png',
                                                    height: 45,
                                                  ),
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Text(
                                                    'Total Collection',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(1.0),
                                                  child: Text(
                                                    dashCollectionResponse
                                                        .totalCollection
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Card(
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Image.asset(
                                                    'assets/icons/rupee.png',
                                                    height: 45,
                                                  ),
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Text(
                                                    'Total Due',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(1.0),
                                                  child: Text(
                                                    dashCollectionResponse
                                                        .totalDue!,
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Card(
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Image.asset(
                                                    'assets/icons/rupee.png',
                                                    height: 45,
                                                  ),
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Text(
                                                    'Today Collect',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(1.0),
                                                  child: Text(
                                                    dashCollectionResponse
                                                        .todayCollection!,
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ]),
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          left: 15, top: 25, bottom: 10),
                                      child: Text(
                                        'Expense Reports',
                                        style: TextStyle(fontSize: 22),
                                      ),
                                    ),
                                    GridView.count(
                                        crossAxisCount:
                                            Responsive.isDesktop(context)
                                                ? 5
                                                : 3,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        children: [
                                          Card(
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Image.asset(
                                                    'assets/icons/budget.png',
                                                    height: 45,
                                                  ),
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Text(
                                                    'Total Expense',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(1.0),
                                                  child: Text(
                                                    dashExpenseResponse
                                                        .totalExpense!,
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Card(
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Image.asset(
                                                    'assets/icons/budget.png',
                                                    height: 45,
                                                  ),
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Text(
                                                    'Expense Month',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(1.0),
                                                  child: Text(
                                                    dashExpenseResponse
                                                        .expenseMonth!,
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Card(
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Image.asset(
                                                    'assets/icons/budget.png',
                                                    height: 45,
                                                  ),
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Text(
                                                    'Expenses Year',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(1.0),
                                                  child: Text(
                                                    dashExpenseResponse
                                                        .expenseYear!,
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ]),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
