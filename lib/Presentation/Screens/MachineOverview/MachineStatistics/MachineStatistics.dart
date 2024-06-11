import 'dart:convert';
import 'dart:math';

import 'package:agribot_two/Presentation/Screens/MachineOverview/MachineStatistics/MachineStatisticCard.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../Class/BarData.dart';
import '../../../../Class/Query.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../../../Declarations/Constants/constants.dart';
import '../../../Components/spacer.dart';

class MachineStatistics extends StatefulWidget {
  final String machineId;
  final String fruitType;
  const MachineStatistics({super.key, required this.machineId, required this.fruitType});

  @override
  State<MachineStatistics> createState() => _MachineStatisticsState();
}

class _MachineStatisticsState extends State<MachineStatistics> {
  DateTime date_i = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day - (DateTime.now().weekday - 1));
  DateTime date_f = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day - (DateTime.now().weekday - 1))
      .add(const Duration(days: 6));

  late Future<Query> futureQuery;

  String durationUnit = "days";
  int durationUnitValue = 0;

  bool _daysVisible = true;
  bool _weeksVisible = false;
  bool _monthsVisible = false;

  int maxNum = 0;
  int totalInspection = 0;

  DayBarData dayBarData = DayBarData(
    monAmount: 0.00,
    tueAmount: 0.00,
    wedAmount: 0.00,
    thuAmount: 0.00,
    friAmount: 0.00,
    satAmount: 0.00,
    sunAmount: 0.00,
    monGrade: [0, 0, 0, 0, 0, 0],
    tueGrade: [0, 0, 0, 0, 0, 0],
    wedGrade: [0, 0, 0, 0, 0, 0],
    thuGrade: [0, 0, 0, 0, 0, 0],
    friGrade: [0, 0, 0, 0, 0, 0],
    satGrade: [0, 0, 0, 0, 0, 0],
    sunGrade: [0, 0, 0, 0, 0, 0],
  );

  WeekBarData weekBarData = WeekBarData(
      firstWeek: 0.00,
      secondWeek: 0.00,
      thirdWeek: 0.00,
      fourthWeek: 0.00,
      fifthWeek: 0.00,
      firstGrade: [0, 0, 0, 0, 0, 0],
      secondGrade: [0, 0, 0, 0, 0, 0],
      thirdGrade: [0, 0, 0, 0, 0, 0],
      fourthGrade: [0, 0, 0, 0, 0, 0],
      fifthGrade: [0, 0, 0, 0, 0, 0]);

  MonthBarData monthBarData = MonthBarData(
      january: 0.00,
      february: 0.00,
      march: 0.00,
      april: 0.00,
      may: 0.00,
      june: 0.00,
      july: 0.00,
      august: 0.00,
      september: 0.00,
      october: 0.00,
      november: 0.00,
      december: 0.00,
      januaryGrade: [0, 0, 0, 0, 0, 0],
      februaryGrade: [0, 0, 0, 0, 0, 0],
      marchGrade: [0, 0, 0, 0, 0, 0],
      aprilGrade: [0, 0, 0, 0, 0, 0],
      mayGrade: [0, 0, 0, 0, 0, 0],
      juneGrade: [0, 0, 0, 0, 0, 0],
      julyGrade: [0, 0, 0, 0, 0, 0],
      augustGrade: [0, 0, 0, 0, 0, 0],
      septemberGrade: [0, 0, 0, 0, 0, 0],
      octoberGrade: [0, 0, 0, 0, 0, 0],
      novemberGrade: [0, 0, 0, 0, 0, 0],
      decemberGrade: [0, 0, 0, 0, 0, 0]);

  void updateTotal(int total){
    setState(() {
      totalInspection = total;
    });
  }

  Future<Query> fetchQuery() async {
    Query thisQuery;

    Map<String, dynamic> json;
    final response = await http.get(Uri.parse(
        (dotenv.env['AGRIBOT_QUERY_INSPECTION_API'])! +
            '?machine_id=' +
            widget.machineId.toString() +
            '&date_i=' +
            (date_i.year).toString() +
            "-" +
            (date_i.month).toString().padLeft(2, "0") +
            "-" +
            (date_i.day).toString().padLeft(2, "0") +
            '&durationUnit=' +
            "${durationUnit}" + '&fruitType=' +
            "${widget.fruitType}"));

    if (response.statusCode == 200) {
      print("success machine stats Query");
      print(jsonDecode(response.body));
      // If the server did return a 200 OK response,
      json = jsonDecode(response.body) as Map<String, dynamic>;

      thisQuery =
          Query.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      setState(() {
        maxNum = 0;
        for (var i = 0; i < (thisQuery.items).length; i++) {
          if (maxNum < (thisQuery.items[i])["total_count"]) {
            maxNum = (thisQuery.items[i])["total_count"];
          }
        }
        if (maxNum < 5) {
          maxNum = 5;
        }

        List<List<double>> WholeUnitGrade = [];
        for (var i = 0; i < (thisQuery.items).length; i++) {
          List<double> individualUnitGrade = [
            (thisQuery.items[i])["total_count"].toDouble(),
            (thisQuery.items[i])["a_count"].toDouble(),
            (thisQuery.items[i])["b_count"].toDouble(),
            (thisQuery.items[i])["c_count"].toDouble(),
            (thisQuery.items[i])["d_count"].toDouble(),
            (thisQuery.items[i])["rej_count"].toDouble(),
          ];
          WholeUnitGrade.add(individualUnitGrade);
        }

        if (durationUnit == "days") {
          dayBarData = DayBarData(
            monAmount: (thisQuery.items[0])["total_count"].toDouble(),
            tueAmount: (thisQuery.items[1])["total_count"].toDouble(),
            wedAmount: (thisQuery.items[2])["total_count"].toDouble(),
            thuAmount: (thisQuery.items[3])["total_count"].toDouble(),
            friAmount: (thisQuery.items[4])["total_count"].toDouble(),
            satAmount: (thisQuery.items[5])["total_count"].toDouble(),
            sunAmount: (thisQuery.items[6])["total_count"].toDouble(),
            monGrade: WholeUnitGrade[0],
            tueGrade: WholeUnitGrade[1],
            wedGrade: WholeUnitGrade[2],
            thuGrade: WholeUnitGrade[3],
            friGrade: WholeUnitGrade[4],
            satGrade: WholeUnitGrade[5],
            sunGrade: WholeUnitGrade[6],
          );
          dayBarData.initializeBarData();
        } else if (durationUnit == "weeks") {
          weekBarData = WeekBarData(
              firstWeek: (thisQuery.items[0])["total_count"].toDouble(),
              secondWeek: (thisQuery.items[1])["total_count"].toDouble(),
              thirdWeek: (thisQuery.items[2])["total_count"].toDouble(),
              fourthWeek: (thisQuery.items[3])["total_count"].toDouble(),
              fifthWeek: (thisQuery.items[4])["total_count"].toDouble(),
              firstGrade: WholeUnitGrade[0],
              secondGrade: WholeUnitGrade[1],
              thirdGrade: WholeUnitGrade[2],
              fourthGrade: WholeUnitGrade[3],
              fifthGrade: WholeUnitGrade[4]);
          weekBarData.initializeBarData();
        } else {
          monthBarData = MonthBarData(
              january: (thisQuery.items[0])["total_count"].toDouble(),
              february: (thisQuery.items[1])["total_count"].toDouble(),
              march: (thisQuery.items[2])["total_count"].toDouble(),
              april: (thisQuery.items[3])["total_count"].toDouble(),
              may: (thisQuery.items[4])["total_count"].toDouble(),
              june: (thisQuery.items[5])["total_count"].toDouble(),
              july: (thisQuery.items[6])["total_count"].toDouble(),
              august: (thisQuery.items[7])["total_count"].toDouble(),
              september: (thisQuery.items[8])["total_count"].toDouble(),
              october: (thisQuery.items[9])["total_count"].toDouble(),
              november: (thisQuery.items[10])["total_count"].toDouble(),
              december: (thisQuery.items[11])["total_count"].toDouble(),
              januaryGrade: WholeUnitGrade[0],
              februaryGrade: WholeUnitGrade[1],
              marchGrade: WholeUnitGrade[2],
              aprilGrade: WholeUnitGrade[3],
              mayGrade: WholeUnitGrade[4],
              juneGrade: WholeUnitGrade[5],
              julyGrade: WholeUnitGrade[6],
              augustGrade: WholeUnitGrade[7],
              septemberGrade: WholeUnitGrade[8],
              octoberGrade: WholeUnitGrade[9],
              novemberGrade: WholeUnitGrade[10],
              decemberGrade: WholeUnitGrade[11]);
          monthBarData.initializeBarData();
        }
      });
      return thisQuery;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load query');
    }
  }

  @override
  void initState() {
    futureQuery = fetchQuery();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedToggleSwitch<int>.size(
                current: min(durationUnitValue, 2),
                style: ToggleStyle(
                  backgroundColor: Color(0xFF919191),
                  indicatorColor: Color(0xFFEC3345),
                  borderColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(10.0),
                  indicatorBorderRadius: BorderRadius.zero,
                ),
                values: const [0, 1, 2],
                iconOpacity: 1.0,
                selectedIconScale: 1.0,
                indicatorSize: Size.fromWidth(
                    ((MediaQuery.of(context).size.width) - 40) / 3),
                height: 30,
                iconAnimationType: AnimationType.onHover,
                styleAnimationType: AnimationType.onHover,
                spacing: 2.0,
                customSeparatorBuilder: (context, local, global) {
                  final opacity =
                      ((global.position - local.position).abs() - 0.5)
                          .clamp(0.0, 1.0);
                  return VerticalDivider(
                      indent: 10.0,
                      endIndent: 10.0,
                      color: Colors.white38.withOpacity(opacity));
                },
                customIconBuilder: (context, local, global) {
                  final text =
                      const ['7 Days', '5 Weeks', '12 Months'][local.index];
                  return Center(
                      child: Text(text,
                          style: TextStyle(
                              color: Color.lerp(Colors.black, Colors.white,
                                  local.animationValue))));
                },
                borderWidth: 0.0,
                onChanged: (i) => setState(() {
                  durationUnitValue = i;
                  //for a week
                  if (durationUnitValue == 0) {
                    durationUnit = "days";
                    _daysVisible = true;
                    _weeksVisible = false;
                    _monthsVisible = false;

                    date_i = DateTime(DateTime.now().year, DateTime.now().month,
                        DateTime.now().day - (DateTime.now().weekday - 1));

                    date_f = date_i.add(const Duration(days: 6));
                  }
                  //for a month (weeks)
                  else if (durationUnitValue == 1) {
                    durationUnit = "weeks";
                    _daysVisible = false;
                    _weeksVisible = true;
                    _monthsVisible = false;

                    DateTime startOfTheMonth =
                        DateTime(DateTime.now().year, DateTime.now().month);
                    date_i = DateTime(
                        startOfTheMonth.year,
                        startOfTheMonth.month,
                        startOfTheMonth.day - (startOfTheMonth.weekday - 1));
                    date_f = date_i.add(const Duration(days: 34));
                  }
                  //for a year (months)
                  else if (durationUnitValue == 2) {
                    durationUnit = "months";
                    _daysVisible = false;
                    _weeksVisible = false;
                    _monthsVisible = true;

                    date_i = DateTime(DateTime.now().year);
                    date_f = DateTime(DateTime.now().year + 1)
                        .subtract(const Duration(days: 1));
                  }
                  futureQuery = fetchQuery();
                }),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      if (durationUnit == "days") {
                        date_i = date_i.subtract(const Duration(days: 7));
                        date_f = date_f.subtract(const Duration(days: 7));
                      }
                      if (durationUnit == "weeks") {
                        DateTime currMonth =
                            date_i.add(const Duration(days: 7));
                        DateTime previousOfTheMonth =
                            DateTime(currMonth.year, currMonth.month - 1);

                        date_i = DateTime(
                            previousOfTheMonth.year,
                            previousOfTheMonth.month,
                            previousOfTheMonth.day -
                                (previousOfTheMonth.weekday - 1));
                        date_f = date_i.add(const Duration(days: 34));
                      }
                      if (durationUnit == "months") {
                        date_i = DateTime(date_i.year - 1);
                        date_f = DateTime(date_i.year + 1)
                            .subtract(const Duration(days: 1));
                      }
                      print(date_i);
                      print(date_f);
                      futureQuery = fetchQuery();
                    });
                  },
                  icon: const Icon(CupertinoIcons.lessthan)),
              Stack(
                children: [
                  Visibility(
                      visible: _daysVisible,
                      child: Text(
                          "${DateFormat('yyyy-MM-dd').format(date_i)} - ${DateFormat('yyyy-MM-dd').format((date_f))}",
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  Visibility(
                      visible: _weeksVisible,
                      child: Text(
                          "${monthName[((date_i.add(const Duration(days: 7))).month) - 1]} ${((date_i.add(const Duration(days: 7))).year)}",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  Visibility(
                      visible: _monthsVisible,
                      child: Text("${date_i.year}",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                ],
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      if (durationUnit == "days") {
                        date_i = date_i.add(const Duration(days: 7));
                        date_f = date_f.add(const Duration(days: 7));
                      }
                      if (durationUnit == "weeks") {
                        DateTime currMonth =
                            date_i.add(const Duration(days: 7));
                        DateTime NextOfTheMonth =
                            DateTime(currMonth.year, currMonth.month + 1);

                        date_i = DateTime(
                            NextOfTheMonth.year,
                            NextOfTheMonth.month,
                            NextOfTheMonth.day - (NextOfTheMonth.weekday - 1));
                        date_f = date_i.add(const Duration(days: 34));
                      }
                      if (durationUnit == "months") {
                        date_i = DateTime(date_i.year + 1);
                        date_f = DateTime(date_i.year + 1)
                            .subtract(const Duration(days: 1));
                      }

                      print(date_i);
                      print(date_f);
                      futureQuery = fetchQuery();
                    });
                  },
                  icon: const Icon(CupertinoIcons.greaterthan)),
            ],
          ),
        ),
        Text(
          "$totalInspection",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(
          "Total ${durationUnit == "days" ? "7 Days" : durationUnit == "weeks" ? "5 Weeks" : "12 Months"} Inspection",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        HeightSpacer(myHeight: 30),
        FutureBuilder(
            future: futureQuery,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                return MachineStatisticCard(
                  dayBarData: dayBarData,
                  weekBarData: weekBarData,
                  monthBarData: monthBarData,
                  daysVisible: _daysVisible,
                  weeksVisible: _weeksVisible,
                  monthsVisible: _monthsVisible,
                  date_i: date_i,
                  maxNum: maxNum,
                  update_total_inspection: updateTotal,
                );
              } else {
                DayBarData empty = DayBarData(
                  monAmount: 0.00,
                  tueAmount: 0.00,
                  wedAmount: 0.00,
                  thuAmount: 0.00,
                  friAmount: 0.00,
                  satAmount: 0.00,
                  sunAmount: 0.00,
                  monGrade: [0, 0, 0, 0, 0, 0],
                  tueGrade: [0, 0, 0, 0, 0, 0],
                  wedGrade: [0, 0, 0, 0, 0, 0],
                  thuGrade: [0, 0, 0, 0, 0, 0],
                  friGrade: [0, 0, 0, 0, 0, 0],
                  satGrade: [0, 0, 0, 0, 0, 0],
                  sunGrade: [0, 0, 0, 0, 0, 0],
                );
                empty.initializeBarData();
                return Stack(children: [
                  const Center(child: CircularProgressIndicator()),
                  MachineStatisticCard(
                    dayBarData: empty,
                    weekBarData: weekBarData,
                    monthBarData: monthBarData,
                    daysVisible: true,
                    weeksVisible: false,
                    monthsVisible: false,
                    date_i: date_i,
                    maxNum: 5,
                    update_total_inspection: updateTotal,
                  )
                ]);
              }
            })
      ],
    );
  }
}
