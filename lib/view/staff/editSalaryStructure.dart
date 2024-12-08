import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gims/model/Request/editSalaryStructureRequest.dart';
import 'package:gims/model/Request/simpleRequest.dart';
import 'package:gims/model/Response/manageFilterSlab.dart';
import 'package:gims/model/Response/staffResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gims/Api/AppCommonVariable.dart';
import 'package:gims/api/webService.dart';
import 'package:gims/controllers/AppUtil.dart';
import 'package:gims/model/Request/addSlabRequest.dart';
import 'package:gims/model/Response/SimpleResponse.dart';
import 'package:gims/responsive.dart';
import 'package:gims/view/home/sidebar.dart';

class EditSalaryStructure extends StatefulWidget {
  const EditSalaryStructure({super.key});

  @override
  State<EditSalaryStructure> createState() => _EditSalaryStructureState();
}

class _EditSalaryStructureState extends State<EditSalaryStructure> {
  int crocesscount = 0;
  double childAspect = 0.00;
  bool babkbutton = false;
  String permissions = '';
  TextEditingController employeeController = TextEditingController();
  TextEditingController payScaleController = TextEditingController();
  TextEditingController gradePayController = TextEditingController();
  TextEditingController basicController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final AddSlabRequest addSlabRequest = AddSlabRequest("", "", "");
  SimpleResponse addResponse = SimpleResponse();
  SimpleModel simpleRequest = SimpleModel("");
  final Webservice _service = Webservice();
  StaffResponse feeStructureResponse = StaffResponse();
  ManageFilterSlab manageFilterSlab = ManageFilterSlab();
  EditSalaryStructureRequest addSalaryStructureRequest =
      EditSalaryStructureRequest("", "", "", "", "", "", "");
  bool isLoading = false;
  List additionList = [];
  List additionFiltered = [];
  List deductionList = [];
  List deductionFiltered = [];
  String additionResult = "";
  String deductionResult = "";
  String editId = "";
  String empId = "";
  var additionValues;
  var deductionValues;

  Map<String, TextEditingController> additionControllers = {};
  Map<String, TextEditingController> deductionControllers = {};
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      setState(() {
        isLoading = true;
      });
      permissions = sp.getString(PERMISSIONS)!;

