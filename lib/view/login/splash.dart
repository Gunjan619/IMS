import 'package:flutter/material.dart';
import 'package:gims/api/appCommonVariable.dart';
import 'package:gims/responsive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String userId = "";
  String memberLoginId = "";
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 4000), () {
      SharedPreferences.getInstance().then((SharedPreferences sp) {
        userId = sp.getString(USER_ID) == null ? "" : sp.getString(USER_ID)!;

        if (userId.isNotEmpty) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          Navigator.pushReplacementNamed(context, '/Login');
        }
      });

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: Responsive.isDesktop(context)
                ? const AssetImage(
                    "assets/splash.gif",
                  )
                : Responsive.isTablet(context)
                    ? const AssetImage("assets/splash.gif")
                    : const AssetImage(
                        "assets/splash.gif",
                      ),
          )),
          width: double.infinity,
          height: double.infinity,
          child: Responsive.isDesktop(context)
              ? Image.asset("assets/splash.gif", fit: BoxFit.cover)
              : Responsive.isTablet(context)
                  ? Image.asset("assets/splash.gif", fit: BoxFit.cover)
                  : Image.asset("assets/splash.gif", fit: BoxFit.cover),
        ));
  }
}
