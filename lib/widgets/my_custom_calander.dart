import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:ketodiet/utils/colors_utils.dart';
import 'package:ketodiet/utils/constant.dart';
import 'package:ketodiet/widgets/dateutils.dart' as date_util;
import 'package:ketodiet/widgets/mycontainer.dart';
import 'package:ketodiet/widgets/myregulartext.dart';

class DatePickerCustom extends StatefulWidget {
  ValueChanged<DateTime>? selectedTime;
  DatePickerCustom({this.selectedTime, Key? key}) : super(key: key);

  @override
  State<DatePickerCustom> createState() => DatePickerCustomState();
}

class DatePickerCustomState extends State<DatePickerCustom> {
  double width = 0.0;
  double height = 0.0;
  late ScrollController scrollController;
  static List<DateTime> currentMonthList = List.empty();
  DateTime currentDateTime = DateTime.now();
  // DateTime currentDateTime = DateTime(2023, 5, 25);
  List<String> todos = <String>[];
  TextEditingController controller = TextEditingController();
  List<CalenderEvent> events = [];
  List<dynamic> userAllList = [];
  int todayAttempt = 0;
  int selectedIndex = -1;
  late final Box userBox;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? now;
  DateTime? previousDateTime;
  int? previousTimestamp;
  int previousDays = 0;

  @override
  void initState() {
    userBox = Hive.box('userdata');
    scrollController =
        ScrollController(initialScrollOffset: 40.0 * currentDateTime.day);
    loadDate();
    super.initState();

    //loadSpData();
  }

  getUserData() {
    List newUserData = userBox.values.toList();
    userAllList.addAll(newUserData);
    print('userAllList:::${userAllList.length}');
  }

  Future<void> loadDate() async {
    previousDays = await getUserBoxLength();
    now = DateTime.now(); // Get the current date and time
    startDate = now!.subtract(
        Duration(days: previousDays)); // Subtract 7 days to get the start date
    endDate =
        now!.add(const Duration(days: 7)); // Add 2 days to get the end date

    List<DateTime> ganratedList = [];
    for (var i = startDate!;
        i.isBefore(endDate!.add(const Duration(
            days: 1,
            minutes: 00,
            seconds: 00,
            microseconds: 0,
            milliseconds: 0)));
        i = i.add(const Duration(days: 1))) {
      ganratedList.add(i);
    }
    currentMonthList = ganratedList;
    currentMonthList = currentMonthList.toSet().toList();
    setState(() {
      currentMonthList;
    });
  }

  Future<int> getUserBoxLength() async {
    int previousDay = 0;
    if (userBox.isNotEmpty) {
      print('yes>>>>>>');
      await getUserData();
      if (Constant.selectedDateCurrentIndex != -1) {
        widget
            .selectedTime!(currentMonthList[Constant.selectedDateCurrentIndex]);
      }
      print('userAllList.length >>${userAllList.length}');
      for (int i = 0; i < userAllList.length; i++) {
        print('for>>>>>');
        print('userAllList.......${userAllList.length}');
        // int timestamp = int.parse(userAllList[i].timestamp);
        /* DateTime date = DateTime.parse(userAllList[i].timestamp);
        print('timestamp???>>>>????${userAllList[i].timestamp} >>>>>>>${date
            .day} ');*/
        String currentFormat = DateFormat('dd-MM-yyyy').format(currentDateTime);
        if ((DateFormat('dd-MM-yyyy').parseStrict(userAllList[i].timestamp))
            .isBefore(DateFormat('dd-MM-yyyy').parseStrict(currentFormat))) {
          setState(() {
            previousDay = i + 1;
            print('previousDays>>>>$previousDay');
          });
          /* if ((date.day < currentDateTime.day) || (date.month < currentDateTime.month) || ( date.year < currentDateTime.year)) {
          setState(() {
            previousDay = i+1;
            print('previousDays>>>>$previousDay');
          });
        }*/
        }
      }
      return previousDay;
    } else {
      print('no>>>>>>');
      return previousDay = 0;
    }
  }

