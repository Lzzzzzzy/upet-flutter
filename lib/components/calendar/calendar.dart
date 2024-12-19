// ignore_for_file: no_logic_in_create_state, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:upet_flutter/common/color.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CustomCalendar extends StatefulWidget {
  final bool showCalendarFormatBtn;
  final CalendarFormat calendarFormat;
  const CustomCalendar({
    super.key,
    required this.showCalendarFormatBtn,
    required this.calendarFormat,
  });

  @override
  _CustomCalendarState createState() =>
      _CustomCalendarState(showCalendarFormatBtn, calendarFormat);
}

class _CustomCalendarState extends State<CustomCalendar> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late final ValueNotifier<CalendarFormat> _calendarFormat;
  late final bool _showCalendarFormatBtn;
  // 使用一个变量存储上一个的 focusedDay
  DateTime _previousFocusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  _CustomCalendarState(
    bool showCalendarFormatBtn,
    CalendarFormat initialCalendarFormat,
  ) {
    _calendarFormat = ValueNotifier(initialCalendarFormat);
    _showCalendarFormatBtn = showCalendarFormatBtn;
  }

  void _onTodayButtonPressed() {
    _previousFocusedDay = DateTime.now();
    setState(() {
      _focusedDay = DateTime.now();
      _selectedDay = DateTime.now();
    });
  }

  void _onFormatButtonPressed() {
    setState(() {
      _calendarFormat.value = _calendarFormat.value == CalendarFormat.month
          ? CalendarFormat.week
          : CalendarFormat.month;
    });
  }

  int _dateDiff(DateTime date1, DateTime date2) {
    return date1.difference(date2).inDays;
  }

  @override
  Widget build(BuildContext context) {
    final monthBtn = IconButton(
        icon: Icon(Icons.calendar_month, size: 20.0),
        visualDensity: VisualDensity.compact,
        onPressed: _onFormatButtonPressed);
    final weekBtn = IconButton(
        icon: Icon(Icons.date_range, size: 20.0),
        visualDensity: VisualDensity.compact,
        onPressed: _onFormatButtonPressed);
    final headerText = DateFormat('yyyy年MM月').format(_focusedDay);
    final double screenWidth = MediaQuery.of(context).size.width;
    void onPageChanged(DateTime focusedDay) {
      // 计算当前日期加减一个月
      DateTime newFocusedDay;
      if (_dateDiff(focusedDay, _previousFocusedDay) < 0) {
        // 向左滑动，减少一个月/周
        if (_calendarFormat.value == CalendarFormat.month) {
          newFocusedDay = DateTime(_previousFocusedDay.year,
              _previousFocusedDay.month - 1, _previousFocusedDay.day); // 一个月
        } else {
          newFocusedDay = DateTime(_previousFocusedDay.year,
              _previousFocusedDay.month, _previousFocusedDay.day - 7); // 一周
        }
      } else if (_dateDiff(focusedDay, _previousFocusedDay) >
       0) {
        // 向右滑动，增加一个月/周
        if (_calendarFormat.value == CalendarFormat.month) {
          newFocusedDay = DateTime(_previousFocusedDay.year,
              _previousFocusedDay.month + 1, _previousFocusedDay.day); // 一个月
        } else {
          newFocusedDay = DateTime(_previousFocusedDay.year,
              _previousFocusedDay.month, _previousFocusedDay.day + 7); // 一周
        }
      } else {
        return;
      }

      setState(() {
        _focusedDay = newFocusedDay; // 更新焦点日期
        _selectedDay = newFocusedDay; // 更新选中日期
      });
      _previousFocusedDay = newFocusedDay;
    }

    return Column(children: [
      // 自定义头部
      Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              child: Text(
                headerText,
                style: const TextStyle(fontSize: 20.0),
              ),
            ),
            Row(children: [
              IconButton(
                icon: const Icon(Icons.event, size: 20.0),
                visualDensity: VisualDensity.compact,
                onPressed: _onTodayButtonPressed,
              ),
              if (_showCalendarFormatBtn)
                if (_calendarFormat.value == CalendarFormat.month)
                  weekBtn
                else
                  monthBtn,
            ])
          ],
        ),
      ),
      // TableCalendar主体
      TableCalendar(
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        headerVisible: false,
        calendarFormat: _calendarFormat.value,
        locale: "zh_CN",
        startingDayOfWeek: StartingDayOfWeek.monday,
        availableCalendarFormats: {
          CalendarFormat.month: '月',
          CalendarFormat.week: '周'
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat.value = format;
          });
        },
        firstDay: DateTime(DateTime.now().year - 5, 1, 1),
        lastDay: DateTime(DateTime.now().year + 5, 12, 31),
        onPageChanged: onPageChanged,
        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(
            color: selectedCalendarDayColor, // 选中日期的背景颜色
            shape: BoxShape.circle, // 选中日期的形状
          ),
          selectedTextStyle: TextStyle(
            color: black, // 选中日期的文本颜色
          ),
          todayTextStyle: TextStyle(
            color: black, // 今天日期的文本颜色
          ),
          todayDecoration: BoxDecoration(
            border: Border.all(
              color: wramYellow, // 边框颜色
              width: 1, // 边框宽度
            ),
            shape: BoxShape.circle, // 圆形边框
          ),
        ),
      ),
    ]);
  }
}
