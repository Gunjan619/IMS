import "package:flutter/material.dart";
import 'package:gims/view/master/addUser.dart';
import 'package:gims/view/master/editUser.dart';
import 'package:gims/view/staff/addSalaryStructure.dart';
import 'package:gims/view/staff/addSlab.dart';
import 'package:gims/view/staff/addStaff.dart';
import 'package:gims/view/staff/editSalaryStructure.dart';
import 'package:gims/view/staff/editSlab.dart';
import 'package:gims/view/staff/editStaff.dart';
import 'package:gims/view/staff/editbulkStaffAttendance.dart';
import 'package:gims/view/staff/generateSalary.dart';
import 'package:gims/view/staff/manageSalaryStructure.dart';
import 'package:gims/view/staff/manageSlab.dart';
import 'package:gims/view/staff/manageStaff.dart';
import 'package:gims/view/reports/cancelledReceipts.dart';
import 'package:gims/view/staff/bulkStaffAttendance.dart';
import 'package:gims/view/staff/manageStaffAttend.dart';
import 'package:gims/view/staff/staffAttendance.dart';
import 'package:gims/view/yeartransfer/yearTransfer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_strategy/url_strategy.dart';

import 'package:gims/view/feecollection.dart/feeCollection.dart';
import 'package:gims/view/feecollection.dart/invoiceView.dart';
import 'package:gims/view/home/dashboard.dart';
import 'package:gims/view/login/login.dart';
import 'package:gims/view/login/splash.dart';
import 'package:gims/view/master/addCategory.dart';
import 'package:gims/view/master/addCourse.dart';
import 'package:gims/view/master/addDegree.dart';
import 'package:gims/view/master/addFeeName.dart';
import 'package:gims/view/master/addHoliday.dart';
import 'package:gims/view/master/addLastExamYear.dart';
import 'package:gims/view/master/addReligion.dart';
import 'package:gims/view/master/addSession.dart';
import 'package:gims/view/master/addStructure.dart';
import 'package:gims/view/master/addYear.dart';
import 'package:gims/view/master/categoryManage.dart';
import 'package:gims/view/master/courseManagement.dart';
import 'package:gims/view/master/degreeManagement.dart';
import 'package:gims/view/master/editCategory.dart';
import 'package:gims/view/master/editCourse.dart';
import 'package:gims/view/master/editDegree.dart';
import 'package:gims/view/master/editFeeName.dart';
import 'package:gims/view/master/editLastExamYear.dart';
import 'package:gims/view/master/editReligion.dart';
import 'package:gims/view/master/editSession.dart';
import 'package:gims/view/master/editStructure.dart';
import 'package:gims/view/master/editYear.dart';
import 'package:gims/view/master/feeNameManage.dart';
import 'package:gims/view/master/feeStructure.dart';
import 'package:gims/view/master/holidayManage.dart';
import 'package:gims/view/master/lastExamYear.dart';
import 'package:gims/view/master/manageUser.dart';
import 'package:gims/view/master/organisation.dart';
import 'package:gims/view/master/religionManagement.dart';
import 'package:gims/view/master/sessionManagement.dart';
import 'package:gims/view/master/yearManagement.dart';
import 'package:gims/view/reports/feeCollectionReport.dart';
import 'package:gims/view/reports/feePendingReport.dart';
import 'package:gims/view/student/addStudent.dart';
import 'package:gims/view/student/editStudent.dart';
import 'package:gims/view/student/manageBlockedStudent.dart';
import 'package:gims/view/student/manageStudent.dart';
import 'package:gims/view/student/profileView.dart';

