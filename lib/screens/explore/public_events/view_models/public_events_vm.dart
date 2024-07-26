import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zineapp2023/screens/explore/public_events/repo/public_events_repo.dart';
import 'package:table_calendar/src/shared/utils.dart';
import 'package:zineapp2023/models/events.dart';

class PublicEventsVM extends ChangeNotifier {
  final PublicEventsRepo peRepo = PublicEventsRepo();
  List<Events> _events = [];
  Events defaultEvent =
      Events(name: 'null', timeDate: Timestamp.fromDate(DateTime.now()));
  Events _selectedEvent = Events(
      name: 'null',
      timeDate: Timestamp.fromDate(DateTime.now())); //defualt Selected Event
  int _selectedIndex = -1;
  bool _isLoaded = false;
  bool _isError = false;
  void loadEvents() async {
    if (_isLoaded) return;
    try {
      List<Events> fireEvents = await peRepo.getEvents();
      _events = fireEvents;
    } catch (e) {
      print("Error $e");
      _isError = true;
    }
    _isLoaded = true;

    notifyListeners();
  }

  void selectEvent(DateTime selectedDay, DateTime focusedDay) {
    List<Events> _eventsOnSelectedDay = _events
        .where((event) => isSameDay(event.timeDate!.toDate(), selectedDay))
        .toList();

    if (_eventsOnSelectedDay.isNotEmpty) {
      var index = _eventsOnSelectedDay.indexWhere(
          (event) => isSameDay(event.timeDate!.toDate(), selectedDay));
      _selectedEvent = _eventsOnSelectedDay[index];
      _selectedIndex = index;
    } else {
      _selectedEvent =
          Events(name: 'null', timeDate: Timestamp.fromDate(selectedDay));
      _selectedIndex = -1;
    }

    notifyListeners();
  }

  void selectEventIndex(int index) {
    if (_selectedIndex < 0) {
      //If we are already on an uneventful date, select from normal events list
      _selectedEvent = events[index];
    } else {
      _selectedEvent = eventsOnSelectedDay[index];
    }
    _selectedIndex = eventsOnSelectedDay.indexOf(_selectedEvent);
    notifyListeners();
  }

  List<Events> get eventsOnSelectedDay => _events
      .where((event) => isSameDay(
          event.timeDate!.toDate(), _selectedEvent.timeDate!.toDate()))
      .toList();
  Events get selectedEvent => _selectedEvent;
  int get selectedIndex => _selectedIndex;

  bool get isError => _isError;
  bool get isLoaded => _isLoaded;
  List<Events> get events => _events;

  DateTime getLastEventDate() {
    if (_events.isEmpty) return DateTime.now();
    _events.sort((ev1, ev2) => ev1.timeDate!.compareTo(ev2.timeDate!));
    return _events.last.timeDate!.toDate();
  }

  List<Events> getEvents(DateTime day) => _events
      .where((event) => isSameDay(event.timeDate!.toDate(), day))
      .toList();
}
