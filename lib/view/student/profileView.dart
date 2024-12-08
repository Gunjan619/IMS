import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gims/api/webService.dart';
import 'package:gims/model/Request/paymentRequest.dart';
import 'package:gims/model/Response/paymentResponse.dart';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gims/api/webUrl.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileView createState() => _ProfileView();
}

class _ProfileView extends State<ProfileView> with TickerProviderStateMixin {
  bool isLoading = true;
  bool isDataFound = false;

  //
  String userId = '', masterId = '';

  String strSelectedOrgId = '';
  String strPermission = '';
  // late MemberResponseModel memberItem;
  String stMemberImagedoc1 = '';
  String stMemberImagedoc2 = '';
  String stMemberImagedoc3 = '';
  String memberprintpermission = '0';
  String editId = '';
  String name = '';
  String fatherName = '';
  String whatsappNo = '';
  String session = '';
  String degree = '';
  String course = '';
  String subCourse = '';
  String dob = '';
  String admissionDate = '';
  String stuPhoto = '';
  String stuSign = '';
  String aadharPhoto = '';
  String sessionId = '';
  String courseId = '';
  String subCourseId = '';
  List paymentList = [];
  PaymentRequest simpleRequest = PaymentRequest("", "", "", "", "");
  PaymentResponse paymentResponse = PaymentResponse();

