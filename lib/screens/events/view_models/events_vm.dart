import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:zineapp2023/models/events.dart';
import 'package:zineapp2023/models/temp_events.dart';
import 'package:zineapp2023/screens/events/repo/events_repo.dart';

class EventsVm extends ChangeNotifier {
  //====================================NEWER CODE=========================================//
  final eventRepo = EventsRepo();
  List<TempEvents> _tempEvents = [];
  List<TempEvents> get tempEvents => _tempEvents;

  Future<void> tempGetAllEvent() async {
    print("inside the getallevents");
    try {
      _tempEvents = await eventRepo.fetchEvents();
      _tempEvents.sort((a, b) => b.startDateTime!.compareTo(a.startDateTime!));
    } catch (e) {
      print('Error fetching events: $e');
    } finally {
      notifyListeners();
    }
  }

  //====================================OLDER CODE=========================================//

  List<Events> _events = [];
  dynamic prev = 0;
  bool isLoading = false;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  get events => _events;

  void getAllEvents() async {
    setLoading(true);
    // _events = await eventRepo.getEvents();
    int index = _events.indexWhere(
        (element) => element.timeDate!.compareTo(Timestamp.now()) > 0);
    print(index);
    if (index != -1) {
      List<Events> secondPart =
          _events.sublist(index, _events.length).reversed.toList();
      List<Events> firstPart = _events.sublist(0, index);

      _events = [...firstPart, ...secondPart];
    }
    setLoading(false);
    if (_events.length != prev) {
      notifyListeners();
      prev = _events.length;
    }
  }
}
