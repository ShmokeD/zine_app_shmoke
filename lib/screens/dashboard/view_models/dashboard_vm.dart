import "package:flutter/material.dart";
//import 'package:table_calendar/table_calendar.dart';
import 'package:zineapp2023/models/events.dart';
import 'package:zineapp2023/screens/dashboard/repo/dash_repo.dart';

import '../../../common/data_store.dart';
import '../../../providers/user_info.dart';

class DashboardVm extends ChangeNotifier {
  final DataStore store;
  final UserProv userProv;
  List<Map<String, dynamic>> _eventsDate = [];
  final dashRepo = DashRepo();
  static const Map<String, String> routes = {
    "ALGORITHMS": "ALGO",
    "BEE": "BEE",
    "BME": "BME",
    "AEROMODELLING": "AERO",
    "IC-MCU": "IC-MCU",
    "CYBERSECURITY": "CYBERSECURITY",
    "WEB DEVELOPMENT": "WEBDEV",
    "MACHINE LEARNING": "ML"
  };


  DashboardVm({required this.store, required this.userProv});

  List<Events> _events = [];

  dynamic prev=0;

  get events => _events;

  void launchUrl(url) {
    dashRepo.launchUrlStart(url: url);
  }
}
