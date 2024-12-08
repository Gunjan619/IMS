import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gims/model/Request/addStaffRequest.dart';
import 'package:gims/model/Request/simpleRequest.dart';
import 'package:gims/model/Response/SimpleResponse.dart';
import 'package:gims/model/Response/degreeResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gims/Api/AppCommonVariable.dart';
import 'package:gims/api/webService.dart';
import 'package:gims/controllers/AppUtil.dart';
import 'package:gims/responsive.dart';
import 'package:gims/view/home/sidebar.dart';

class AddStaff extends StatefulWidget {
  const AddStaff({super.key});

  @override
  State<AddStaff> createState() => _AddStaffState();
}

class _AddStaffState extends State<AddStaff> {
  int crocesscount = 0;
  double childAspect = 0.00;
  bool babkbutton = false;
  String permissions = '';
  TextEditingController nameController = TextEditingController();
  TextEditingController fatherController = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController desigController = TextEditingController();
  TextEditingController departController = TextEditingController();
  TextEditingController panController = TextEditingController();
  TextEditingController bankController = TextEditingController();
  TextEditingController accountController = TextEditingController();
  TextEditingController ifscController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController casteController = TextEditingController();
  TextEditingController bloodController = TextEditingController();
  TextEditingController qualifyController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController joinController = TextEditingController();
  TextEditingController retireController = TextEditingController();
  TextEditingController incrementController = TextEditingController();
  TextEditingController promotionController = TextEditingController();
  TextEditingController phdController = TextEditingController();
  TextEditingController publicationController = TextEditingController();
  TextEditingController pubtypeController = TextEditingController();
  TextEditingController nomineeController = TextEditingController();
  TextEditingController relationshipController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> items = ['Select Category', 'Teaching', 'Non-Teaching'];
  String? dropdownvalueService;
  List<String> items2 = ['Select Religion'];
  String? dropdownvalueService2;
  List religionList = [];
  String religionId = '';

