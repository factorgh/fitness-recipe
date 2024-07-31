import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:voltican_fitness/models/event.dart';
import 'package:voltican_fitness/services/event_provider.dart';
import 'package:voltican_fitness/services/notification_service.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late final NotificationService _notificationService;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _notificationService = NotificationService();
    _notificationService.init();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EventProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Responsive Calendar'),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return _buildMobileCalendar();
            } else {
              return _buildTabletCalendar();
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _addEvent(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildMobileCalendar() {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          eventLoader: (day) {
            return Provider.of<EventProvider>(context).getEventsForDay(day);
          },
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
        ),
        const SizedBox(height: 8.0),
        _buildEventList(),
      ],
    );
  }

  Widget _buildTabletCalendar() {
    return Row(
      children: [
        Expanded(
          child: TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            eventLoader: (day) {
              return Provider.of<EventProvider>(context).getEventsForDay(day);
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
        ),
        Expanded(
          child: Column(
            children: [
              const SizedBox(height: 8.0),
              _buildEventList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventList() {
    final events = Provider.of<EventProvider>(context)
        .getEventsForDay(_selectedDay ?? DateTime.now());
    return Expanded(
      child: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return ListTile(
            title: Text(event.title),
          );
        },
      ),
    );
  }

  void _addEvent(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final date = _selectedDay ?? DateTime.now();
    final titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Event'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(hintText: 'Event Title'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final title = titleController.text;
              if (title.isNotEmpty) {
                final event = Event(title, date);
                eventProvider.addEvent(event);
                _notificationService.showNotification(
                  'Event Added',
                  'Event "$title" added on ${date.toLocal()}',
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
