import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';



class calendar extends StatefulWidget {

  @override
  _calendarState createState() => _calendarState();
}

class _calendarState extends State<calendar> {
  CalendarController _controller;

  @override
  void initState(){
    super.initState();
    _controller = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      headerStyle: HeaderStyle(
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold
        ),
        formatButtonDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Color(0xFF78C7C0),
        ),
        formatButtonShowsNext: false,
      ),
      calendarStyle: CalendarStyle(
        weekendStyle: TextStyle(
            fontWeight: FontWeight.bold
        ),
        weekdayStyle: TextStyle(
            fontWeight: FontWeight.bold
        ),
        todayColor: Color(0xFFDBB2B2),
        selectedColor: Color(0xFFD78282),
      ),
      calendarController: _controller,

    );
  }
}
