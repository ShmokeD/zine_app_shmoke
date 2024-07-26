import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:zineapp2023/models/events.dart';
import 'package:zineapp2023/screens/explore/public_events/view_models/public_events_vm.dart';
import 'package:zineapp2023/theme/color.dart';

class EventCalendar extends StatelessWidget {
  const EventCalendar({super.key, required this.evm});
  final PublicEventsVM evm;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      calendarStyle: const CalendarStyle(
          selectedTextStyle: TextStyle(color: Colors.white),
          markersOffset: PositionedOffset(),
          isTodayHighlighted: false,
          selectedDecoration: BoxDecoration(
            shape: BoxShape.circle,
            color: textColor,
          )),
      eventLoader: evm.getEvents,
      focusedDay: (evm.isLoaded && !evm.isError && evm.events.isNotEmpty)
          ? DateTime.now()
          : evm.selectedEvent.timeDate!.toDate(),
      selectedDayPredicate: (day) {
        if (evm.isError || !evm.isLoaded || evm.events.isEmpty) {
          return false;
        } else {
          return isSameDay(evm.selectedEvent.timeDate!.toDate(), day);
        }
      },
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, events) {
          if (events.any((event) =>
              isSameDay((event as Events).timeDate!.toDate(), day))) {
            return const Center(
              child: Icon(
                color: blurBlue,
                // weight: 50,
                Icons.circle_outlined,
                size: 50,
              ),
            );
          }
        },
      ),
      firstDay: DateTime.utc(2024, 07, 01),
      lastDay: evm.getLastEventDate(),
      onDaySelected: evm.selectEvent,
      headerStyle: HeaderStyle(
        titleTextStyle: GoogleFonts.poppins(
            fontSize: 30, color: textColor, fontWeight: FontWeight.bold),
        rightChevronVisible: false,
        leftChevronVisible: false,
        formatButtonVisible: false,
        titleCentered: true,
      ),
    );
  }
}