  final Webservice _service = Webservice();
  /*my plans*/

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((SharedPreferences sp) async {
      // my plan list

      _callApiForPayment();
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeDepartmentData(context);
    });
  }

  void initializeDepartmentData(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    if (arguments['data'].id != null) {
      editId = arguments['data'].id;
      name = arguments['data'].name;

      fatherName = arguments['data'].fatherName;
      whatsappNo = arguments['data'].whatsappNo;
      session = arguments['data'].sessionName;
      degree = arguments['data'].degName;
      course = arguments['data'].courseName;
      subCourse = arguments['data'].subCourseName;
      dob = arguments['data'].dob;
      admissionDate = arguments['data'].admissionDate;
      stuPhoto = arguments['data'].photo;
      stuSign = arguments['data'].sign;
      aadharPhoto = arguments['data'].aadharPhoto;
      sessionId = arguments['data'].session;
      courseId = arguments['data'].course;
      subCourseId = arguments['data'].subCourse;

      setState(() {});
    } else {
      Navigator.pushReplacementNamed(context, '/ManageStudent');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text(
            'Student Profile',
            softWrap: true,
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Container(
            color: const Color(0xFFf5f5f5),
            height: double.infinity,
            child: SingleChildScrollView(
              child: _mainBody(context),
            )));
  }

  Widget _mainBody(BuildContext context) {
    return Column(
      children: [
        /*member details*/
        Stack(
          children: [
            //head bg
            Container(
              height: 300,
              color: Theme.of(context).primaryColor,
            ),

            //head details
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      height: 121,
                      width: 121,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                color: Theme.of(context).shadowColor)
                          ]),
                      child: ClipOval(
                        child: Image.network(
                          StudentImage + stuPhoto.toString(),
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return Image.asset("assets/images/def_image.png");
                          },
                        ),
                      )),
                  const SizedBox(width: 25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Name",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        name.toString(),
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      const Text(
                        "Father's Name",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        fatherName.toString(),
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      const Text(
                        "Contact Number",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        whatsappNo.toString(),
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  )
                ],
              ),
            ),

            //details
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 180, 0, 20),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(10),
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(11.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Session",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Degree",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Course",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Year",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "D.O.B",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Admission Date",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              session.toString(),
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              degree.toString(),
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              course.toString(),
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              subCourse.toString(),
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              dob.toString(),
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              admissionDate.toString(),
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
// /Documents

        Visibility(
          visible: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //tabs

              const Padding(
                  padding: EdgeInsets.only(left: 2, right: 2),
                  child: Text(
                    "Documents:",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  )),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    if (stuSign != '')
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              //builder: (_) => ImageDialog());
                              builder: (_) => imageDialog(
                                  stuSign.isNotEmpty
                                      ? StudentImage + stuSign
                                      : "assets/images/def_image.png",
                                  context));
                        },
                        child: SizedBox(
                          width: 150,
                          height: 150,
                          child: Image.network(
                            StudentImage + stuSign,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return Image.asset("assets/images/def_image.png",
                                  fit: BoxFit.contain);
                            },
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    if (aadharPhoto != '')
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              //builder: (_) => ImageDialog());
                              builder: (_) => imageDialog(
                                  aadharPhoto.isNotEmpty
                                      ? StudentImage + aadharPhoto
                                      : "assets/images/def_image.png",
                                  context));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 150,
                            height: 150,
                            child: Image.network(
                              StudentImage + aadharPhoto,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return Image.asset(
                                    "assets/images/def_image.png",
                                    fit: BoxFit.contain);
                              },
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //tabs
              const Padding(
                padding: EdgeInsets.only(bottom: 5, top: 5, left: 0, right: 0),
                child: DefaultTabController(
                  length: 2,
                  child: Padding(
                      padding: EdgeInsets.only(left: 8, right: 2),
                      child: Text(
                        "Payment Details",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      )),
                ),
              ),
              invoiceData(context, paymentList),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _callApiForPayment() async {
    isLoading = true;
    isDataFound = false;

    simpleRequest.type = 'view';
    simpleRequest.stuId = editId;
    simpleRequest.session = sessionId;
    simpleRequest.course = courseId;
    simpleRequest.subCourse = subCourseId;

    _service.paymentDetails(simpleRequest).then((value) {
      paymentResponse = value;
      paymentList = paymentResponse.data!;
      isLoading = false;

      isDataFound = true;

      setState(() {});
    });
  }

  Widget invoiceData(BuildContext context, paymentList) {
    return ListView.builder(
      padding: const EdgeInsets.only(left: 00, right: 00, top: 00, bottom: 00),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: paymentList.length,
      itemBuilder: (BuildContext ctx, int i) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(6),
                    bottomRight: Radius.circular(6),
                    bottomLeft: Radius.circular(6),
                    topLeft: Radius.circular(6)),
                boxShadow: [BoxShadow(blurRadius: 1, color: Colors.grey)]),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                "Date",
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 12),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                paymentList[i].entryDate.toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                "Amount",
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 12),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                paymentList[i].amount.toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                "Discount",
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 12),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                paymentList[i].discount.toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                "Paid",
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 12),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                paymentList[i].paid.toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                "Due Amount",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 12),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                paymentList[i].due.toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget imageDialog(path, context) {
  return Dialog(
    // backgroundColor: Colors.transparent,
    // elevation: 0,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  _saveImage(context, path);
                },
                icon: const Icon(
                  Icons.download,
                  color: Colors.redAccent,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close_rounded),
                color: Colors.redAccent,
              ),
            ],
          ),
        ),
        Container(
          width: 220,
          height: 240,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Image.network(
              '$path',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    ),
  );
}

Future<void> _saveImage(BuildContext context, imageutl) async {
  var random = Random();
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  late String message;

  try {
//     // Download image
    final http.Response response = await http.get(Uri.parse(imageutl));

//     // Get temporary directory
    final dir = await getTemporaryDirectory();

//     // Create an image name
    var filename = '${dir.path}/SaveImage${random.nextInt(100)}.png';

//     // Save to filesystem
    final file = File(filename);
    await file.writeAsBytes(response.bodyBytes);

//     // Ask the user to save it
    final params = SaveFileDialogParams(sourceFilePath: file.path);
    final finalPath = await FlutterFileDialog.saveFile(params: params);

    if (finalPath != null) {
      message = 'Image saved to disk';
    }
  } catch (e) {
    message = e.toString();
    scaffoldMessenger.showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: const Color(0xFFe91e63),
    ));
  }

  scaffoldMessenger.showSnackBar(SnackBar(
    content: Text(
      message,
      style: const TextStyle(
        fontSize: 12,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
    backgroundColor: const Color(0xFFe91e63),
  ));
}
