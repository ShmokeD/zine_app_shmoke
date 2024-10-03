import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart';
import 'package:requests/requests.dart';
import 'package:zineapp2023/models/rooms.dart';
import 'package:zineapp2023/models/tasks.dart';
import 'package:http/http.dart' as http;
import 'package:zineapp2023/models/userTask.dart';
import 'package:zineapp2023/providers/user_info.dart';
import 'package:zineapp2023/backend_properties.dart';
import '/common/data_store.dart';
import '../../../models/user.dart';

class AuthRepo {
  // final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  // final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  late DataStore store;

  AuthRepo({required this.store});

  Future<bool> sendResetEmail(String email) async {
    Response res = await Requests.post(
      BackendProperties.resetUri
          .replace(queryParameters: {'email': email.toString()}).toString(),
    );
    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // Future<void> updateToken()
  // {
  //   //TODO: Implement this

  // }

  Future<UserModel?> signInWithEmailAndPassword(
      {String? email, String? password, String? pushToken}) async {
    Response res = await http.post(BackendProperties.loginUri,
        body: jsonEncode(
            {"email": email, "password": password, "pushToken": pushToken}),
        headers: {"Content-Type": "application/json"});
    String userToken = "";
    print("Reponse Code ${res.statusCode}");
    // String toastText = 'An Undefined Error Occured';

    Map<String, dynamic> resBody = jsonDecode(res.body);
    try {
      switch (res.statusCode) {
        case 403:
          if ((resBody['failureReason'] as String) ==
                  'user_not_verified_email_resent' ||
              (resBody['failureReason'] as String) == 'user_not_verified') {
            throw AuthException(code: resBody['failureReason']);
          }

          throw AuthException(code: '403 Error');

        case 429:
          throw AuthException(code: 'too-many-requests');
        case 400:
          if ((resBody['failureReason'] as String) == 'wrong-password') {
            throw AuthException(code: 'wrong-password');
          }
          if ((resBody['failureReason'] as String) == 'user-not-found') {
            throw AuthException(code: 'user-not-exist');
          }
          throw AuthException(code: 'unknown');
        case 200:
          if (!resBody.containsKey('jwt')) {
            throw AuthException(code: 'backend-not-responding');
          } else {
            userToken = (resBody['jwt'] as String);
          }
          break;

        default:
          if (resBody.containsKey('failureReason')) {
            throw AuthException(code: resBody['failureReason'].toString());
          }

          throw AuthException(code: 'unknown');
      }
    } catch (e) {
      throw AuthException(code: 'unknown');
    }

    return getUserbyId(userToken);
  }

  Future<bool> isUserReg(String email) async {
    //FIXME : Implement This
    return true;
  }

  dynamic getRoomMap(dynamic listRoomIds) async {
    dynamic roomDetails = {"group": {}, "project": {}};
    for (var roomId in listRoomIds) {
      // print(item);
      //IM JUST WINGING IT OVER HERE WELL BURN THE BRIDGES WHEN WE GET TO EM
      Response res = await Requests.get(
          BackendProperties.roomDataUri.toString(),
          body: jsonEncode({'roomId': "$roomId"}),
          headers: {"Content-Type": "application/json"});

      if (res.statusCode != 200) {
        throw AuthException(code: 'It should probably return 200. Test Throw');
      }

      Map<String, dynamic> temp = jsonDecode(res.body);
      // print(temp['type']);

      roomDetails[temp['type']][roomId] = temp['name'];
    }
    return roomDetails;
  }

  // Future<Tasks> getTemp(UserTask e) async {
  //   // We are just Seeing if the given UserTask has any links and if it doesnt
  //   DocumentSnapshot<Map<String, dynamic>> snapshot = await e.task!.get()
  //       as DocumentSnapshot<Map<String, dynamic>>; // get tasks

  //   if (!snapshot.data()!.containsKey('link')) {
  //     // if task  doees not has link
  //     snapshot.data()!['links'] = []; //
  //     await e.task!.update({'link': []}); //set link = 0
  //   }

  //   Tasks data = Tasks.store(snapshot);

  //   return data;
  // }

  Future<List<UserTask>?> getTasks(uid) async {
    //FIXME: Implement tits
    return [];
  }

  // Future<List<Rooms>?> getRoomIds(uid) async {
  //   // Uri roomUri = BackendProperties.roomDataUri(email)
  //   // http.Response res = await http.get()
  //   // Response res = await Requests.get(BackendProperties.roomDataUri.toString(),
  //   //     queryParameters: {"email": "shmokedev2@gmail.com"}); //TODO: FIX THIS
  //   return [];
  // }

  Future<UserModel?> getUserbyId(String uid) async {
    Response res = await Requests.get(BackendProperties.userInfoUri.toString(),
        headers: {'Authorization': 'Bearer $uid'});

    if (res.statusCode != 200 || res.body.isEmpty) return null;
    print('User Body ${res.body}');
    Map<String, dynamic> user = jsonDecode(res.body);

    //USER DOES NOT HAVE TASKIDS, ENDPOINT FOR QUERYING USER'S TASK IDS

    var tasks = await getTasks(uid);
    // var rooms = await getRoomIds(uid);

    // var roomDetails = getRoomMap(rooms);

    // // List<Future<void>> futures = [];
    // // for (var e in tasks!) {
    // futures.add(getTemp(e).then((value) => e.template = value));
    // // }

    // await Future.wait(futures);

    // // print(tasks);

    // Above code just set User's links to empty, if the key wasnt created

    UserModel userMod = UserModel(
        uid: uid,
        id: user['id'],
        email: user['email'],
        name: user['name'],
        dp: int.tryParse(user['dp'] ?? "1"),
        type: user['type'],
        registered:
            user['registered']! ?? false, //SDK CONSTRAINTS MIGHT F WITH THIS
        tasks: tasks,
        // rooms: rooms,
        // roomDetails: roomDetails, // FIXME:
        lastSeen: user['lastSeen'] ?? {});

    return userMod;
  }

  Future<UserModel?> createUserWithEmailAndPassword({
    String name = 'New Recruit',
    String email = 'a@gmail.com',
    String password = 'password',
  }) async {
    //Verification mail is sent automatically.
//TODO: ADD TRY CATCH

    Response res = await http.post(BackendProperties.registerUri,
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
        }),
        headers: {"Content-Type": "application/json"});
    print("THSHFkjsdh ${res.statusCode}");
    print("djsfkjsdf ${res.url}");
    switch (res.statusCode) {
      case 409: //TODO: ADD COMMON CASES
        throw AuthException(code: 'email-already-in-use');

      default:
    }
    return UserModel();
  }

  Future<void> signOut() async {
    // await _firebaseAuth.signOut();
    store.delete(key: 'uid');
    store.setString('loggedIn', 'true');
  }
}

class AuthException implements Exception {
  String code;

  AuthException({required this.code});
}
