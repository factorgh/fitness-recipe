import 'package:flutter/material.dart';
import 'package:voltican_fitness/models/event.dart';

class EventProvider with ChangeNotifier {
  final Map<DateTime, List<Event>> _events = {};

  Map<DateTime, List<Event>> get events => _events;

  void addEvent(Event event) {
    if (_events[event.date] == null) {
      _events[event.date] = [];
    }
    _events[event.date]!.add(event);
    notifyListeners();
  }

  List<Event> getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }
}