  final AddStaffRequest addCourseRequest = AddStaffRequest(
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "");
  SimpleResponse addResponse = SimpleResponse();
  SimpleModel degreeRequest = SimpleModel("");
  DegreeResponse degreeResponse = DegreeResponse();
  final Webservice _service = Webservice();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      setState(() {
        permissions = sp.getString(PERMISSIONS)!;
      });
    });
    degreeRequest.type = 'view';
    _service.religion(degreeRequest).then((value) {
      degreeResponse = value;
      religionList = degreeResponse.data!;
      List.generate(religionList.length, (index) {
        items2.add(religionList[index].name);
      });
    });
    setState(() {
      isLoading = false;
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
    } else if (permissions.contains('add_staff')) {
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
                        Navigator.pushReplacementNamed(context, '/manageStaff');
                      }),
                  title: Responsive.isDesktop(context)
                      ? const Text(
                          'Add Staff',
                          style: TextStyle(color: Colors.white),
                        )
                      : const Text(
                          'Add Staff',
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
                                    child: permissions.contains('add_staff')
                                        ? Column(
                                            children: [
                                              GridView.count(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                crossAxisCount: crocesscount,
                                                childAspectRatio: childAspect,
                                                shrinkWrap: true,
                                                mainAxisSpacing: 0,
                                                crossAxisSpacing: 15,
                                                children: [
                                                  DropdownButtonFormField(
                                                    isExpanded: true,
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 0),
                                                      labelText: "Category",
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
                                                        },
                                                      );
                                                    },
                                                  ),
                                                  TextFormField(
                                                    controller: nameController,
                                                    keyboardType:
                                                        TextInputType.name,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText: ' Name',
                                                      hintText:
                                                          'Enter Employee Name',
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        fatherController,
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
                                                  DateTimePicker(
                                                    controller: dob,
                                                    style: const TextStyle(
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      color: Colors.black,
                                                    ),
                                                    type:
                                                        DateTimePickerType.date,
                                                    firstDate: DateTime(1800),
                                                    lastDate: DateTime.now(),
                                                    decoration: InputDecoration(
                                                      labelText: "DOB",
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
                                                              .grey.shade800,
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
                                                      hintText: 'Select DOB',
                                                      labelStyle: TextStyle(
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        color: Colors
                                                            .grey.shade800,
                                                      ),
                                                      hintStyle: TextStyle(
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        color: Colors
                                                            .grey.shade800,
                                                      ),
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller: desigController,
                                                    keyboardType:
                                                        TextInputType.name,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText: "Designation",
                                                      hintText:
                                                          "Enter Designation",
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        departController,
                                                    keyboardType:
                                                        TextInputType.name,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText: "Department",
                                                      hintText:
                                                          "Enter Department",
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller: panController,
                                                    keyboardType:
                                                        TextInputType.name,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText: "Pan No",
                                                      hintText: "Enter Pan No",
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller: bankController,
                                                    keyboardType:
                                                        TextInputType.name,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText: "Bank Name",
                                                      hintText:
                                                          "Enter Bank Name",
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        accountController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText: "Bank A/C No",
                                                      hintText:
                                                          "Enter Bank A/C No",
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller: ifscController,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText: "IFSC Code",
                                                      hintText:
                                                          "Enter IFSC Code",
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        mobileController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText:
                                                          "Mobile Number",
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
                                                      labelText: "Email Id",
                                                      hintText:
                                                          "Enter Email Id",
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
                                                        dropdownvalueService2 =
                                                            newValue!;
                                                        int index = items2
                                                            .indexOf(newValue);
                                                        if (index >= 0 &&
                                                            index <=
                                                                religionList
                                                                    .length) {
                                                          religionId = religionList[
                                                                  items2.indexOf(
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
                                                  TextFormField(
                                                    controller: bloodController,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText: "Blood Group",
                                                      hintText:
                                                          "Enter Blood Group",
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        qualifyController,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText:
                                                          "Qualification",
                                                      hintText:
                                                          "Enter Qualification",
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        addressController,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText: "Address",
                                                      hintText: "Enter Address",
                                                    ),
                                                  ),
                                                  DateTimePicker(
                                                    controller: joinController,
                                                    style: const TextStyle(
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      color: Colors.black,
                                                    ),
                                                    type:
                                                        DateTimePickerType.date,
                                                    firstDate: DateTime(1800),
                                                    lastDate: DateTime.now(),
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          "Date of Joining",
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
                                                              .grey.shade800,
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
                                                      hintText:
                                                          'Select Date of Joining',
                                                      labelStyle: TextStyle(
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        color: Colors
                                                            .grey.shade800,
                                                      ),
                                                      hintStyle: TextStyle(
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        color: Colors
                                                            .grey.shade800,
                                                      ),
                                                    ),
                                                  ),
                                                  DateTimePicker(
                                                    controller:
                                                        retireController,
                                                    style: const TextStyle(
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      color: Colors.black,
                                                    ),
                                                    type:
                                                        DateTimePickerType.date,
                                                    firstDate: DateTime(1800),
                                                    lastDate: DateTime.now(),
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          "Date of Retirement",
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
                                                              .grey.shade800,
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
                                                      hintText:
                                                          'Select Date of Retirement',
                                                      labelStyle: TextStyle(
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        color: Colors
                                                            .grey.shade800,
                                                      ),
                                                      hintStyle: TextStyle(
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        color: Colors
                                                            .grey.shade800,
                                                      ),
                                                    ),
                                                  ),
                                                  DateTimePicker(
                                                    controller:
                                                        incrementController,
                                                    style: const TextStyle(
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      color: Colors.black,
                                                    ),
                                                    type:
                                                        DateTimePickerType.date,
                                                    firstDate: DateTime(1800),
                                                    lastDate: DateTime.now(),
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          "Date of Last Increment",
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
                                                              .grey.shade800,
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
                                                      hintText:
                                                          'Select Date of Last Increment',
                                                      labelStyle: TextStyle(
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        color: Colors
                                                            .grey.shade800,
                                                      ),
                                                      hintStyle: TextStyle(
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        color: Colors
                                                            .grey.shade800,
                                                      ),
                                                    ),
                                                  ),
                                                  DateTimePicker(
                                                    controller:
                                                        promotionController,
                                                    style: const TextStyle(
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      color: Colors.black,
                                                    ),
                                                    type:
                                                        DateTimePickerType.date,
                                                    firstDate: DateTime(1800),
                                                    lastDate: DateTime.now(),
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          "Date of Last Promotion",
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
                                                              .grey.shade800,
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
                                                      hintText:
                                                          'Select Date of Last Promotion',
                                                      labelStyle: TextStyle(
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        color: Colors
                                                            .grey.shade800,
                                                      ),
                                                      hintStyle: TextStyle(
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        color: Colors
                                                            .grey.shade800,
                                                      ),
                                                    ),
                                                  ),
                                                  DateTimePicker(
                                                    controller: phdController,
                                                    style: const TextStyle(
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      color: Colors.black,
                                                    ),
                                                    type:
                                                        DateTimePickerType.date,
                                                    firstDate: DateTime(1800),
                                                    lastDate: DateTime.now(),
                                                    decoration: InputDecoration(
                                                      labelText: "Date of Ph.D",
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
                                                              .grey.shade800,
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
                                                      hintText:
                                                          'Select Date of Ph.D',
                                                      labelStyle: TextStyle(
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        color: Colors
                                                            .grey.shade800,
                                                      ),
                                                      hintStyle: TextStyle(
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        color: Colors
                                                            .grey.shade800,
                                                      ),
                                                    ),
                                                  ),
                                                  DateTimePicker(
                                                    controller:
                                                        publicationController,
                                                    style: const TextStyle(
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      color: Colors.black,
                                                    ),
                                                    type:
                                                        DateTimePickerType.date,
                                                    firstDate: DateTime(1800),
                                                    lastDate: DateTime.now(),
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          "Date of Publication of Paper",
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
                                                              .grey.shade800,
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
                                                      hintText:
                                                          'Select Date of Publication of Paper',
                                                      labelStyle: TextStyle(
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        color: Colors
                                                            .grey.shade800,
                                                      ),
                                                      hintStyle: TextStyle(
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        color: Colors
                                                            .grey.shade800,
                                                      ),
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        pubtypeController,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText:
                                                          "Publication Type",
                                                      hintText:
                                                          "Enter Publication Type",
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        nomineeController,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText:
                                                          "Name of Nominee",
                                                      hintText:
                                                          "Enter Name of Nominee",
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        relationshipController,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText:
                                                          "Relation with Nominee",
                                                      hintText:
                                                          "Enter Relation with Nominee",
                                                    ),
                                                  ),
                                                ],
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
                                                                'Select Category') {
                                                              AppUtil.showToast(
                                                                  "Please Select Category",
                                                                  "e");
                                                            } else if (nameController
                                                                .text.isEmpty) {
                                                              AppUtil.showToast(
                                                                  "Please Enter Name",
                                                                  "e");
                                                            } else if (fatherController
                                                                .text.isEmpty) {
                                                              AppUtil.showToast(
                                                                  "Please Enter Father Name",
                                                                  "e");
                                                            } else if (dob
                                                                .text.isEmpty) {
                                                              AppUtil.showToast(
                                                                  "Please Select DOB",
                                                                  "e");
                                                            } else if (panController
                                                                .text.isEmpty) {
                                                              AppUtil.showToast(
                                                                  "Please Enter Pan No",
                                                                  "e");
                                                            } else if (bankController
                                                                .text.isEmpty) {
                                                              AppUtil.showToast(
                                                                  "Please Enter Bank Name",
                                                                  "e");
                                                            } else if (accountController
                                                                .text.isEmpty) {
                                                              AppUtil.showToast(
                                                                  "Please Enter Bank Account Number",
                                                                  "e");
                                                            } else if (ifscController
                                                                .text.isEmpty) {
                                                              AppUtil.showToast(
                                                                  "Please Enter IFSC Code",
                                                                  "e");
                                                            } else if (mobileController
                                                                .text.isEmpty) {
                                                              AppUtil.showToast(
                                                                  "Please Enter Mobile Number",
                                                                  "e");
                                                            } else if (emailController
                                                                .text.isEmpty) {
                                                              AppUtil.showToast(
                                                                  "Please Enter Email Id",
                                                                  "e");
                                                            } else if (addressController
                                                                .text.isEmpty) {
                                                              AppUtil.showToast(
                                                                  "Please Enter Address",
                                                                  "e");
                                                            } else if (joinController
                                                                .text.isEmpty) {
                                                              AppUtil.showToast(
                                                                  "Please Select Date of Joining",
                                                                  "e");
                                                            } else if (nomineeController
                                                                .text.isEmpty) {
                                                              AppUtil.showToast(
                                                                  "Please Enter Nominee Name",
                                                                  "e");
                                                            } else if (relationshipController
                                                                .text.isEmpty) {
                                                              AppUtil.showToast(
                                                                  "Please Enter Relation With Nominee",
                                                                  "e");
                                                            } else {
                                                              addCourseRequest
                                                                      .category =
                                                                  dropdownvalueService!
                                                                      .toLowerCase()
                                                                      .toString();
                                                              ;
                                                              addCourseRequest
                                                                      .name =
                                                                  nameController
                                                                      .text
                                                                      .trim();
                                                              addCourseRequest
                                                                      .fatherName =
                                                                  fatherController
                                                                      .text
                                                                      .trim();
                                                              addCourseRequest
                                                                      .dob =
                                                                  dob.text
                                                                      .trim();
                                                              addCourseRequest
                                                                      .designation =
                                                                  desigController
                                                                      .text
                                                                      .trim();
                                                              addCourseRequest
                                                                      .department =
                                                                  departController
                                                                      .text
                                                                      .trim();
                                                              addCourseRequest
                                                                      .pan =
                                                                  panController
                                                                      .text
                                                                      .trim();
                                                              addCourseRequest
                                                                      .bank =
                                                                  bankController
                                                                      .text
                                                                      .trim();
                                                              addCourseRequest
                                                                      .account =
                                                                  accountController
                                                                      .text
                                                                      .trim();
                                                              addCourseRequest
                                                                      .ifsc =
                                                                  ifscController
                                                                      .text
                                                                      .trim();
                                                              addCourseRequest
                                                                      .mobile =
                                                                  mobileController
                                                                      .text
                                                                      .trim();
                                                              addCourseRequest
                                                                      .email =
                                                                  emailController
                                                                      .text
                                                                      .trim();
                                                              addCourseRequest
                                                                      .religion =
                                                                  religionId
                                                                      .trim();
                                                              addCourseRequest
                                                                      .caste =
                                                                  casteController
                                                                      .text
                                                                      .trim();
                                                              addCourseRequest
                                                                      .blood =
                                                                  bloodController
                                                                      .text
                                                                      .trim();
                                                              addCourseRequest
                                                                      .qualification =
                                                                  qualifyController
                                                                      .text
                                                                      .trim();
                                                              addCourseRequest
                                                                      .address =
                                                                  addressController
                                                                      .text
                                                                      .trim();
                                                              addCourseRequest
                                                                      .joining =
                                                                  joinController
                                                                      .text
                                                                      .trim();
                                                              addCourseRequest
                                                                      .retirement =
                                                                  retireController
                                                                      .text
                                                                      .trim();
                                                              addCourseRequest
                                                                      .increment =
                                                                  incrementController
                                                                      .text
                                                                      .trim();
                                                              addCourseRequest
                                                                      .promotion =
                                                                  promotionController
                                                                      .text
                                                                      .trim();
                                                              addCourseRequest
                                                                      .phd =
                                                                  phdController
                                                                      .text
                                                                      .trim();
                                                              addCourseRequest
                                                                      .publication =
                                                                  publicationController
                                                                      .text
                                                                      .trim();
                                                              addCourseRequest
                                                                      .pubType =
                                                                  pubtypeController
                                                                      .text
                                                                      .trim();
                                                              addCourseRequest
                                                                      .nominee =
                                                                  nomineeController
                                                                      .text
                                                                      .trim();
                                                              addCourseRequest
                                                                      .relationship =
                                                                  relationshipController
                                                                      .text
                                                                      .trim();

                                                              Webservice
                                                                  _service =
                                                                  Webservice();
                                                              _service
                                                                  .addStaff(
                                                                      addCourseRequest)
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
                                                                      '/manageStaff');
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