  void updateDateEventData() async {
    if (events.isNotEmpty) {
      for (int i = 0; i < events.length; i++) {
        if (currentMonthList[i].day == events[i].eventDate!.day &&
            currentMonthList[i].month == events[i].eventDate!.month &&
            currentMonthList[i].year == events[i].eventDate!.year) {
          print(
              "SAME DATEEEEEEEE CALADER ${currentMonthList[i]} -- SP DATA -- ${events[i]}");
          if (date_util.NkDateUtils.isSameDay(
                  currentDateTime, events[i].eventDate!) &&
              todayAttempt != events[i].attemptdEvents) {
            updateAttemptPoint(events[i]);
          }
        } else {
          events.add(CalenderEvent(
            attemptdEvents: 0,
            eventDate: currentMonthList[i],
            eventTitle: "EVENT $i",
          ));
          print(
              "NOT SAME DATEEEEEEEE CALADER ${currentMonthList[i]} -- SP DATA -- ${events[i]}");
        }
      }
    } else {
      setState(() {
        for (var i = 0; i < currentMonthList.length; i++) {
          if (date_util.NkDateUtils.isSameDay(
                  currentDateTime, currentMonthList[i]) ==
              true) {
            events.add(CalenderEvent(
                attemptdEvents: todayAttempt,
                eventDate: currentMonthList[i],
                eventTitle: "EVENT $i"));
          } else {
            events.add(CalenderEvent(
                attemptdEvents: 0,
                eventDate: currentMonthList[i],
                eventTitle: "EVENT $i"));
          }

          //   print("ADDED DATA LENGTH ${events}");
        }
      });
    }
  }

  updateAttemptPoint(CalenderEvent eventData) {
    setState(() {
      eventData.attemptdEvents = todayAttempt;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return hrizontalCapsuleListView(theme);
  }

  Widget hrizontalCapsuleListView(ThemeData themeData) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.1,
      child: ListView.separated(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: currentMonthList.length,
        itemBuilder: (BuildContext context, int index) {
          return capsuleView(index, themeData);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            width: 10,
          );
        },
      ),
    );
  }

  Widget capsuleView(int index, ThemeData themeData) {
    return MyContainer(
      height: MediaQuery.of(context).size.height * 0.08,
      color: Constant.selectedDateCurrentIndex == index
          ? themeData.primaryColor
          : null,
      onTap: () => setState(() {}),
      borderRadius: BorderRadius.circular(36),
      padding: const EdgeInsets.all(6.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: MyRegularText(
              isHeading: false,
              label: date_util
                  .NkDateUtils.weekdays[currentMonthList[index].weekday - 1],
              fontSize: 12,
              color: currentDateTime.day < currentMonthList[index].day
                  ? textColor
                  : textColor,
            ),
          ),
          MyContainer(
            height: 28,
            width: 28,
            color: currentDateTime.day == currentMonthList[index].day
                ? Colors.black
                : primaryColor,
            borderRadius: BorderRadius.circular(30),
            child: Center(
              child: MyRegularText(
                isHeading: false,
                label: currentMonthList[index].day.toString(),
                color: currentDateTime.day == currentMonthList[index].day
                    ? whiteColor
                    : currentDateTime.day < currentMonthList[index].day
                        ? textColor
                        : null,
              ),
            ),
          ),
          // ComponentSize.smallSize(),
          for (int i = 0; i < events.length; i++) ...[
            if (date_util.NkDateUtils.isSameDay(
                events[i].eventDate!, currentMonthList[index]))
              performedActivitys(events[i], i)
            else
              const SizedBox()
          ]
        ],
      ),
    );
  }

  Widget performedActivitys(CalenderEvent data, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (int i = 0; i < data.attemptdEvents!; i++) ...[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 2.0),
            height: MediaQuery.of(context).size.width * 0.02,
            width: MediaQuery.of(context).size.width * 0.02,
            decoration: const BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
          )
        ]
      ],
    );
  }
}

class CalenderEvent {
  late int? attemptdEvents;
  late String? eventTitle;
  late DateTime? eventDate;

  CalenderEvent({this.eventTitle, this.eventDate, this.attemptdEvents});

  factory CalenderEvent.fromJson(Map<String, dynamic> json) {
    return CalenderEvent(
      attemptdEvents: json['attemptdEvents'],
      eventTitle: json['eventTitle'],
      eventDate: json['eventDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attemptdEvents': attemptdEvents,
      'eventTitle': eventTitle,
      'eventDate': eventDate.toString()
    };
  }

  List<CalenderEvent> listFromJson(List<dynamic> list) {
    List<CalenderEvent> rows =
        list.map((i) => CalenderEvent.fromJson(i)).toList();
    return rows;
  }
}
