import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gims/Api/AppCommonVariable.dart';
import 'package:gims/api/webService.dart';
import 'package:gims/controllers/AppUtil.dart';
import 'package:gims/model/Request/editSessionRequest.dart';
import 'package:gims/model/Response/SimpleResponse.dart';
import 'package:gims/responsive.dart';
import 'package:gims/view/home/sidebar.dart';

class EditSession extends StatefulWidget {
  const EditSession({super.key});

  @override
  State<EditSession> createState() => _EditSessionState();
}

class _EditSessionState extends State<EditSession> {
  int crocesscount = 0;
  double childAspect = 0.00;
  bool babkbutton = false;
  String editId = '', permissions = '';
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  EditSessionRequest editSessionRequest = EditSessionRequest("", "", "");
  SimpleResponse simpleResponse = SimpleResponse();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      setState(() {
        permissions = sp.getString(PERMISSIONS)!;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeDepartmentData(context);
    });
  }

  void initializeDepartmentData(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    if (arguments['id'] != null) {
      editId = arguments['id'];
      fromController.text = arguments['from'];
      toController.text = arguments['to'];
      setState(() {});
    } else {
      Navigator.pushReplacementNamed(context, '/session');
    }
  }

  void _submitForm() {
    if (fromController.text.isEmpty) {
      AppUtil.showToast("Please Enter From", "e");
    } else if (toController.text.isEmpty) {
      AppUtil.showToast("Please Enter To", "e");
    } else {
      SharedPreferences.getInstance().then((SharedPreferences sp) {
        editSessionRequest.id = editId;
        editSessionRequest.from = fromController.text.trim();
        editSessionRequest.to = toController.text.trim();

        Webservice _service = Webservice();
        _service.editSession(editSessionRequest).then((value) async {
          simpleResponse = value;

          if (simpleResponse.error == false) {
            AppUtil.showToast(simpleResponse.msg!, "i");
            Navigator.pushReplacementNamed(context, '/session');
          } else {
            AppUtil.showToast(simpleResponse.msg!, 'e');
          }
        });
      });
    }
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
      return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SpinKitCircle(
            color: Theme.of(context).primaryColor,
            size: 70.0,
            duration: const Duration(milliseconds: 1200),
          ));
    } else if (permissions.contains('edit_session')) {
      return SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            automaticallyImplyLeading: babkbutton,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/session');
                }),
            title: const Text(
              'Edit Session',
              style: TextStyle(color: Colors.white),
            ),
          ),
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
                    padding: const EdgeInsets.all(25.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GridView.count(
                              crossAxisCount: crocesscount,
                              childAspectRatio: childAspect,
                              shrinkWrap: true,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 15,
                              children: [
                                TextFormField(
                                  controller: fromController,
                                  keyboardType: TextInputType.name,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: ' From',
                                    hintText: 'Enter From*',
                                  ),
                                ),
                                TextFormField(
                                  controller: toController,
                                  keyboardType: TextInputType.name,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'To',
                                    hintText: 'Enter To*',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 130.0,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty
                                          .resolveWith<Color?>(
                                        (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.pressed)) {
                                            return Theme.of(context)
                                                .primaryColor;
                                          }
                                          return Theme.of(context)
                                              .primaryColor; // Use the component's default.
                                        },
                                      ),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.only(
                                          top: 9.0, bottom: 9.0),
                                      child: Text(
                                        'Submit',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    onPressed: _submitForm,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
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
