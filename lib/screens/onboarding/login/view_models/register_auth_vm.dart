import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../common/routing.dart';
import '../../../../models/user.dart';
import '../../repo/auth_repo.dart';

class RegisterAuthViewModel extends ChangeNotifier {
  final _myRepo = AuthRepo();

  String _name = "";
  String _email = "";
  String _password = "";
  String _confirmPass = "";

  get name => _name;

  get email => _email;

  get password => _password;

  get confirmPass => _confirmPass;

  setName(String value) {
    _name = value;
  }

  setEmail(String value) {
    _email = value;
  }

  setPassword(String value) {
    _password = value;
  }

  setConfirmPass(String value) {
    _confirmPass = value;
  }

  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool _passwordVisible = false;

  bool get passwordVisible => _passwordVisible;

  void toggleVisible() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  String errorText = "";


  Future<void> postDetailsToFirestore(UserModel userModel) async {
    print('create user called');

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    await firebaseFirestore
        .collection("users")
        .doc(userModel.uid)
        .set(userModel.toJson());
  }

  Future<void> signUpApi(BuildContext context) async {

    var intValue = Random().nextInt(26)+1;

    Map data = {
      'email': _email,
      'password': _password,
      'name': _name,
      'dp':intValue,
    };

    setLoading(true);

    try {
      var value = await _myRepo
          .createUserWithEmailAndPassword(
        name: data['name'],
        email: data['email'],
        password: data['password'],
      );

      setLoading(false);
      String? uid = value?.uid;
      print(uid);
      print(value!.uid);

      print("account called");
      print(data['name']);
      print("account created");

      UserModel userModel = UserModel(
          uid: uid,
          email: data['email'],
          name: data['name'],
          dp: data['dp'],
      );
      postDetailsToFirestore(userModel);
      // postUser();
      // Utils.flushBarErrorMessage('SignUp Successfully', context);
      // Navigator.pushNamed(context, RoutesName.home);
      // Navigator.of(context,rootNavigator: true).pushAndRemoveUntil(
      //     Routes.homeScreen(), (Route<dynamic> route) => false);

    }on FirebaseAuthException catch (e){
      switch (e.code) {
        case "email-already-in-use":
          errorText = "This E-Mail is already in use. Contact Team Zine";
          break;
        case "internal-error":
          errorText = "An internal error occurred. Please try again later.";
          break;
        case "network-request-failed":
          errorText = "Network Request Error. Please check your internet and try again";
          break;
        case "user-disabled":
          errorText = "User with this email has been disabled";
          break;
        case "too-many-requests":
          errorText = "Too many requests";
          break;
        case "quota-exceeded":
          errorText = "Quota Exceeded. Please contact Team Zine.";
          break;
        case "timeout":
          errorText = "Timeout. Please check you internet and try again later";
          break;
        case "operation-not-allowed":
          errorText = "Signing in with Email and Password is not enabled";
          break;
        default:
          errorText = "An undefined Error happened";
      }
      setLoading(false);

      print(errorText);

      Fluttertoast.showToast(
          msg: errorText,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red
      );
    }
  }
}
