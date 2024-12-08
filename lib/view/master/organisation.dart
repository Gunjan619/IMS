import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;

import 'package:gims/api/AppCommonVariable.dart';
import 'package:gims/api/webService.dart';
import 'package:gims/api/webUrl.dart';
import 'package:gims/controllers/AppUtil.dart';
import 'package:gims/model/Request/organisationUpdateRequest.dart';
import 'package:gims/model/Request/simpleRequest.dart';
import 'package:gims/model/Response/SimpleResponse.dart';
import 'package:gims/model/Response/organisationResponse.dart';
import 'package:gims/responsive.dart';
import 'package:gims/view/home/sidebar.dart';

class Organisation extends StatefulWidget {
  const Organisation({super.key});

  @override
  State<Organisation> createState() => _OrganisationState();
}

class _OrganisationState extends State<Organisation> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController branchController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController boysHostelController = TextEditingController();
  TextEditingController boysHostelAddressController = TextEditingController();
  TextEditingController girlsHostelController = TextEditingController();
  TextEditingController girlsHostelAddressController = TextEditingController();
  var _selectedImage;
  int crocesscount = 0;
  double childAspect = 0.00;
  bool babkbutton = false;
  bool isLoading = false;
  late ImagePicker _picker;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  SimpleModel requestModel = SimpleModel("");
  organisationResponse OrganisationResponse = organisationResponse();
  OrganisationUpdateModel updateRequest =
      OrganisationUpdateModel("", "", "", "", "", "", "", "", "", "", "", "");
  SimpleResponse simpleResponse = SimpleResponse();
  final Webservice _service = Webservice();
  List departList = [];
  String departmentId = "";
  String userId = "";
  String logo = "";
  var _selectedFile;
  Uint8List? _imageBytes;

  void _handleImageUpload(html.File file) {
    final reader = html.FileReader();
    reader.onLoadEnd.listen((e) {
      setState(() {
        _imageBytes = reader.result as Uint8List?;
      });
    });

    reader.readAsArrayBuffer(file);
  }

  void _openFilePicker() {
    final input = html.FileUploadInputElement()..accept = 'image/*';
    input.click();

    input.onChange.listen((e) {
      final files = input.files;
      if (files!.isNotEmpty) {
        setState(() {
          _selectedFile = files[0];
        });
        _handleImageUpload(_selectedFile!);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    isLoading = true;
    _picker = ImagePicker();
    requestModel.type = 'view';

    _service.organisation(requestModel).then((value) {
      OrganisationResponse = value;

      if (value.error == false) {
        setState(() {
          nameController.text = OrganisationResponse.name!;
          branchController.text = OrganisationResponse.address!;
          cityController.text = OrganisationResponse.city!;
          stateController.text = OrganisationResponse.state!;
          addressController.text = OrganisationResponse.address2!;
          mobileController.text = OrganisationResponse.phone!;
          emailController.text = OrganisationResponse.email!;
          boysHostelController.text = OrganisationResponse.hostelBoys!;
          boysHostelAddressController.text =
              OrganisationResponse.hostelBoysaddress!;
          girlsHostelController.text = OrganisationResponse.hostelGirls!;
          girlsHostelAddressController.text =
              OrganisationResponse.hostelGirlsaddress!;
          logo = OrganisationResponse.logo!;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      userId = sp.getString(USER_ID) == null ? "" : sp.getString(USER_ID)!;
    });
  }

  void _submitForm() async {
    if (nameController.text.isEmpty) {
      AppUtil.showToast("Please Enter Name", "e");
    } else if (mobileController.text.isEmpty) {
      AppUtil.showToast("Please Enter Mobile Number", "e");
    } else if (emailController.text.isEmpty) {
      AppUtil.showToast("Please Enter Email Address", "e");
    } else {
      var mFile;
      try {
        if (kIsWeb) {
          if (_imageBytes != null) {
            mFile = http.MultipartFile.fromBytes('image', _imageBytes!,
                //filename: _selectedFile.toString(),
                filename: _imageBytes.toString().split("/").last);
          }
        } else {
          if (_selectedImage != null) {
            mFile = http.MultipartFile.fromBytes(
                'image', _selectedImage.readAsBytesSync(),
                filename: _selectedImage.toString().split("/").last);
          }
        }
      } catch (e) {
        print('Error creating multipart file: $e');
      }
      //print(_selectedFile.toString());
      updateRequest.type = 'edit';
      updateRequest.name = nameController.text.toString();
      updateRequest.branch = branchController.text.toString();
      updateRequest.city = cityController.text.toString();
      updateRequest.state = stateController.text.toString();
      updateRequest.address = addressController.text.toString();
      updateRequest.mobile = mobileController.text.toString();
      updateRequest.email = emailController.text.toString();
      updateRequest.boysHostel = boysHostelController.text.toString();
      updateRequest.boysHostelAddress =
          boysHostelAddressController.text.toString();
      updateRequest.girlsHostel = girlsHostelController.text.toString();
      updateRequest.girlsHostelAddress =
          girlsHostelAddressController.text.toString();

      final value = await _service.organisationUpdate(updateRequest, mFile);
      isLoading = true;
      if (value.error == false) {
        setState(() {
          isLoading = false;
          AppUtil.showToast(value.msg.toString(), 'i');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Responsive.isDesktop(context)) {
      childAspect = 10 / 0.9;
      babkbutton = false;
    } else if (Responsive.isTablet(context)) {
      childAspect = 10 / 0.9;
      babkbutton = false;
    } else {
      childAspect = 11 / 2;
      babkbutton = true;
    }
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          automaticallyImplyLeading: babkbutton,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          title: Responsive.isDesktop(context)
              ? const Text(
                  'Organisation Details',
                  style: TextStyle(color: Colors.white),
                )
              : const Text(
                  'Organisation Details',
                  style: TextStyle(color: Colors.white),
                ),
        ),
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // If you want a side menu for large screens, include it here
              if (Responsive.isDesktop(context))
                const Expanded(
                  // default flex = 1
                  // and it takes 1/6 part of the screen
                  child: DrawerMenu(),
                ),
              Expanded(
                flex: 5,
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
                          ),
                        )
                      : SingleChildScrollView(
                          child: SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  GridView.count(
                                    physics: NeverScrollableScrollPhysics(),
                                    crossAxisCount:
                                        Responsive.isDesktop(context) ? 2 : 1,
                                    childAspectRatio: childAspect,
                                    shrinkWrap: true,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    children: [
                                      TextFormField(
                                        controller: nameController,
                                        keyboardType: TextInputType.name,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal:
                                                  Responsive.isDesktop(context)
                                                      ? 5
                                                      : 15,
                                              vertical:
                                                  Responsive.isDesktop(context)
                                                      ? 5
                                                      : 15),
                                          border: OutlineInputBorder(),
                                          labelText: ' Organisation Name',
                                          hintText: 'Enter Organisation Name',
                                        ),
                                      ),
                                      TextFormField(
                                        controller: branchController,
                                        keyboardType: TextInputType.name,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal:
                                                  Responsive.isDesktop(context)
                                                      ? 5
                                                      : 15,
                                              vertical:
                                                  Responsive.isDesktop(context)
                                                      ? 5
                                                      : 15),
                                          border: OutlineInputBorder(),
                                          labelText: ' Branch Name',
                                          hintText: 'Enter Branch Name',
                                        ),
                                      ),
                                      TextFormField(
                                        controller: cityController,
                                        keyboardType: TextInputType.name,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal:
                                                  Responsive.isDesktop(context)
                                                      ? 5
                                                      : 15,
                                              vertical:
                                                  Responsive.isDesktop(context)
                                                      ? 5
                                                      : 15),
                                          border: OutlineInputBorder(),
                                          labelText: ' City',
                                          hintText: 'Enter City',
                                        ),
                                      ),
                                      TextFormField(
                                        controller: stateController,
                                        keyboardType: TextInputType.name,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal:
                                                  Responsive.isDesktop(context)
                                                      ? 5
                                                      : 15,
                                              vertical:
                                                  Responsive.isDesktop(context)
                                                      ? 5
                                                      : 15),
                                          border: OutlineInputBorder(),
                                          labelText: ' State',
                                          hintText: 'Enter State',
                                        ),
                                      ),
                                      TextFormField(
                                        controller: addressController,
                                        keyboardType: TextInputType.name,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal:
                                                  Responsive.isDesktop(context)
                                                      ? 5
                                                      : 15,
                                              vertical:
                                                  Responsive.isDesktop(context)
                                                      ? 5
                                                      : 15),
                                          border: OutlineInputBorder(),
                                          labelText: ' Address',
                                          hintText: 'Enter Address',
                                        ),
                                      ),
                                      TextFormField(
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        controller: mobileController,
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal:
                                                  Responsive.isDesktop(context)
                                                      ? 5
                                                      : 15,
                                              vertical:
                                                  Responsive.isDesktop(context)
                                                      ? 5
                                                      : 15),
                                          border: OutlineInputBorder(),
                                          labelText: ' Mobile Number',
                                          hintText: 'Enter Mobile Number',
                                        ),
                                      ),
                                      TextFormField(
                                        controller: emailController,
                                        keyboardType: TextInputType.name,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal:
                                                  Responsive.isDesktop(context)
                                                      ? 5
                                                      : 15,
                                              vertical:
                                                  Responsive.isDesktop(context)
                                                      ? 5
                                                      : 15),
                                          border: OutlineInputBorder(),
                                          labelText: ' Email',
                                          hintText: 'Enter Email Id',
                                        ),
                                      ),
                                      TextFormField(
                                        controller: boysHostelController,
                                        keyboardType: TextInputType.name,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal:
                                                  Responsive.isDesktop(context)
                                                      ? 5
                                                      : 15,
                                              vertical:
                                                  Responsive.isDesktop(context)
                                                      ? 5
                                                      : 15),
                                          border: OutlineInputBorder(),
                                          labelText: ' Boys Hostel Name',
                                          hintText: 'Enter Boys Hostel Name',
                                        ),
                                      ),
                                      TextFormField(
                                        controller: boysHostelAddressController,
                                        keyboardType: TextInputType.name,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal:
                                                  Responsive.isDesktop(context)
                                                      ? 5
                                                      : 15,
                                              vertical:
                                                  Responsive.isDesktop(context)
                                                      ? 5
                                                      : 15),
                                          border: OutlineInputBorder(),
                                          labelText: ' Boys Hostel Address',
                                          hintText: 'Enter Boys Hostel Address',
                                        ),
                                      ),
                                      TextFormField(
                                        controller: girlsHostelController,
                                        keyboardType: TextInputType.name,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal:
                                                  Responsive.isDesktop(context)
                                                      ? 5
                                                      : 15,
                                              vertical:
                                                  Responsive.isDesktop(context)
                                                      ? 5
                                                      : 15),
                                          border: OutlineInputBorder(),
                                          labelText: ' Girls Hostel Name',
                                          hintText: 'Enter Girls Hostel Name',
                                        ),
                                      ),
                                      TextFormField(
                                        controller:
                                            girlsHostelAddressController,
                                        keyboardType: TextInputType.name,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal:
                                                  Responsive.isDesktop(context)
                                                      ? 5
                                                      : 15,
                                              vertical:
                                                  Responsive.isDesktop(context)
                                                      ? 5
                                                      : 15),
                                          border: OutlineInputBorder(),
                                          labelText: ' Girls Hostel Address',
                                          hintText:
                                              'Enter Girls Hostel Address',
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 1,
                                            color: const Color.fromARGB(
                                              255,
                                              163,
                                              163,
                                              163,
                                            ),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 15),
                                          child: Row(
                                            children: [
                                              ElevatedButton(
                                                style: ButtonStyle(
                                                  elevation: WidgetStateProperty
                                                      .resolveWith<double?>(
                                                    (Set<WidgetState> states) {
                                                      return 10;
                                                    },
                                                  ),
                                                  backgroundColor:
                                                      WidgetStateProperty
                                                          .resolveWith<Color?>(
                                                    (Set<WidgetState> states) {
                                                      if (states.contains(
                                                          WidgetState
                                                              .pressed)) {
                                                        return Theme.of(context)
                                                            .primaryColor;
                                                      }
                                                      return Theme.of(context)
                                                          .primaryColor;
                                                    },
                                                  ),
                                                ),
                                                onPressed: kIsWeb
                                                    ? _openFilePicker
                                                    : _showPicker,
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Icon(
                                                      Icons.add_a_photo,
                                                      color: Colors.white,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      'Choose Image',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: Responsive.isDesktop(
                                                        context)
                                                    ? 200
                                                    : 120,
                                                height: Responsive.isDesktop(
                                                        context)
                                                    ? 200
                                                    : 120,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  child: kIsWeb
                                                      ? _imageBytes != null
                                                          ? Image.memory(
                                                              _imageBytes!,
                                                            )
                                                          : logo != ''
                                                              ? Image.network(
                                                                  ORGANISATION_IMAGE +
                                                                      logo)
                                                              : Image.asset(
                                                                  "assets/no-image.jpg")
                                                      : _selectedImage != null
                                                          ? Image.file(
                                                              _selectedImage,
                                                              fit: BoxFit
                                                                  .contain,
                                                            )
                                                          : logo != ''
                                                              ? Image.network(
                                                                  ORGANISATION_IMAGE +
                                                                      logo)
                                                              : Image.asset(
                                                                  "assets/no-image.jpg"),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: 130.0,
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStateProperty
                                                      .resolveWith<Color?>(
                                                (Set<MaterialState> states) {
                                                  if (states.contains(
                                                      MaterialState.pressed)) {
                                                    return Theme.of(context)
                                                        .primaryColor;
                                                  }
                                                  return Theme.of(context)
                                                      .primaryColor;
                                                },
                                              ),
                                            ),
                                            onPressed: _submitForm,
                                            child: const Padding(
                                              padding: EdgeInsets.only(
                                                  top: 9.0, bottom: 9.0),
                                              child: Text(
                                                'Submit',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
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

  void _showPicker() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Photo Library'),
                  onTap: () async {
                    Navigator.of(context)
                        .pop(); // Close the modal before opening the picker
                    await _imgFromGallery();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () async {
                    Navigator.of(context)
                        .pop(); // Close the modal before opening the picker
                    await _imgFromCamera();
                  },
                ),
              ],
            ),
          );
        });
  }

// member photo

  Future<void> _requestPermissions() async {
    if (await Permission.camera.isDenied) {
      await Permission.camera.request();
    }

    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    }
  }

  Future<void> _imgFromGallery() async {
    await _requestPermissions(); // Request permissions first

    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _imgFromCamera() async {
    await _requestPermissions(); // Request permissions first

    final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        preferredCameraDevice: CameraDevice.rear);

    if (photo != null) {
      setState(() {
        _selectedImage = File(photo.path);
      });
    }
  }
}
