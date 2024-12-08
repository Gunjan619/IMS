import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gims/model/Request/addDegreeRequest.dart';
import 'package:gims/model/Request/addUserRequest.dart';
import 'package:gims/model/Request/simpleRequest.dart';
import 'package:gims/model/Response/SimpleResponse.dart';
import 'package:gims/model/Response/permissionResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gims/Api/AppCommonVariable.dart';
import 'package:gims/api/webService.dart';
import 'package:gims/controllers/AppUtil.dart';
import 'package:gims/responsive.dart';
import 'package:gims/view/home/sidebar.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  int crocesscount = 0;
  double childAspect = 0.00;
  bool babkbutton = false;
  String permissions = '';
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Webservice newService = Webservice();
  SimpleModel simpleModel = SimpleModel("");
  PermissionResponse permissionResponse = PermissionResponse();

  final AddDegreeRequest addDegreeRequest = AddDegreeRequest("");
  AddUserRequest addUserRequest = AddUserRequest("", "", "", "", "", "", "");
  SimpleResponse addResponse = SimpleResponse();

  List<bool> mainPermissionStates = [];
  List<List<bool>> subPermissionStates = [];
  List<List<List<bool>>> innerPermissionStates = [];
  List permissionList = [];
  bool isLoading = false;
  List<List<bool>> childKey = [];
  List<List<bool>> SubchildKey = [];
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      setState(() {
        isLoading = true;
        permissions = sp.getString(PERMISSIONS)!;
      });
      simpleModel.type = 'view';
      newService.permissionView(simpleModel).then((value) {
        permissionResponse = value;

        if (value.error == false) {
          setState(() {
            permissionList = permissionResponse.data!;

            // Initialize states for main, sub, and inner permissions
            for (int i = 0; i < permissionList.length; i++) {
              mainPermissionStates.add(false);

              List<bool> tempSubPermission = [];
              List<List<bool>> tempInnerPermission = [];

              for (int j = 0; j < permissionList[i].subHeads!.length; j++) {
                tempSubPermission.add(false);

                List<bool> innerPermissions = [];
                for (int k = 0;
                    k < permissionList[i].subHeads![j].subInnerheads.length;
                    k++) {
                  innerPermissions.add(false);
                }
                tempInnerPermission.add(innerPermissions);
              }
              subPermissionStates.add(tempSubPermission);
              innerPermissionStates.add(tempInnerPermission);
            }

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
    } else if (permissions.contains('manage_user')) {
      return SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            automaticallyImplyLeading: babkbutton,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/ManageUser');
                }),
            title: Responsive.isDesktop(context)
                ? const Text(
                    'Add User',
                    style: TextStyle(color: Colors.white),
                  )
                : const Text(
                    'Add User',
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
                            child: SingleChildScrollView(
                              child: SizedBox(
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: permissions.contains('add_user')
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              GridView.count(
                                                crossAxisCount: crocesscount,
                                                childAspectRatio: childAspect,
                                                shrinkWrap: true,
                                                mainAxisSpacing: 5,
                                                crossAxisSpacing: 15,
                                                children: [
                                                  TextFormField(
                                                    controller: nameController,
                                                    keyboardType:
                                                        TextInputType.name,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText: ' Name',
                                                      hintText: 'Enter Name',
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        mobileController,
                                                    keyboardType:
                                                        TextInputType.phone,
                                                    maxLength: 10,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText: ' Mobile',
                                                      hintText: 'Enter Mobile',
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
                                                      labelText: ' Email',
                                                      hintText: 'Enter Email',
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        usernameController,
                                                    keyboardType:
                                                        TextInputType.name,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText: ' Username',
                                                      hintText:
                                                          'Enter Username',
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller: passController,
                                                    keyboardType: TextInputType
                                                        .visiblePassword,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText: ' Password',
                                                      hintText:
                                                          'Enter Password',
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        confirmPassController,
                                                    keyboardType: TextInputType
                                                        .visiblePassword,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText:
                                                          ' Confirm Password',
                                                      hintText:
                                                          'Enter Confirm Password',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "Permissions",
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount:
                                                    permissionList.length,
                                                itemBuilder: (context, index) {
                                                  return Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          10,
                                                                      horizontal:
                                                                          8),
                                                              child: Row(
                                                                children: [
                                                                  Checkbox(
                                                                    value: mainPermissionStates[
                                                                        index],
                                                                    activeColor:
                                                                        Theme.of(context)
                                                                            .primaryColor,
                                                                    onChanged:
                                                                        (value) {
                                                                      onMainPermissionChanged(
                                                                          index,
                                                                          value!);
                                                                    },
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      permissionList[index]
                                                                              .head ??
                                                                          '',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              14),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          IconButton(
                                                            icon: Icon(
                                                              mainPermissionStates[
                                                                      index]
                                                                  ? Icons
                                                                      .keyboard_arrow_down
                                                                  : Icons
                                                                      .keyboard_arrow_right,
                                                              color:
                                                                  Colors.brown,
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                                mainPermissionStates[
                                                                        index] =
                                                                    !mainPermissionStates[
                                                                        index];
                                                              });
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                      if (mainPermissionStates[
                                                          index])
                                                        ListView.builder(
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          shrinkWrap: true,
                                                          itemCount:
                                                              permissionList[
                                                                      index]
                                                                  .subHeads!
                                                                  .length,
                                                          itemBuilder: (context,
                                                              subIndex) {
                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          20.0),
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Checkbox(
                                                                        value: subPermissionStates[index]
                                                                            [
                                                                            subIndex],
                                                                        activeColor:
                                                                            Theme.of(context).primaryColor,
                                                                        onChanged:
                                                                            (value) {
                                                                          onSubPermissionChanged(
                                                                              index,
                                                                              subIndex,
                                                                              value!);
                                                                        },
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Text(
                                                                          permissionList[index].subHeads![subIndex].child ??
                                                                              '',
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 14),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  // Inner permissions level
                                                                  ListView
                                                                      .builder(
                                                                    physics:
                                                                        NeverScrollableScrollPhysics(),
                                                                    shrinkWrap:
                                                                        true,
                                                                    itemCount: permissionList[
                                                                            index]
                                                                        .subHeads![
                                                                            subIndex]
                                                                        .subInnerheads
                                                                        .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            innerIndex) {
                                                                      return Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            left:
                                                                                20.0),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Checkbox(
                                                                              value: innerPermissionStates[index][subIndex][innerIndex],
                                                                              activeColor: Theme.of(context).primaryColor,
                                                                              onChanged: (value) {
                                                                                onInnerPermissionChanged(index, subIndex, innerIndex, value!);
                                                                              },
                                                                            ),
                                                                            Expanded(
                                                                              child: Text(
                                                                                permissionList[index].subHeads![subIndex].subInnerheads[innerIndex].subchild!.replaceAll("_", " "),
                                                                                style: TextStyle(color: Colors.black, fontSize: 14),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                    ],
                                                  );
                                                },
                                              ),
                                              const SizedBox(
                                                height: 25,
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
                                                            if (nameController
                                                                .text.isEmpty) {
                                                              AppUtil.showToast(
                                                                  "Please Enter Name",
                                                                  "e");
                                                            } else if (mobileController
                                                                .text.isEmpty) {
                                                              AppUtil.showToast(
                                                                  "Please Enter Mobile Number",
                                                                  "e");
                                                            } else if (emailController
                                                                .text.isEmpty) {
                                                              AppUtil.showToast(
                                                                  "Please Enter Email ID",
                                                                  "e");
                                                            } else if (usernameController
                                                                .text.isEmpty) {
                                                              AppUtil.showToast(
                                                                  "Please Enter Username",
                                                                  "e");
                                                            } else if (passController
                                                                .text.isEmpty) {
                                                              AppUtil.showToast(
                                                                  "Please Enter Password",
                                                                  "e");
                                                            } else if (passController
                                                                    .text
                                                                    .length <
                                                                6) {
                                                              AppUtil.showToast(
                                                                  "Password must be atleast 6 characters",
                                                                  "e");
                                                            } else if (confirmPassController
                                                                .text.isEmpty) {
                                                              AppUtil.showToast(
                                                                  "Please Enter Confirm Password",
                                                                  "e");
                                                            } else if (passController
                                                                    .text !=
                                                                confirmPassController
                                                                    .text) {
                                                              AppUtil.showToast(
                                                                  "Please enter correct password",
                                                                  "e");
                                                            } else if (getFormattedCheckedPermissions()
                                                                .isEmpty) {
                                                              AppUtil.showToast(
                                                                  "Please give atleat one permission",
                                                                  "e");
                                                            } else {
                                                              addUserRequest
                                                                  .type = 'add';
                                                              addUserRequest
                                                                      .name =
                                                                  nameController
                                                                      .text
                                                                      .trim();
                                                              addUserRequest
                                                                      .mobile =
                                                                  mobileController
                                                                      .text
                                                                      .trim();
                                                              addUserRequest
                                                                      .email =
                                                                  emailController
                                                                      .text
                                                                      .trim();
                                                              addUserRequest
                                                                      .username =
                                                                  usernameController
                                                                      .text
                                                                      .trim();
                                                              addUserRequest
                                                                      .password =
                                                                  passController
                                                                      .text
                                                                      .trim();
                                                              addUserRequest
                                                                      .permission =
                                                                  getFormattedCheckedPermissions()
                                                                      .trim();

                                                              newService
                                                                  .addUser(
                                                                      addUserRequest)
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
                                                                      '/ManageUser');
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

  // Handle inner permission change with auto sub-permission check
  void onInnerPermissionChanged(
      int mainIndex, int subIndex, int innerIndex, bool isChecked) {
    setState(() {
      innerPermissionStates[mainIndex][subIndex][innerIndex] = isChecked;

      // Automatically check sub-permission if any inner permission is checked
      if (isChecked) {
        subPermissionStates[mainIndex][subIndex] = true;
      } else {
        // Check if any inner permission is still checked
        bool anyInnerChecked =
            innerPermissionStates[mainIndex][subIndex].contains(true);
        subPermissionStates[mainIndex][subIndex] = anyInnerChecked;
      }
    });
  }

  // Handle sub-permission change with auto main-permission check
  void onSubPermissionChanged(int mainIndex, int subIndex, bool isChecked) {
    setState(() {
      subPermissionStates[mainIndex][subIndex] = isChecked;

      // Check all inner permissions under this sub-permission
      for (int k = 0;
          k <
              permissionList[mainIndex]
                  .subHeads![subIndex]
                  .subInnerheads
                  .length;
          k++) {
        innerPermissionStates[mainIndex][subIndex][k] = isChecked;
      }
    });
  }

  // Handle main permission change
  void onMainPermissionChanged(int index, bool isChecked) {
    setState(() {
      mainPermissionStates[index] = isChecked;

      // Update all sub and inner permissions based on main permission check
      for (int j = 0; j < permissionList[index].subHeads!.length; j++) {
        subPermissionStates[index][j] = isChecked;
        for (int k = 0;
            k < permissionList[index].subHeads![j].subInnerheads.length;
            k++) {
          innerPermissionStates[index][j][k] = isChecked;
        }
      }
    });
  }

  // Function to collect all checked permissions and format them
  String getFormattedCheckedPermissions() {
    List<String> checkedPermissions = [];

    // Loop through main permissions
    for (int i = 0; i < mainPermissionStates.length; i++) {
      if (mainPermissionStates[i]) {
        // Add main permission `p_per` if checked
        if (permissionList[i].pPer != null) {
          checkedPermissions.add(permissionList[i].pPer!);
        }

        // Loop through sub-permissions
        for (int j = 0; j < subPermissionStates[i].length; j++) {
          if (subPermissionStates[i][j]) {
            // Add sub-permission `c_per` if checked
            if (permissionList[i].subHeads![j].cPer != null) {
              checkedPermissions.add(permissionList[i].subHeads![j].cPer);
            }

            // Loop through inner permissions
            for (int k = 0; k < innerPermissionStates[i][j].length; k++) {
              if (innerPermissionStates[i][j][k]) {
                // Add inner permission `s_per` if checked
                if (permissionList[i].subHeads![j].subInnerheads[k].sPer !=
                    null) {
                  checkedPermissions.add(
                      permissionList[i].subHeads![j].subInnerheads[k].sPer!);
                }
              }
            }
          }
        }
      }
    }

    // Format the permissions as a single comma-separated string
    return checkedPermissions.join(',');
  }
}
