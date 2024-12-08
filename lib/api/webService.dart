import 'dart:convert';

import 'package:gims/api/webUrl.dart';
import 'package:gims/controllers/appUtil.dart';
import 'package:gims/model/Request/addCollectionRequest.dart';
import 'package:gims/model/Request/addCourseRequest.dart';
import 'package:gims/model/Request/addDegreeRequest.dart';
import 'package:gims/model/Request/addHolidayRequest.dart';
import 'package:gims/model/Request/addSalaryStructureRequest.dart';
import 'package:gims/model/Request/addSessionRequest.dart';
import 'package:gims/model/Request/addSlabRequest.dart';
import 'package:gims/model/Request/addStaffAttendanceRequest.dart';
import 'package:gims/model/Request/addStaffRequest.dart';
import 'package:gims/model/Request/addStructureRequest.dart';
import 'package:gims/model/Request/addStudentRequest.dart';
import 'package:gims/model/Request/addUserRequest.dart';
import 'package:gims/model/Request/addYearRequest.dart';
import 'package:gims/model/Request/blockStuRequest.dart';
import 'package:gims/model/Request/courseFilterRequest.dart';
import 'package:gims/model/Request/deleteCollectionRequest.dart';
import 'package:gims/model/Request/deleteHolidayRequest.dart';
import 'package:gims/model/Request/deleteRequest.dart';
import 'package:gims/model/Request/deleteStudentRequest.dart';
import 'package:gims/model/Request/editCourseRequest.dart';
import 'package:gims/model/Request/editDegreeRequest.dart';
import 'package:gims/model/Request/editHolidayRequest.dart';
import 'package:gims/model/Request/editSalaryStructureRequest.dart';
import 'package:gims/model/Request/editSessionRequest.dart';
import 'package:gims/model/Request/editSlabRequest.dart';
import 'package:gims/model/Request/editStaffAttendanceRequest.dart';
import 'package:gims/model/Request/editStaffRequest.dart';
import 'package:gims/model/Request/editStructureRequest.dart';
import 'package:gims/model/Request/editStudentRequest.dart';
import 'package:gims/model/Request/editUserRequest.dart';
import 'package:gims/model/Request/editYearRequest.dart';
import 'package:gims/model/Request/feeCollectionReportRequest.dart';
import 'package:gims/model/Request/feePendingRequest.dart';
import 'package:gims/model/Request/filterStaffAttendanceRequest.dart';
import 'package:gims/model/Request/loginRequest.dart';
import 'package:gims/model/Request/manageStaffAttendanceRequest.dart';
import 'package:gims/model/Request/organisationUpdateRequest.dart';
import 'package:gims/model/Request/paymentRequest.dart';
import 'package:gims/model/Request/printReceiptRequest.dart';
import 'package:gims/model/Request/sessionRequest.dart';
import 'package:gims/model/Request/simpleRequest.dart';
import 'package:gims/model/Request/singleStaffRequest.dart';
import 'package:gims/model/Request/staffFilterRequest.dart';
import 'package:gims/model/Request/stuDueRequest.dart';
import 'package:gims/model/Request/studentFilterRequest.dart';
import 'package:gims/model/Request/studentListRequest.dart';
import 'package:gims/model/Request/studentRequest.dart';
import 'package:gims/model/Request/transferYearRequest.dart';
import 'package:gims/model/Request/yearRequest.dart';
import 'package:gims/model/Response/SimpleResponse.dart';
import 'package:gims/model/Response/collectionResponse.dart';
import 'package:gims/model/Response/courseResponse.dart';
import 'package:gims/model/Response/dashCollectionResponse.dart';
import 'package:gims/model/Response/dashExpenseResponse.dart';
import 'package:gims/model/Response/degreeResponse.dart';
import 'package:gims/model/Response/feeCollectionReportResponse.dart';
import 'package:gims/model/Response/feePendingReportResponse.dart';
import 'package:gims/model/Response/feeStructureResponse.dart';
import 'package:gims/model/Response/holidayResponse.dart';
import 'package:gims/model/Response/invoiceResponse.dart';
import 'package:gims/model/Response/lastExamYearResponse.dart';
import 'package:gims/model/Response/loginResponse.dart';
import 'package:gims/model/Response/manageFilterSlab.dart';
import 'package:gims/model/Response/manageSlabResponse.dart';
import 'package:gims/model/Response/manageStaffAttendanceResponse.dart';
import 'package:gims/model/Response/organisationResponse.dart';
import 'package:gims/model/Response/paymentResponse.dart';
import 'package:gims/model/Response/permissionResponse.dart';
import 'package:gims/model/Response/printReceiptResponse.dart';
import 'package:gims/model/Response/salaryStructureResponse.dart';
import 'package:gims/model/Response/sessionResponse.dart';
import 'package:gims/model/Response/singleStaffResponse.dart';
import 'package:gims/model/Response/staffResponse.dart';
import 'package:gims/model/Response/stuDueResponse.dart';
import 'package:gims/model/Response/studentListResponse.dart';
import 'package:gims/model/Response/studentResponse.dart';
import 'package:gims/model/Response/userResponse.dart';
import 'package:gims/model/Response/yearResponse.dart';
import 'package:gims/view/staff/bulkStaffAttendance.dart';
import 'package:gims/view/staff/editbulkStaffAttendance.dart';
import 'package:http/http.dart' as http;