      // Load both lists and wait for them to complete
      loadAdditionAndDeductions();
    });
  }

  void loadAdditionAndDeductions() async {
    // Load addition list
    simpleRequest.type = 'additions';
    var additionResult = await _service.filterSlab(simpleRequest);
    if (additionResult.error == false) {
      additionList = additionResult.data!;
      additionFiltered = additionList;

      // Initialize controllers after data is loaded
      for (var addition in additionFiltered) {
        additionControllers[addition.id] = TextEditingController();
      }
    }

    // Load deduction list
    simpleRequest.type = 'deductions';
    var deductionResult = await _service.filterSlab(simpleRequest);
    if (deductionResult.error == false) {
      deductionList = deductionResult.data!;
      deductionFiltered = deductionList;

      // Initialize controllers after data is loaded
      for (var deduction in deductionFiltered) {
        deductionControllers[deduction.id] = TextEditingController();
      }
    }

    // Check if both lists are non-empty before initializing department data
    if (additionFiltered.isNotEmpty && deductionFiltered.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        initializeDepartmentData(context);
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void initializeDepartmentData(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;

    if (arguments['data'].id != null) {
      editId = arguments['data'].id;
      empId = arguments['data'].empId;
      employeeController.text = arguments['data'].empName;
      payScaleController.text = arguments['data'].payScale;
      gradePayController.text = arguments['data'].gradePay;
      basicController.text = arguments['data'].basicSalary;
      additionValues = parseResponse(arguments['data'].additions2);
      deductionValues = parseResponse(arguments['data'].deductions2);

      initializeControllers();

      setState(() {
        isLoading = false;
      });
    } else {
      Navigator.pushReplacementNamed(context, '/manageStructure');
    }
  }

  void initializeControllers() {
    additionFiltered.forEach((addition) {
      String additionId = addition.id; // Treat as String
      if (additionValues.containsKey(additionId)) {
        additionControllers[addition.id]?.text =
            additionValues[additionId].toString();
      }
    });

    deductionFiltered.forEach((deduction) {
      String deductionId = deduction.id; // Treat as String
      if (deductionValues.containsKey(deductionId)) {
        deductionControllers[deduction.id]?.text =
            deductionValues[deductionId].toString();
      }
    });
  }

  Map<String, int> parseResponse(String response) {
    Map<String, int> result = {};
    response.split(',').forEach((pair) {
      var keyValue = pair.split('=');
      if (keyValue.length == 2) {
        String id = keyValue[0]; // Keep as a String key
        int amount = int.parse(keyValue[1]); // Convert amount to int
        result[id] = amount;
      }
    });
    return result;
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
    } else if (permissions.contains('edit_structure')) {
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
                        Navigator.pushReplacementNamed(
                            context, '/manageStructure');
                      }),
                  title: Responsive.isDesktop(context)
                      ? const Text(
                          'Edit Salary Structure',
                          style: TextStyle(color: Colors.white),
                        )
                      : const Text(
                          'Edit Salary Structure',
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
                                    child: permissions
                                            .contains('edit_structure')
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 10,
                                              ),
                                              GridView.count(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                crossAxisCount: crocesscount,
                                                childAspectRatio: childAspect,
                                                shrinkWrap: true,
                                                mainAxisSpacing: 5,
                                                crossAxisSpacing: 15,
                                                children: [
                                                  TextFormField(
                                                    style: TextStyle(
                                                        color:
                                                            Colors.grey[800]),
                                                    readOnly: true,
                                                    controller:
                                                        employeeController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration: InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        labelText: ' Employee',
                                                        hintText:
                                                            'Enter Employee',
                                                        labelStyle: TextStyle(
                                                            color: Colors
                                                                .grey[800]),
                                                        hintStyle: TextStyle(
                                                            color: Colors
                                                                .grey[800])),
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        payScaleController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText: ' Pay Scale',
                                                      hintText:
                                                          'Enter Pay Scale',
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        gradePayController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText: ' Grade Pay',
                                                      hintText:
                                                          'Enter Grade Pay',
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller: basicController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText: ' Basic',
                                                      hintText: 'Enter Basic',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "Additions",
                                                style: TextStyle(
                                                  color: Colors.green[800],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 28,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemCount:
                                                      additionFiltered.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    var addition =
                                                        additionFiltered[index];
                                                    var newLabel =
                                                        '${addition.slabName} (In ${addition.slabProperty})';
                                                    return Column(
                                                      children: [
                                                        TextFormField(
                                                          controller:
                                                              additionControllers[
                                                                  addition.id],
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          decoration:
                                                              InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            labelText: newLabel,
                                                            hintText: newLabel,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 15,
                                                        ),
                                                      ],
                                                    );
                                                  }),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "Deductions",
                                                style: TextStyle(
                                                  color: Colors.red[800],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 28,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemCount:
                                                      deductionFiltered.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    var deduction =
                                                        deductionFiltered[
                                                            index];
                                                    var newLabel =
                                                        '${deduction.slabName} (In ${deduction.slabProperty})';
                                                    return Column(
                                                      children: [
                                                        TextFormField(
                                                          controller:
                                                              deductionControllers[
                                                                  deduction.id],
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          decoration:
                                                              InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            labelText: newLabel,
                                                            hintText: newLabel,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 15,
                                                        ),
                                                      ],
                                                    );
                                                  }),
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
                                                            if (payScaleController
                                                                .text.isEmpty) {
                                                              AppUtil.showToast(
                                                                  "Please Enter Slab Name",
                                                                  "e");
                                                            } else if (gradePayController
                                                                .text.isEmpty) {
                                                              AppUtil.showToast(
                                                                  "Please Enter Grade Pay",
                                                                  "e");
                                                            } else if (basicController
                                                                .text.isEmpty) {
                                                              AppUtil.showToast(
                                                                  "Please Enter Basic",
                                                                  "e");
                                                            } else {
                                                              additionResult =
                                                                  '';
                                                              deductionResult =
                                                                  '';

                                                              bool isEmpty =
                                                                  false;

                                                              if (!isEmpty) {
                                                                additionControllers
                                                                    .forEach((id,
                                                                        controller) {
                                                                  additionResult +=
                                                                      '${id}=${controller.text.isEmpty ? '0' : controller.text},';
                                                                });

                                                                // Deductions
                                                                deductionControllers
                                                                    .forEach((id,
                                                                        controller) {
                                                                  deductionResult +=
                                                                      '${id}=${controller.text.isEmpty ? '0' : controller.text},';
                                                                });

                                                                addSalaryStructureRequest
                                                                        .id =
                                                                    editId;

                                                                addSalaryStructureRequest
                                                                        .empid =
                                                                    empId;
                                                                addSalaryStructureRequest
                                                                        .payScale =
                                                                    payScaleController
                                                                        .text
                                                                        .toString();
                                                                addSalaryStructureRequest
                                                                        .gradePay =
                                                                    gradePayController
                                                                        .text
                                                                        .toString();
                                                                addSalaryStructureRequest
                                                                        .basicSalary =
                                                                    basicController
                                                                        .text
                                                                        .toString();
                                                                addSalaryStructureRequest
                                                                        .additionResult =
                                                                    additionResult;
                                                                addSalaryStructureRequest
                                                                        .deductionResult =
                                                                    deductionResult;

                                                                _service
                                                                    .editSalaryStructure(
                                                                        addSalaryStructureRequest)
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
                                                                        "i");

                                                                    Navigator.pushReplacementNamed(
                                                                        context,
                                                                        '/manageStructure');
                                                                  } else {
                                                                    AppUtil.showToast(
                                                                        addResponse
                                                                            .msg!,
                                                                        'e');
                                                                  }
                                                                });
                                                              }

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