void main() {
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String orgName = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      title: orgName,
      debugShowCheckedModeBanner: false,
      initialRoute: "/splash",
      routes: {
        // ******************** Login Start **************************
        "/splash": (BuildContext context) => const SplashScreen(),
        "/Login": (BuildContext context) => const SignIn(),
        // ******************** Login End **************************

        // ******************** Master Start **************************
        "/home": (BuildContext context) => const Dashboard(),
        "/organisation": (BuildContext context) => const Organisation(),
        "/session": (BuildContext context) => const ManageSession(),
        "/AddSession": (BuildContext context) => const AddSession(),
        "/EditSession": (BuildContext context) => const EditSession(),
        "/addUser": (BuildContext context) => const AddUser(),
        "/editUser": (BuildContext context) => const EditUser(),
        "/ManageUser": (BuildContext context) => const ManageUser(),
        "/ManageDegree": (BuildContext context) => const ManageDegree(),
        "/AddDegree": (BuildContext context) => const AddDegree(),
        "/EditDegree": (BuildContext context) => const EditDegree(),
        "/ManageCourse": (BuildContext context) => const ManageCourse(),
        "/AddCourse": (BuildContext context) => const AddCourse(),
        "/EditCourse": (BuildContext context) => const EditCourse(),
        "/ManageYear": (BuildContext context) => const ManageYear(),
        "/AddYear": (BuildContext context) => const AddYear(),
        "/EditYear": (BuildContext context) => const EditYear(),
        "/LastExamYear": (BuildContext context) => const LastExamYear(),
        "/AddLastExamYear": (BuildContext context) => const AddLastExamYear(),
        "/EditLastExamYear": (BuildContext context) => const EditLastExamYear(),
        "/ManageFeeName": (BuildContext context) => const ManageFeeName(),
        "/AddFeeName": (BuildContext context) => const AddFeeName(),
        "/EditFeeName": (BuildContext context) => const EditFeeName(),
        "/FeeStructure": (BuildContext context) => const FeeStructure(),
        "/AddStructure": (BuildContext context) => const AddStructure(),
        "/EditStructure": (BuildContext context) => const EditStructure(),
        "/ManageReligion": (BuildContext context) => const ManageReligion(),
        "/AddReligion": (BuildContext context) => const AddReligion(),
        "/EditReligion": (BuildContext context) => const EditReligion(),
        "/ManageCategory": (BuildContext context) => const ManageCategory(),
        "/AddCategory": (BuildContext context) => const AddCategory(),
        "/EditCategory": (BuildContext context) => const EditCategory(),
        "/ManageHoliday": (BuildContext context) => const ManageHoliday(),
        "/AddHoliday": (BuildContext context) => const AddHoliday(),
        // ******************** Master End **************************

        // ******************** Student Manage Start **************************
        "/ManageStudent": (BuildContext context) => const ManageStudent(),
        "/ProfileView": (BuildContext context) => ProfileView(),
        "/AddStudent": (BuildContext context) => const AddStudent(),
        "/EditStudent": (BuildContext context) => const EditStudent(),
        "/BlockedStudent": (BuildContext context) =>
            const ManageBlockedStudent(),
        // ******************** Student Manage End **************************

        // ******************** Fee Collection Start **************************
        "/feeCollection": (BuildContext context) => const FeeCollection(),
        "/invoiceView": (BuildContext context) => InvoiceView(),
        // ******************** Fee Collection End **************************

        // ******************** Reports Start **************************
        "/feeCollectionReport": (BuildContext context) =>
            const FeeCollectionReport(),
        "/feePendingReport": (BuildContext context) => const FeePendingReport(),
        "/cancelledReceipts": (BuildContext context) =>
            const CancelledReceipts(),
        "/yearTransfer": (BuildContext context) => const YearTransfer(),
        // ******************** Reports End **************************

        // ******************** Staff Start **************************
        "/manageStaff": (BuildContext context) => const ManageStaff(),
        "/addStaff": (BuildContext context) => const AddStaff(),
        "/editStaff": (BuildContext context) => const EditStaff(),
        "/addSlab": (BuildContext context) => const AddSlab(),
        "/editSlab": (BuildContext context) => const EditSlab(),
        "/manageSlab": (BuildContext context) => const ManageSlab(),
        "/manageStructure": (BuildContext context) =>
            const ManageSalaryStructure(),
        "/addSalarySturcture": (BuildContext context) =>
            const AddSalaryStructure(),
        "/editSalaryStructure": (BuildContext context) =>
            const EditSalaryStructure(),
        "/generateSalary": (BuildContext context) => const GenerateSalary(),
        "/bulkStaffAttendance": (BuildContext context) =>
            const BulkStaffAttendance(),
        "/staffAttendance": (BuildContext context) => const StaffAttendance(),
        "/manageStaffAttend": (BuildContext context) =>
            const ManageStaffAttend(),
        "/editBulkStaffAttendance": (BuildContext context) =>
            const EditBulkStaffAttendance(),
        // ******************** Staff End **************************
      },
      home: const SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  String userId = '';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/splash.gif',
      fit: BoxFit.cover,
    );
  }
}
