import 'package:flutter/material.dart';
import 'package:gims/responsive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;
import 'package:gims/api/appCommonVariable.dart';
import 'package:gims/api/webService.dart';
import 'package:gims/model/Request/simpleRequest.dart';
import 'package:gims/model/Response/organisationResponse.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({super.key});

  @override
  State<DrawerMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<DrawerMenu> {
  var url = html.window.location.href.split('/').last;
  bool master = false;
  bool tokenSystem = false;
  String userId = '';
  String orgName = '';
  String permissions = '';
  String userName = '';
  String name = '';
  SimpleModel requestModel = SimpleModel("");
  organisationResponse OrganisationResponse = organisationResponse();
  final Webservice _service = Webservice();
  String accountType = '';
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      userId = sp.getString(USER_ID)!;
      accountType = sp.getString(ACCOUNT_TYPE)!;
      userName = sp.getString(USERNAME)!;
      name = sp.getString(NAME)!;

      permissions = sp.getString(PERMISSIONS)!;
      if (userId.isEmpty) {}
      requestModel.type = 'view';

      _service.organisation(requestModel).then((value) {
        OrganisationResponse = value;

        if (value.error == false) {
          setState(() {
            orgName = OrganisationResponse.name!;
          });
        }
      });
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (url == 'departmentManagement' ||
    //     url == 'AddDepartment' ||
    //     url == 'counterManagement' ||
    //     url == 'AddCounter' ||
    //     url == 'userManagement' ||
    //     url == 'AddUser') {
    //   master = true;
    // } else if (url == 'addToken') {
    //   tokenSystem = true;
    // }
    return SizedBox(
      width: Responsive.isTabletDesktop(context)
          ? 280
          : MediaQuery.of(context).size.width * 0.78,
      child: Drawer(
        shape: const BeveledRectangleBorder(),
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage("assets/images/glibrary.jpeg"),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.3), BlendMode.darken),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              child: Text(name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 5),
                              child: Text(userName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  )),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
              leading: Image.asset(
                "assets/icons/house.png",
                height: 20,
                width: 20,
              ),
              title: const Text(
                "Dashboard",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (permissions.contains('master'))
              ExpansionTile(
                  initiallyExpanded: false,
                  leading: Image.asset(
                    "assets/icons/key.png",
                    height: 20,
                    width: 20,
                  ),
                  title: const Text(
                    'Master',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  children: [
                    if (permissions.contains('org_details'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/organisation');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Organisation ',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('manage_session'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/session');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Session Management',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('manage_user'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/ManageUser');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'User Management',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('manage_degree'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/ManageDegree');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Degree Management',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('manage_course'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/ManageCourse');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Course Management',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('manage_year'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/ManageYear');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Year Management',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('manage_last_exam_year'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/LastExamYear');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Last Exam Year Management',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('manage_fee_name'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/ManageFeeName');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Fee Name Management',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('manage_fee_structure'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/FeeStructure');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Fee Structure',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('manage_religion'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/ManageReligion');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Religion Management',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('manage_category'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/ManageCategory');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Category Management',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('manage_holiday'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/ManageHoliday');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Holiday Management',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                  ]),
            if (permissions.contains('studentManagement'))
              ExpansionTile(
                  initiallyExpanded: false,
                  leading: Image.asset(
                    "assets/icons/students.png",
                    height: 20,
                    width: 20,
                  ),
                  title: const Text(
                    'Student Management',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  children: [
                    if (permissions.contains('add_student'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/AddStudent');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Add Student',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('manage_student'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/ManageStudent');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Manage Students',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('view_blocked_student'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/BlockedStudent');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Blocked Students',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('view_tc_issued'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/displayDepartment');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'TC Issued',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                  ]),
            if (permissions.contains('feeCollection'))
              ListTile(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/feeCollection');
                },
                leading: Image.asset(
                  "assets/icons/rupee.png",
                  height: 20,
                  width: 20,
                ),
                title: const Text(
                  "Fee Collection",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            if (permissions.contains('studentReports'))
              ExpansionTile(
                  initiallyExpanded: false,
                  leading: Image.asset(
                    "assets/icons/seo-report.png",
                    height: 20,
                    width: 20,
                  ),
                  title: const Text(
                    'Student Reports',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  children: [
                    if (permissions.contains('fee_collection_report'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/feeCollectionReport');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Fee Collection Report',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('fee_pending_report'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/feePendingReport');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Fee Pending Report',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('cancelled_receipts'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/cancelledReceipts');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Cancelled Receipts',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                  ]),
            if (permissions.contains('promotionRequest'))
              ListTile(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/yearTransfer');
                },
                leading: Image.asset(
                  "assets/icons/graduated.png",
                  height: 20,
                  width: 20,
                ),
                title: const Text(
                  "Year Transfer(Promotion)",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            if (permissions.contains('staffManage'))
              ExpansionTile(
                  initiallyExpanded: false,
                  leading: Image.asset(
                    "assets/icons/teamwork.png",
                    height: 20,
                    width: 20,
                  ),
                  title: const Text(
                    'Staff Management ',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  children: [
                    if (permissions.contains('manage_staff'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ExpansionTile(
                            initiallyExpanded: false,
                            leading: Image.asset(
                              "assets/icons/period.png",
                              height: 20,
                              width: 20,
                            ),
                            title: const Text(
                              'Staff Management ',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            children: [
                              if (permissions.contains('add_staff'))
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.pushReplacementNamed(
                                          context, '/addStaff');
                                    },
                                    leading: Image.asset(
                                      "assets/icons/period.png",
                                      height: 20,
                                      width: 20,
                                    ),
                                    title: const Text(
                                      'Add Staff',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              if (permissions.contains('manage_staff'))
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.pushReplacementNamed(
                                          context, '/manageStaff');
                                    },
                                    leading: Image.asset(
                                      "assets/icons/period.png",
                                      height: 20,
                                      width: 20,
                                    ),
                                    title: const Text(
                                      'Manage Staff',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                            ]),
                      ),
                    if (permissions.contains('manage_slab'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ExpansionTile(
                            initiallyExpanded: false,
                            leading: Image.asset(
                              "assets/icons/period.png",
                              height: 20,
                              width: 20,
                            ),
                            title: const Text(
                              'Salary Slab ',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            children: [
                              if (permissions.contains('add_slab'))
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.pushReplacementNamed(
                                          context, '/addSlab');
                                    },
                                    leading: Image.asset(
                                      "assets/icons/period.png",
                                      height: 20,
                                      width: 20,
                                    ),
                                    title: const Text(
                                      'Add Salary Slabs',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              if (permissions.contains('manage_slab'))
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.pushReplacementNamed(
                                          context, '/manageSlab');
                                    },
                                    leading: Image.asset(
                                      "assets/icons/period.png",
                                      height: 20,
                                      width: 20,
                                    ),
                                    title: const Text(
                                      'Manage Slab',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                            ]),
                      ),
                    if (permissions.contains('manage_structure'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ExpansionTile(
                            initiallyExpanded: false,
                            leading: Image.asset(
                              "assets/icons/period.png",
                              height: 20,
                              width: 20,
                            ),
                            title: const Text(
                              'Salary Structure ',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            children: [
                              if (permissions.contains('add_structure'))
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.pushReplacementNamed(
                                          context, '/addSalarySturcture');
                                    },
                                    leading: Image.asset(
                                      "assets/icons/period.png",
                                      height: 20,
                                      width: 20,
                                    ),
                                    title: const Text(
                                      'Add Salary Structure',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              if (permissions.contains('manage_structure'))
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.pushReplacementNamed(
                                          context, '/manageStructure');
                                    },
                                    leading: Image.asset(
                                      "assets/icons/period.png",
                                      height: 20,
                                      width: 20,
                                    ),
                                    title: const Text(
                                      'Manage Salary Structure',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                            ]),
                      ),
                    if (permissions.contains('manage_structure'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ExpansionTile(
                            initiallyExpanded: false,
                            leading: Image.asset(
                              "assets/icons/period.png",
                              height: 20,
                              width: 20,
                            ),
                            title: const Text(
                              'Staff Attendance ',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            children: [
                              if (permissions.contains('add_structure'))
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.pushReplacementNamed(
                                          context, '/staffAttendance');
                                    },
                                    leading: Image.asset(
                                      "assets/icons/period.png",
                                      height: 20,
                                      width: 20,
                                    ),
                                    title: const Text(
                                      'Bulk Attendance',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              if (permissions.contains('manage_structure'))
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.pushReplacementNamed(
                                          context, '/manageStaffAttend');
                                    },
                                    leading: Image.asset(
                                      "assets/icons/period.png",
                                      height: 20,
                                      width: 20,
                                    ),
                                    title: const Text(
                                      'Manage Attendance',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                            ]),
                      ),
                    if (permissions.contains('manage_structure'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ExpansionTile(
                            initiallyExpanded: false,
                            leading: Image.asset(
                              "assets/icons/period.png",
                              height: 20,
                              width: 20,
                            ),
                            title: const Text(
                              'Generate Salary ',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            children: [
                              if (permissions.contains('add_structure'))
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.pushReplacementNamed(
                                          context, '/generateSalary');
                                    },
                                    leading: Image.asset(
                                      "assets/icons/period.png",
                                      height: 20,
                                      width: 20,
                                    ),
                                    title: const Text(
                                      'Generate Salary',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              if (permissions.contains('manage_structure'))
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.pushReplacementNamed(
                                          context, '/manageStructure');
                                    },
                                    leading: Image.asset(
                                      "assets/icons/period.png",
                                      height: 20,
                                      width: 20,
                                    ),
                                    title: const Text(
                                      'Salary Slip',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                            ]),
                      ),
                  ]),
            if (permissions.contains('attendance'))
              ExpansionTile(
                  initiallyExpanded: false,
                  leading: Image.asset(
                    "assets/icons/machine.png",
                    height: 20,
                    width: 20,
                  ),
                  title: const Text(
                    'Attendance',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  children: [
                    if (permissions.contains('add_stuattendance'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/addToken');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Add Attendance',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('view_stuattendance'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/manageQueue');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'View Attendance',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                  ]),
            if (permissions.contains('libraryManagement'))
              ExpansionTile(
                  initiallyExpanded: false,
                  leading: Image.asset(
                    "assets/icons/library.png",
                    height: 20,
                    width: 20,
                  ),
                  title: const Text(
                    'Library Management',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  children: [
                    if (permissions.contains('manage_mem_type'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/addToken');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Member Type',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('manage_book_category'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/manageQueue');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Vendor Management',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('manage_book_category'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/manageQueue');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Department Management',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('manage_book_category'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/manageQueue');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Subject Management',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('manage_book_category'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/manageQueue');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Books Category',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('manage_bookshelf'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/manageQueue');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Area Management',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('manage_bookshelf'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/manageQueue');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Bookshelf Management',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('manage_bookrack'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/manageQueue');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Book Rack Management',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('manage_books'))
                      ExpansionTile(
                          initiallyExpanded: false,
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Books Management ',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          children: [
                            if (permissions.contains('add_book'))
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/addToken');
                                  },
                                  leading: Image.asset(
                                    "assets/icons/period.png",
                                    height: 20,
                                    width: 20,
                                  ),
                                  title: const Text(
                                    'Add Books',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            if (permissions.contains('manage_book'))
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/addToken');
                                  },
                                  leading: Image.asset(
                                    "assets/icons/period.png",
                                    height: 20,
                                    width: 20,
                                  ),
                                  title: const Text(
                                    'Manage Books',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            if (permissions.contains('writeoff_book'))
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/addToken');
                                  },
                                  leading: Image.asset(
                                    "assets/icons/period.png",
                                    height: 20,
                                    width: 20,
                                  ),
                                  title: const Text(
                                    'Write-off Books',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            if (permissions.contains('lost_book'))
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/addToken');
                                  },
                                  leading: Image.asset(
                                    "assets/icons/period.png",
                                    height: 20,
                                    width: 20,
                                  ),
                                  title: const Text(
                                    'Lost Books',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            if (permissions.contains('block_book'))
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/addToken');
                                  },
                                  leading: Image.asset(
                                    "assets/icons/period.png",
                                    height: 20,
                                    width: 20,
                                  ),
                                  title: const Text(
                                    'Blocked Books',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                          ]),
                    if (permissions.contains('circulation'))
                      ExpansionTile(
                          initiallyExpanded: false,
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Circulation ',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          children: [
                            if (permissions.contains('circulation'))
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/addToken');
                                  },
                                  leading: Image.asset(
                                    "assets/icons/period.png",
                                    height: 20,
                                    width: 20,
                                  ),
                                  title: const Text(
                                    'Circulation',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            if (permissions.contains('manage_circulation'))
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/addToken');
                                  },
                                  leading: Image.asset(
                                    "assets/icons/period.png",
                                    height: 20,
                                    width: 20,
                                  ),
                                  title: const Text(
                                    'Manage Circulation',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                          ]),
                    if (permissions.contains('print_barcode'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/manageQueue');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Print Barcode',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('bulk_book_upload'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/manageQueue');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Bulk Books Upload',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('bulk_book_upload'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/manageQueue');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Due Books Report',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                  ]),
            if (permissions.contains('certificateManagement'))
              ExpansionTile(
                  initiallyExpanded: false,
                  leading: Image.asset(
                    "assets/icons/certificate.png",
                    height: 20,
                    width: 20,
                  ),
                  title: const Text(
                    'Certificate Management',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  children: [
                    if (permissions.contains('manage_bonafide'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/addToken');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Bonafide',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('manage_migration'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/manageQueue');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Migration',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('manage_character'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/manageQueue');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Character',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('manage_study'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/manageQueue');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Study',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('manage_transfer'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/manageQueue');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Transfer',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('manage_experience'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/manageQueue');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Experience',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('manage_attendance'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/manageQueue');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Attendace',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('manage_dutyattendance'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/manageQueue');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Duty Attendace',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('manage_attendance'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/manageQueue');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Poor Attendace',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('manage_attendance'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/manageQueue');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Warning Notice',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('manage_attendance'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/manageQueue');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Forwarding Letter',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('manage_longabsence'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/manageQueue');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Long Absence Notice',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                  ]),
            if (permissions.contains('expenseManagement'))
              ExpansionTile(
                  initiallyExpanded: false,
                  leading: Image.asset(
                    "assets/icons/expense.png",
                    height: 20,
                    width: 20,
                  ),
                  title: const Text(
                    'Expense Management',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  children: [
                    if (permissions.contains('add_expense'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/addToken');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Add Expense',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('view_expense'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/manageQueue');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Manage Expense',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('expense_report'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/manageQueue');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Expense Report',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                  ]),
            if (permissions.contains('hostelManagement'))
              ExpansionTile(
                  initiallyExpanded: false,
                  leading: Image.asset(
                    "assets/icons/hostel.png",
                    height: 20,
                    width: 20,
                  ),
                  title: const Text(
                    'Hostel Management',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  children: [
                    if (permissions.contains('dashboard_hostel'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/addToken');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Dashboard',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('hostel_mem_manage'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/manageQueue');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Member Management',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('floor_manage'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/manageQueue');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Floor Management',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('roomtype_manage'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/manageQueue');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Room/Addon Type',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('hostelplan_manage'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/manageQueue');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Plan Management',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('room_manage'))
                      ExpansionTile(
                          initiallyExpanded: false,
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Rooms/Unit',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          children: [
                            if (permissions.contains('room_manage'))
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/addToken');
                                  },
                                  leading: Image.asset(
                                    "assets/icons/period.png",
                                    height: 20,
                                    width: 20,
                                  ),
                                  title: const Text(
                                    'Manage Room/Unit',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            if (permissions.contains('allot_room'))
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/manageQueue');
                                  },
                                  leading: Image.asset(
                                    "assets/icons/period.png",
                                    height: 20,
                                    width: 20,
                                  ),
                                  title: const Text(
                                    'Room/Unit Allotment',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            if (permissions.contains('allot_room'))
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/manageQueue');
                                  },
                                  leading: Image.asset(
                                    "assets/icons/period.png",
                                    height: 20,
                                    width: 20,
                                  ),
                                  title: const Text(
                                    'Shift Member',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            if (permissions.contains('allot_room'))
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/manageQueue');
                                  },
                                  leading: Image.asset(
                                    "assets/icons/period.png",
                                    height: 20,
                                    width: 20,
                                  ),
                                  title: const Text(
                                    'Renew Member',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                          ]),
                    if (permissions.contains('manage_h_invoice'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/manageQueue');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Manage Invoice',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (permissions.contains('manage_h_allothistory'))
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/manageQueue');
                          },
                          leading: Image.asset(
                            "assets/icons/period.png",
                            height: 20,
                            width: 20,
                          ),
                          title: const Text(
                            'Room Allotment History',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                  ]),
            ListTile(
              onTap: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                await preferences.clear();
                Navigator.pushReplacementNamed(context, '/Login');
              },
              leading: Image.asset(
                "assets/icons/logout.png",
                height: 20,
                width: 20,
              ),
              title: const Text(
                "Sign Out",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}