class Webservice {
  Future permissionView(SimpleModel requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = PERMISSION_API;
    final apiURI = Uri.parse(authority + apiUrl);
    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI);
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());
    final response = await http.post(apiURI, body: requestModel.toJson());

    if (response.statusCode == 200 || response.statusCode == 400) {
      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(json.decode(response.body));
      int statusCode = response.statusCode;
      AppUtil.appLogs("--------------Status Code---------------");
      AppUtil.appLogs(statusCode);
      final PermissionResponse LoginResponse;
      if (statusCode == 200) {
        LoginResponse = PermissionResponse.fromJson(json.decode(response.body));
        return LoginResponse;
      } else {
        throw Exception('Failed to load data!');
        // return loginResponse;
      }
    } else {
      throw Exception('Failed to load data!');
    }
  }

  Future login(LoginModel requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = LOGIN_URL;
    final apiURI = Uri.parse(authority + apiUrl);
    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI);
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());
    final response = await http.post(apiURI, body: requestModel.toJson());

    if (response.statusCode == 200 || response.statusCode == 400) {
      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(json.decode(response.body));
      int statusCode = response.statusCode;
      AppUtil.appLogs("--------------Status Code---------------");
      AppUtil.appLogs(statusCode);
      final loginResponse LoginResponse;
      if (statusCode == 200) {
        LoginResponse = loginResponse.fromJson(json.decode(response.body));
        return LoginResponse;
      } else {
        throw Exception('Failed to load data!');
        // return loginResponse;
      }
    } else {
      throw Exception('Failed to load data!');
    }
  }

  Future organisation(SimpleModel requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = ORGANISATION;
    final apiURI = Uri.parse(authority + apiUrl);
    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI);
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());
    final response = await http.post(apiURI, body: requestModel.toJson());

    if (response.statusCode == 200 || response.statusCode == 400) {
      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(json.decode(response.body));
      int statusCode = response.statusCode;
      AppUtil.appLogs("--------------Status Code---------------");
      AppUtil.appLogs(statusCode);
      final organisationResponse OrganisationResponse;
      if (statusCode == 200) {
        OrganisationResponse =
            organisationResponse.fromJson(json.decode(response.body));
        return OrganisationResponse;
      } else {
        throw Exception('Failed to load data!');
        // return loginResponse;
      }
    } else {
      throw Exception('Failed to load data!');
    }
  }

  Future organisationUpdate(
      OrganisationUpdateModel requestModel, var mFile) async {
    const String authority = BASE_URL;
    const String apiUrl = ORGANISATION;
    final apiURI = http.MultipartRequest("POST", Uri.parse(authority + apiUrl));
    apiURI.fields['name'] = requestModel.name;
    apiURI.fields['branch'] = requestModel.branch;
    apiURI.fields['city'] = requestModel.city;
    apiURI.fields['state'] = requestModel.state;
    apiURI.fields['address'] = requestModel.address;
    apiURI.fields['mobile'] = requestModel.mobile;
    apiURI.fields['email'] = requestModel.email;
    apiURI.fields['boysHostel'] = requestModel.boysHostel;
    apiURI.fields['boysHostelAddress'] = requestModel.boysHostelAddress;
    apiURI.fields['girlsHostel'] = requestModel.girlsHostel;
    apiURI.fields['girlsHostelAddress'] = requestModel.girlsHostelAddress;

    // if (mFile != null) {
    //   apiURI.files.add(http.MultipartFile.fromBytes(
    //     'image',
    //     await File(mFile).readAsBytesSync(),
    //     //filename: mFile.split("/").last,
    //   ));
    // }
    if (mFile != null) {
      AppUtil.appLogs("--------------Sending Image File Also---------------");
      apiURI.files.add(mFile);
      AppUtil.appLogs(requestModel.toString());
    }
    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI);
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());
    http.Response response =
        await http.Response.fromStream(await apiURI.send());

    if (response.statusCode == 200 || response.statusCode == 400) {
      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(json.decode(response.body));
      int statusCode = response.statusCode;
      AppUtil.appLogs("--------------Status Code---------------");
      AppUtil.appLogs(statusCode);
      final SimpleResponse addDepartmentResponse;
      if (statusCode == 200) {
        addDepartmentResponse =
            SimpleResponse.fromJson(json.decode(response.body));
        return addDepartmentResponse;
      } else {
        throw Exception('Failed to load data!');
        // return loginResponse;
      }
    } else {
      throw Exception('Failed to load data!');
    }
  }

  Future<SessionResponse> session(SimpleModel requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = SESSION_REPORT;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SessionResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SessionResponse> sessionFilter(SessionRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = SESSION_REPORT;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SessionResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SessionResponse> sessionGroup(SimpleModel requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = SESSION_GROUP;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SessionResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> deleteSession(DeleteRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = DELETE_SESSION;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> addSession(AddSessionRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = ADD_SESSION;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> editSession(EditSessionRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = EDIT_SESSION;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<CourseResponse> course(SimpleModel requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = COURSE_REPORT;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return CourseResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<DashCollectionResponse> dashCollection(
      SimpleModel requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = DASHCOLLECT_REPORT;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return DashCollectionResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<DashExpenseResponse> dashExpense(SimpleModel requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = DASHEXPENSE_REPORT;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return DashExpenseResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<UserResponse> manageUser(SimpleModel requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = MANAGE_USER;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return UserResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> addUser(AddUserRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = ADD_USER;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> editUser(EditUserRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = EDIT_USER;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<DegreeResponse> degree(SimpleModel requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = MANAGE_DEGREE;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return DegreeResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> addDegree(AddDegreeRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = ADD_DEGREE;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> deleteDegree(DeleteRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = DELETE_DEGREE;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> editDegree(EditDegreeRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = EDIT_DEGREE;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<CourseResponse> courseManage(SimpleModel requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = MANAGE_COURSE;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return CourseResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<CourseResponse> courseManageFilter(
      CourseFilterRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = MANAGE_COURSE;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return CourseResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> addCourse(AddCourseRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = ADD_COURSE;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> editCourse(EditCourseRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = EDIT_COURSE;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> deleteCourse(DeleteRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = DELETE_COURSE;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<YearResponse> yearManage(SimpleModel requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = MANAGE_YEAR;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return YearResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<YearResponse> yearFilter(YearRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = MANAGE_YEAR;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return YearResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> addYear(AddYearRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = ADD_YEAR;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> editYear(EditYearRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = EDIT_YEAR;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> deleteYear(DeleteRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = DELETE_YEAR;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<LastExamYearResponse> lastExam(SimpleModel requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = LAST_EXAM_YEAR;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return LastExamYearResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> addLastExam(AddDegreeRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = ADD_LAST_EXAM;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> editLastExam(EditDegreeRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = EDIT_LAST_EXAM;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> deleteLastExam(DeleteRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = DELETE_LAST_EXAM;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<DegreeResponse> manageFeeName(SimpleModel requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = MANAGE_FEE_NAME;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return DegreeResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> addFeeName(AddDegreeRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = ADD_FEE_NAME;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> editFeeName(EditDegreeRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = EDIT_FEE_NAME;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> deleteFeeName(DeleteRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = DELETE_FEE_NAME;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<FeeStructureResponse> feeStructure(SimpleModel requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = FEE_STRUCTURE;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return FeeStructureResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> addStructure(AddStructureRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = ADD_STRUCTURE;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> editStructure(
      EditStructureRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = EDIT_STRUCTURE;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<DegreeResponse> religion(SimpleModel requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = MANAGE_RELIGION;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return DegreeResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> addReligion(AddDegreeRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = ADD_RELIGION;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> editReligion(EditDegreeRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = EDIT_RELIGION;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> deleteReligion(DeleteRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = DELETE_RELIGION;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<DegreeResponse> category(SimpleModel requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = MANAGE_CATEGORY;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return DegreeResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> addCategory(AddDegreeRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = ADD_CATEGORY;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> editCategory(EditDegreeRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = EDIT_CATEGORY;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> deleteCategory(DeleteRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = DELETE_CATEGORY;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<HolidayResponse> holiday(SimpleModel requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = MANAGE_HOLIDAY;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return HolidayResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> addHoliday(AddHolidayRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = ADD_HOLIDAY;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> editHoliday(EditHolidayRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = EDIT_HOLIDAY;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> deleteHoliday(
      DeleteHolidayRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = DELETE_HOLIDAY;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<StudentResponse> manageStudent(
      ManageStudentRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = MANAGE_STUDENT;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return StudentResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<PaymentResponse> paymentDetails(PaymentRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = PAYMENT_API;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return PaymentResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> blockStudent(BlockStudentRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = BLOCK_STUDENT;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> unblockStudent(
      BlockStudentRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = UNBLOCK_STUDENT;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future addStudent(
      AddStudentRequest requestModel, var mFile, var mFile2, var mFile3) async {
    const String authority = BASE_URL;
    const String apiUrl = ADD_STUDENT;
    final apiURI = http.MultipartRequest("POST", Uri.parse(authority + apiUrl));
    apiURI.fields['name'] = requestModel.name;
    apiURI.fields['fatherName'] = requestModel.fatherName;
    apiURI.fields['motherName'] = requestModel.motherName;
    apiURI.fields['aadharNo'] = requestModel.aadharNo;
    apiURI.fields['mobileNumber'] = requestModel.mobileNumber;
    apiURI.fields['email'] = requestModel.email;
    apiURI.fields['parentNo'] = requestModel.parentNo;
    apiURI.fields['dob'] = requestModel.dob;
    apiURI.fields['degree'] = requestModel.degree;
    apiURI.fields['course'] = requestModel.course;
    apiURI.fields['year'] = requestModel.year;
    apiURI.fields['session'] = requestModel.session;
    apiURI.fields['sessionIdd'] = requestModel.sessionIdd;
    apiURI.fields['gender'] = requestModel.gender;
    apiURI.fields['religion'] = requestModel.religion;
    apiURI.fields['category'] = requestModel.category;
    apiURI.fields['caste'] = requestModel.caste;
    apiURI.fields['medium'] = requestModel.medium;
    apiURI.fields['enrollmentNo'] = requestModel.enrollmentNo;
    apiURI.fields['address'] = requestModel.address;
    apiURI.fields['city'] = requestModel.city;
    apiURI.fields['state'] = requestModel.state;
    apiURI.fields['pincode'] = requestModel.pincode;

    if (mFile != null) {
      AppUtil.appLogs("--------------Sending Image File Also---------------");
      apiURI.files.add(mFile);
      AppUtil.appLogs(requestModel.toString());
    }
    if (mFile2 != null) {
      AppUtil.appLogs("--------------Sending Image File Also---------------");
      apiURI.files.add(mFile2);
      AppUtil.appLogs(requestModel.toString());
    }
    if (mFile3 != null) {
      AppUtil.appLogs("--------------Sending Image File Also---------------");
      apiURI.files.add(mFile3);
      AppUtil.appLogs(requestModel.toString());
    }
    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI);
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());
    http.Response response =
        await http.Response.fromStream(await apiURI.send());

    if (response.statusCode == 200 || response.statusCode == 400) {
      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(json.decode(response.body));
      int statusCode = response.statusCode;
      AppUtil.appLogs("--------------Status Code---------------");
      AppUtil.appLogs(statusCode);
      final SimpleResponse addDepartmentResponse;
      if (statusCode == 200) {
        addDepartmentResponse =
            SimpleResponse.fromJson(json.decode(response.body));
        return addDepartmentResponse;
      } else {
        throw Exception('Failed to load data!');
        // return loginResponse;
      }
    } else {
      throw Exception('Failed to load data!');
    }
  }

  Future editStudent(EditStudentRequest requestModel, var mFile, var mFile2,
      var mFile3) async {
    const String authority = BASE_URL;
    const String apiUrl = EDIT_STUDENT;
    final apiURI = http.MultipartRequest("POST", Uri.parse(authority + apiUrl));
    apiURI.fields['id'] = requestModel.id;
    apiURI.fields['name'] = requestModel.name;
    apiURI.fields['fatherName'] = requestModel.fatherName;
    apiURI.fields['motherName'] = requestModel.motherName;
    apiURI.fields['aadharNo'] = requestModel.aadharNo;
    apiURI.fields['mobileNumber'] = requestModel.mobileNumber;
    apiURI.fields['email'] = requestModel.email;
    apiURI.fields['parentNo'] = requestModel.parentNo;
    apiURI.fields['dob'] = requestModel.dob;
    apiURI.fields['degree'] = requestModel.degree;
    apiURI.fields['course'] = requestModel.course;
    apiURI.fields['year'] = requestModel.year;
    apiURI.fields['session'] = requestModel.session;
    apiURI.fields['sessionIdd'] = requestModel.sessionIdd;
    apiURI.fields['gender'] = requestModel.gender;
    apiURI.fields['religion'] = requestModel.religion;
    apiURI.fields['category'] = requestModel.category;
    apiURI.fields['caste'] = requestModel.caste;
    apiURI.fields['medium'] = requestModel.medium;
    apiURI.fields['enrollmentNo'] = requestModel.enrollmentNo;
    apiURI.fields['address'] = requestModel.address;
    apiURI.fields['city'] = requestModel.city;
    apiURI.fields['state'] = requestModel.state;
    apiURI.fields['pincode'] = requestModel.pincode;

    if (mFile != null) {
      AppUtil.appLogs("--------------Sending Image File Also---------------");
      apiURI.files.add(mFile);
      AppUtil.appLogs(requestModel.toString());
    }
    if (mFile2 != null) {
      AppUtil.appLogs("--------------Sending Image File Also---------------");
      apiURI.files.add(mFile2);
      AppUtil.appLogs(requestModel.toString());
    }
    if (mFile3 != null) {
      AppUtil.appLogs("--------------Sending Image File Also---------------");
      apiURI.files.add(mFile3);
      AppUtil.appLogs(requestModel.toString());
    }
    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI);
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());
    http.Response response =
        await http.Response.fromStream(await apiURI.send());

    if (response.statusCode == 200 || response.statusCode == 400) {
      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(json.decode(response.body));
      int statusCode = response.statusCode;
      AppUtil.appLogs("--------------Status Code---------------");
      AppUtil.appLogs(statusCode);
      final SimpleResponse addDepartmentResponse;
      if (statusCode == 200) {
        addDepartmentResponse =
            SimpleResponse.fromJson(json.decode(response.body));
        return addDepartmentResponse;
      } else {
        throw Exception('Failed to load data!');
        // return loginResponse;
      }
    } else {
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> deleteStudent(
      DeleteStudentRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = DELETE_STUDENT;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<StudentResponse> manageStudentBlocked(
      ManageStudentRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = BLOCKED_STUDENT;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return StudentResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<DegreeResponse> manageStudentFilter(
      StudentFilterRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = STUDENT_FILTER;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return DegreeResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<StuDueResponse> stuDue(StuDueRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = STUDENT_DUE;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return StuDueResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<CollectionResponse> feeCollect(
      AddCollectionRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = FEE_COLLECTION;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return CollectionResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<InvoiceResponse> stuInvoice(StuDueRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = STU_INVOICE;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return InvoiceResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<PrintReceiptResponse> printReceipt(
      PrintReceiptRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = PRINT_RECEIPT;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return PrintReceiptResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<FeeCollectionReportResponse> feeCollectReport(
      FeeCollectionReportRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = FEE_COLLECTION_REPORT;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return FeeCollectionReportResponse.fromJson(
              json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> deleteCollection(
      DeleteCollectionRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = DELETE_COLLECTION;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<FeePendingReportResponse> pendingFee(
      FeePendingRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = PENDING_FEE_REPORT;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return FeePendingReportResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<FeeCollectionReportResponse> cancelledReceipts(
      FeeCollectionReportRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = CANCELLED_RECEIPTS;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return FeeCollectionReportResponse.fromJson(
              json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<StudentListResponse> studentListApi(
      StudentListsRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = STUDENT_LIST;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return StudentListResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> transferYear(TransferYearRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = TRANSFER_YEAR;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<StaffResponse> manageStaff(StaffFilterRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = MANAGE_STAFF;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return StaffResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<DegreeResponse> filterStaff(StaffFilterRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = FILTER_STAFF;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return DegreeResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> bulkStaffAttendance(
      AddStaffAttendanceRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = STAFF_ATTENDANCE;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<ManageStaffAttendanceResponse> manageStaffAttendance(
      ManageStaffAttendanceRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = MANAGE_STAFF_ATTENDANCE;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return ManageStaffAttendanceResponse.fromJson(
              json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<ManageStaffAttendanceResponse> manageStaffAttendanceFilter(
      FilterStaffAttendanceRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = FILTER_STAFF_ATTENDANCE;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return ManageStaffAttendanceResponse.fromJson(
              json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> editStaffAttendance(
      EditStaffAttendanceRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = EDIT_STAFF_ATTENDANCE;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> addStaff(AddStaffRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = ADD_STAFF;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> deleteStaff(DeleteRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = DELETE_STAFF;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SingleStaffResponse> singleStaff(
      SingleStaffRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = SINGLE_STAFF;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SingleStaffResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> editStaff(EditStaffRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = EDIT_STAFF;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> addSlab(AddSlabRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = ADD_SLAB;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<ManageSlabResponse> manageSlab(SimpleModel requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = MANAGE_SLAB;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return ManageSlabResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> editSlab(EditSlabRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = EDIT_SLAB;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> deleteSlab(DeleteRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = DELETE_SLAB;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SalaryStructureResponse> manageStructure(
      SimpleModel requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = MANAGE_STRUCTURE;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SalaryStructureResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<ManageFilterSlab> filterSlab(SimpleModel requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = FILTER_SLAB;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return ManageFilterSlab.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> addSalaryStructure(
      AddSalaryStructureRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = ADD_SALARY_STRUCTURE;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> editSalaryStructure(
      EditSalaryStructureRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = EDIT_SALARY_STRUCTURE;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> deleteSalaryStructure(
      DeleteRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = DELETE_SALARY_STRUCTURE;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }

  Future<SimpleResponse> generateSalary(DeleteRequest requestModel) async {
    const String authority = BASE_URL;
    const String apiUrl = GENERATE_SALARY;
    final apiURI = Uri.parse(authority + apiUrl);

    AppUtil.appLogs("--------------WebService---------------");
    AppUtil.appLogs(apiURI.toString());
    AppUtil.appLogs("--------------Parameter---------------");
    AppUtil.appLogs(requestModel.toJson());

    try {
      final response = await http.post(apiURI, body: requestModel.toJson());

      AppUtil.appLogs("--------------Response---------------");
      AppUtil.appLogs(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        int statusCode = response.statusCode;
        AppUtil.appLogs("--------------Status Code---------------");
        AppUtil.appLogs(statusCode);

        if (statusCode == 200) {
          return SimpleResponse.fromJson(json.decode(response.body));
        } else {
          AppUtil.appLogs("Error in response: ${response.body}");
          throw Exception('Failed to load data!');
        }
      } else {
        AppUtil.appLogs("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      AppUtil.appLogs("Exception caught: $error");
      throw Exception('Failed to load data!');
    }
  }
}
