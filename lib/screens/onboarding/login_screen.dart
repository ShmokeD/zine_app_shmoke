import 'package:flutter/material.dart';

import '../../theme/color.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 300.0,
          elevation: 0,
          flexibleSpace: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 0.0, vertical: 80.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    child: Container(
                        height: 190.0,
                        child: Image.asset(
                          'assets/images/zine_logo.png',
                        )),
                  ),
                  const Positioned(
                      bottom: 25.0,
                      child: Text(
                        "Robotics And Research Group",
                        style: TextStyle(
                          fontSize: 15.0,
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ))
                ],
              ),
            ),
          ),
          shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(35.0))),
          bottom: const TabBar(
            indicatorColor: textColor,
            indicatorWeight: 4.0,
            labelStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
            unselectedLabelStyle: TextStyle(fontSize: 20.0),
            labelColor: textColor,
            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 0.0),
            tabs: [
              Tab(text: 'Login'),
              Tab(text: 'Sign-Up'),
            ],
          ),
        ),
        backgroundColor: backgroundGrey,
        body: Column(),
      ),
    );
  }
}
