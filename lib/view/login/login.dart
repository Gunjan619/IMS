import 'package:flutter/material.dart';
import 'package:gims/api/appCommonVariable.dart';
import 'package:gims/api/webService.dart';
import 'package:gims/controllers/appUtil.dart';
import 'package:gims/model/Request/loginRequest.dart';
import 'package:gims/model/Request/simpleRequest.dart';
import 'package:gims/model/Response/loginResponse.dart';
import 'package:gims/model/Response/organisationResponse.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _MySignInState();
}

class _MySignInState extends State<SignIn> {
  TextEditingController idController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  double leftpeding = 0.0;
  double rightpeding = 0.0;
  bool passwordhide = true;

  bool isLoading = false;
  String OrgName = '';
  String logo = '';

  LoginModel requestModel = LoginModel("", "");
  SimpleModel simpleRequest = SimpleModel("");
  organisationResponse OrganisationResponse = organisationResponse();
  Webservice _webservice = Webservice();
  @override
  void initState() {
    super.initState();
    isLoading = true;
    simpleRequest.type = 'view';
    idController.text = 'GIMS-00';
    _webservice.organisation(simpleRequest).then((value) {
      if (mounted) {
        // Check if the widget is still mounted
        setState(() {
          OrganisationResponse = value;
          if (value.error == false) {
            isLoading = false;
            OrgName = OrganisationResponse.name.toString();
            logo = OrganisationResponse.logo.toString();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            //to give space from top
            const Expanded(
              flex: 1,
              child: Center(),
            ),

            //page content here
            Expanded(
              flex: 9,
              child: buildCard(size),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(Size size) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 60,
            ),
            //header text
            Text(
              'Login Account',
              style: GoogleFonts.roboto(
                fontSize: 24.0,
                color: const Color(0xFF15224F),
                fontWeight: FontWeight.w600,
              ),
            ),

            //logo section
            Logo(size.height / 8, size.height / 8),
            InstitutionTextField(size),
            SizedBox(
              height: 15,
            ),
            //email & password section
            emailTextField(size),
            SizedBox(
              height: 15,
            ),

            passwordTextField(size),
            SizedBox(
              height: size.height * 0.03,
            ),

            //sign in button
            signInButton(size),
            SizedBox(
              height: size.height * 0.04,
            ),

            //footer section. sign up text here
          ],
        ),
      ),
    );
  }

  Widget Logo(double height_, double width_) {
    return Image.asset(
      'assets/images/gims-logo.png',
      height: 150,
      width: 250,
    );
  }

  Widget InstitutionTextField(Size size) {
    return Container(
      alignment: Alignment.center,
      height: size.height / 18,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 1.0,
          color: const Color.fromARGB(255, 126, 126, 126),
        ),
      ),
      child: TextField(
        controller: idController,
        style: GoogleFonts.roboto(
          fontSize: 16.0,
          color: const Color(0xFF15224F),
        ),
        maxLines: 1,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
            labelText: 'Institution ID',
            labelStyle: GoogleFonts.roboto(
              fontSize: 16.0,
              color: Theme.of(context).primaryColor,
            ),
            border: InputBorder.none),
      ),
    );
  }

  Widget emailTextField(Size size) {
    return Container(
      alignment: Alignment.center,
      height: size.height / 18,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 1.0,
          color: const Color.fromARGB(255, 126, 126, 126),
        ),
      ),
      child: TextField(
        controller: usernameController,
        style: GoogleFonts.roboto(
          fontSize: 16.0,
          color: const Color(0xFF15224F),
        ),
        maxLines: 1,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
            labelText: 'Username/ Phone number',
            labelStyle: GoogleFonts.roboto(
              fontSize: 16.0,
              color: Theme.of(context).primaryColor,
            ),
            border: InputBorder.none),
      ),
    );
  }

  Widget passwordTextField(Size size) {
    return Container(
      alignment: Alignment.center,
      height: size.height / 18,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 1.0,
          color: const Color.fromARGB(255, 126, 126, 126),
        ),
      ),
      child: TextField(
        controller: passwordController,
        style: GoogleFonts.roboto(
          fontSize: 16.0,
          color: const Color(0xFF15224F),
        ),
        maxLines: 1,
        obscureText: passwordhide,
        keyboardType: TextInputType.visiblePassword,
        cursorColor: const Color(0xFF15224F),
        decoration: InputDecoration(
            suffixIcon: IconButton(
                icon: Icon(
                    passwordhide ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    passwordhide = false;
                  });
                }),
            labelText: 'Password',
            labelStyle: GoogleFonts.roboto(
              fontSize: 16.0,
              color: Theme.of(context).primaryColor,
            ),
            border: InputBorder.none),
      ),
    );
  }

  Widget signInButton(Size size) {
    return TextButton(
      child: Container(
        alignment: Alignment.center,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          color: Theme.of(context).primaryColor,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4C2E84).withOpacity(0.2),
              offset: const Offset(0, 15.0),
              blurRadius: 60.0,
            ),
          ],
        ),
        child: Text(
          'Sign in',
          style: GoogleFonts.roboto(
            fontSize: 16.0,
            color: Colors.white,
            fontWeight: FontWeight.w600,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      onPressed: () {
        if (idController.text.isEmpty) {
          AppUtil.showToast("Please Enter Institution ID", "e");
        } else if (usernameController.text.isEmpty) {
          AppUtil.showToast("Please Enter Username", "e");
        } else if (passwordController.text.isEmpty) {
          AppUtil.showToast("Please Enter Password", "e");
        } else {
          requestModel.username = usernameController.text.trim();
          requestModel.password = passwordController.text.trim();
          setState(() {
            isLoading = true;
          });
          _webservice.login(requestModel).then((value) {
            if (value.error == false) {
              setState(() async {
                isLoading = false;
                loginResponse response = value;
                AppUtil.showToast(value.msg!, 's');
                SharedPreferences sp = await SharedPreferences.getInstance();
                sp.setString(USER_ID, response.id.toString());
                sp.setString(USERNAME, response.name.toString());
                sp.setString(NAME, response.name.toString());
                sp.setString(ACCOUNT_TYPE, response.accountType.toString());
                sp.setString(USER_ID, response.id.toString());
                sp.setString(PERMISSIONS, response.permission.toString());
                Navigator.pushReplacementNamed(context, '/home');
              });
            } else {
              setState(() {
                isLoading = false;
                AppUtil.showToast(value.msg!, 'e');
              });
            }
          });
        }
      },
    );
  }
}
