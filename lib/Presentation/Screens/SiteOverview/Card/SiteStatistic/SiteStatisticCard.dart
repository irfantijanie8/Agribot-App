import 'dart:convert';
import 'dart:math';

import 'package:agribot_two/Declarations/Constants/constants.dart';
import 'package:agribot_two/Presentation/Screens/MachineOverview/MachineStatistics/MachineStatisticCard.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'dart:math' as math;
import '../../../../../Class/BarData.dart';
import '../../../../Components/spacer.dart';

class SiteStatisticCard extends StatefulWidget {
  final DayBarData dayBarData;
  final WeekBarData weekBarData;
  final MonthBarData monthBarData;
  final bool daysVisible;
  final bool weeksVisible;
  final bool monthsVisible;
  final DateTime date_i;
  final int maxNum;
  final List<String> machineName;
  final updateIntCallback update_total_inspection;

  const SiteStatisticCard(
      {super.key,
      required this.dayBarData,
      required this.weekBarData,
      required this.monthBarData,
      required this.daysVisible,
      required this.weeksVisible,
      required this.monthsVisible,
      required this.date_i,
      required this.maxNum,
      required this.machineName,
      required this.update_total_inspection});

  @override
  State<SiteStatisticCard> createState() => _SiteStatisticCardState();
}

class _SiteStatisticCardState extends State<SiteStatisticCard> {
  late int showingTooltip;
  late int intervalNum;

  double totalInspection = 0.0;

  double totalIndividualUnit = 0.0;
  double gradeA = 0.0;
  double gradeB = 0.0;
  double gradeC = 0.0;
  double gradeD = 0.0;
  double gradeRej = 0.0;

  List<int> machineTotal = [];

  @override
  void initState() {
    showingTooltip = -1;
    intervalNum = widget.maxNum < 10
        ? 10
        : widget.maxNum < 100
            ? 20
            : widget.maxNum < 250
                ? 50
                : widget.maxNum < 500
                    ? 100
                    : 200;

    if (widget.daysVisible) {
      for (var i = 0; i < ((widget.dayBarData).allGrade).length; i++) {
        totalInspection =
            totalInspection + ((widget.dayBarData).allGrade[i])[0];
      }
    } else if (widget.weeksVisible) {
      for (var i = 0; i < ((widget.weekBarData).allGrade).length; i++) {
        totalInspection =
            totalInspection + ((widget.weekBarData).allGrade[i])[0];
      }
    } else {
      for (var i = 0; i < ((widget.monthBarData).allGrade).length; i++) {
        totalInspection =
            totalInspection + ((widget.monthBarData).allGrade[i])[0];
      }
    }

    for (var i = 0; i < widget.machineName.length; i++) {
      machineTotal.add(0);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.update_total_inspection(totalInspection.toInt());
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 30.00,
          child: AspectRatio(
            aspectRatio: 2,
            child: BarChart(
              BarChartData(
                maxY: (((widget.maxNum ~/ intervalNum) + 1) * intervalNum)
                    .toDouble(),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                    drawVerticalLine: false, drawHorizontalLine: true),
                titlesData: FlTitlesData(
                    show: true,
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: intervalNum.toDouble()),
                    ),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: widget.daysVisible
                                ? getDaysBottomTitles
                                : widget.weeksVisible
                                    ? getWeeksBottomTitles
                                    : getMonthsBottomTitles))),
                barGroups: (widget.daysVisible
                        ? (widget.dayBarData).barData
                        : widget.weeksVisible
                            ? (widget.weekBarData).barData
                            : (widget.monthBarData).barData)
                    .map((data) => BarChartGroupData(
                          x: data.x,
                          groupVertically: true,
                          barRods: [
                            BarChartRodData(
                              toY: data.y,
                              color: Colors.white70,
                              width: 15,
                              borderRadius: BorderRadius.circular(4),
                              // backDrawRodData:
                            ),
                            BarChartRodData(
                              toY: data.y,
                              color: Color(0XFFD49BC4),
                              width: 15,
                              borderRadius: BorderRadius.circular(4),
                              // backDrawRodData:
                            ),
                            BarChartRodData(
                              toY: data.y - data.a,
                              color: Color(0XFF50C8C8),
                              width: 15,
                              borderRadius: BorderRadius.circular(4),
                              // backDrawRodData:
                            ),
                            BarChartRodData(
                              toY: data.y - data.a - data.b,
                              color: Color(0XFF4C91B8),
                              width: 15,
                              borderRadius: BorderRadius.circular(4),
                              // backDrawRodData:
                            ),
                            BarChartRodData(
                              toY: data.y - data.a - data.b - data.c,
                              color: Color(0XFFEB8459),
                              width: 15,
                              borderRadius: BorderRadius.circular(4),
                              // backDrawRodData:
                            ),
                            BarChartRodData(
                              toY: data.y - data.a - data.b - data.c - data.d,
                              color: Color(0XFFEED075),
                              width: 15,
                              borderRadius: BorderRadius.circular(4),
                              // backDrawRodData:
                            ),

                          ],
                          showingTooltipIndicators:
                              showingTooltip == data.x ? [0] : [],
                        ))
                    .toList(),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (
                        BarChartGroupData group,
                        int groupIndex,
                        BarChartRodData rod,
                        int rodIndex,
                    ){
                      return BarTooltipItem(
                        rod.toY.round().toString(),
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                  ),
                    enabled: true,
                    handleBuiltInTouches: false,
                    touchCallback: (event, response) {
                      if (response != null &&
                          response.spot != null &&
                          event is FlTapUpEvent) {
                        setState(() {
                          final x = response.spot!.touchedBarGroup.x;
                          final isShowing = showingTooltip == x;
                          if (isShowing) {
                            //when tooltip release
                            showingTooltip = -1;

                            totalIndividualUnit = 0.0;
                            gradeA = 0.0;
                            gradeB = 0.0;
                            gradeC = 0.0;
                            gradeD = 0.0;
                            gradeRej = 0.0;

                            machineTotal = [];
                            for (var i = 0;
                                i < widget.machineName.length;
                                i++) {
                              machineTotal.add(0);
                            }
                          } else {
                            showingTooltip = x;
                            if (widget.daysVisible) {
                              totalIndividualUnit =
                                  ((widget.dayBarData).allGrade[x])[0];
                              gradeA = ((widget.dayBarData).allGrade[x])[1];
                              gradeB = ((widget.dayBarData).allGrade[x])[2];
                              gradeC = ((widget.dayBarData).allGrade[x])[3];
                              gradeD = ((widget.dayBarData).allGrade[x])[4];
                              gradeRej = ((widget.dayBarData).allGrade[x])[5];

                              machineTotal = [];
                              print((widget.monthBarData).machineTotal);
                              for (var i = 0;
                                  i < widget.machineName.length;
                                  i++) {
                                print(((widget.dayBarData).machineTotal[x])[i]);
                                machineTotal.add(
                                    ((widget.dayBarData).machineTotal[x])[i]);
                              }
                            } else if (widget.weeksVisible) {
                              totalIndividualUnit =
                                  ((widget.weekBarData).allGrade[x])[0];
                              gradeA = ((widget.weekBarData).allGrade[x])[1];
                              gradeB = ((widget.weekBarData).allGrade[x])[2];
                              gradeC = ((widget.weekBarData).allGrade[x])[3];
                              gradeD = ((widget.weekBarData).allGrade[x])[4];
                              gradeRej = ((widget.weekBarData).allGrade[x])[5];
                              machineTotal = [];
                              for (var i = 0;
                                  i < widget.machineName.length;
                                  i++) {
                                machineTotal.add(
                                    ((widget.weekBarData).machineTotal[x])[i]);
                              }
                            } else {
                              totalIndividualUnit =
                                  ((widget.monthBarData).allGrade[x])[0];
                              gradeA = ((widget.monthBarData).allGrade[x])[1];
                              gradeB = ((widget.monthBarData).allGrade[x])[2];
                              gradeC = ((widget.monthBarData).allGrade[x])[3];
                              gradeD = ((widget.monthBarData).allGrade[x])[4];
                              gradeRej = ((widget.monthBarData).allGrade[x])[5];
                              machineTotal = [];
                              for (var i = 0;
                                  i < widget.machineName.length;
                                  i++) {
                                print(((widget.monthBarData).machineTotal[x]));
                                machineTotal.add(
                                    ((widget.monthBarData).machineTotal[x])[i]);
                              }
                            }
                          }
                        });
                      }
                    },
                    mouseCursorResolver: (event, response) {
                      return response == null || response.spot == null
                          ? MouseCursor.defer
                          : SystemMouseCursors.click;
                    }),
              ),
            ),
          ),
        ),
        HeightSpacer(myHeight: 30),
        const Divider(
          color: Colors.black26,
          height: 2.5,
          thickness: 2,
          indent: 5,
          endIndent: 5,
        ),
        HeightSpacer(myHeight: 10),
        Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "${showingTooltip >= 0 ? (widget.daysVisible ? ((widget.dayBarData).allGrade[showingTooltip])[0].toInt() : widget.weeksVisible ? ((widget.weekBarData).allGrade[showingTooltip])[0].toInt() : ((widget.monthBarData).allGrade[showingTooltip])[0].toInt()) : "Select A ${widget.daysVisible ? "Day" : widget.weeksVisible ? "Week" : "Month"}"} ",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 30.00),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                        "Total A ${widget.daysVisible ? "Day" : widget.weeksVisible ? "Week" : "Month"} Inspection ")
                  ],
                ),
                HeightSpacer(myHeight: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("A       "),
                    LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width - 200,
                      animation: true,
                      lineHeight: 20.0,
                      animationDuration: 2000,
                      percent: totalIndividualUnit == 0.0
                          ? 0
                          : gradeA / totalIndividualUnit,
                      // center: Text("90.0%"),
                      barRadius: Radius.circular(3),
                      progressColor: Color(0XFFD49BC4),
                    ),
                    totalIndividualUnit == 0
                        ? const Text("0%(0)")
                        : Text(
                            "${(((gradeA / totalIndividualUnit) * 1000).roundToDouble()) / 10}%(${gradeA.toInt()})"),
                  ],
                ),
                HeightSpacer(myHeight: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("B       "),
                    LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width - 200,
                      animation: true,
                      lineHeight: 20.0,
                      animationDuration: 2000,
                      percent: totalIndividualUnit == 0.0
                          ? 0
                          : gradeB / totalIndividualUnit,
                      // center: Text("90.0%"),
                      barRadius: Radius.circular(3),
                      progressColor: Color(0XFF50C8C8),
                    ),
                    totalIndividualUnit == 0
                        ? const Text("0%(0)")
                        : Text(
                            "${(((gradeB / totalIndividualUnit) * 1000).roundToDouble()) / 10}%(${gradeB.toInt()})"),
                  ],
                ),
                HeightSpacer(myHeight: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("C       "),
                    LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width - 200,
                      animation: true,
                      lineHeight: 20.0,
                      animationDuration: 2000,
                      percent: totalIndividualUnit == 0.0
                          ? 0
                          : gradeC / totalIndividualUnit,
                      // center: Text("90.0%"),
                      barRadius: Radius.circular(3),
                      progressColor: Color(0XFF4C91B8),
                    ),
                    totalIndividualUnit == 0
                        ? const Text("0%(0)")
                        : Text(
                            "${(((gradeC / totalIndividualUnit) * 1000).roundToDouble()) / 10}%(${gradeC.toInt()})"),
                  ],
                ),
                HeightSpacer(myHeight: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("D       "),
                    LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width - 200,
                      animation: true,
                      lineHeight: 20.0,
                      animationDuration: 2000,
                      percent: totalIndividualUnit == 0.0
                          ? 0
                          : gradeD / totalIndividualUnit,
                      // center: Text("90.0%"),
                      barRadius: Radius.circular(3),
                      progressColor: Color(0XFFEB8459),
                    ),
                    totalIndividualUnit == 0
                        ? const Text("0%(0)")
                        : Text(
                            "${(((gradeD / totalIndividualUnit) * 1000).roundToDouble()) / 10}%(${gradeD.toInt()})"),
                  ],
                ),
                HeightSpacer(myHeight: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Reject"),
                    LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width - 200,
                      animation: true,
                      lineHeight: 20.0,
                      animationDuration: 2000,
                      percent: totalIndividualUnit == 0.0
                          ? 0
                          : gradeRej / totalIndividualUnit,
                      barRadius: Radius.circular(3),
                      progressColor: Color(0XFFEED075),
                    ),
                    totalIndividualUnit == 0
                        ? const Text("0%(0)")
                        : Text(
                            "${(((gradeRej / totalIndividualUnit) * 1000).roundToDouble()) / 10}%(${gradeRej.toInt()})"),
                  ],
                ),
                HeightSpacer(myHeight: 20),
                widget.machineName.length != 0
                    ? const Divider(
                        color: Colors.black26,
                        height: 2.5,
                        thickness: 2,
                        indent: 5,
                        endIndent: 5,
                      )
                    : const HeightSpacer(myHeight: 0),
                HeightSpacer(myHeight: 5),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(0),
                    shrinkWrap: true,
                    itemCount: (widget.machineName).length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${(widget.machineName)[index]}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              totalIndividualUnit == 0
                                  ? const Text("0%(0)")
                                  : Text(
                                      "${(((machineTotal[index] / totalIndividualUnit) * 1000).roundToDouble()) / 10}%(${machineTotal[index].toInt()})"),
                            ],
                          ),
                          HeightSpacer(myHeight: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              LinearPercentIndicator(
                                width: MediaQuery.of(context).size.width - 200,
                                animation: true,
                                lineHeight: 20.0,
                                animationDuration: 2000,
                                percent: totalIndividualUnit == 0.0
                                    ? 0
                                    : machineTotal[index] / totalIndividualUnit,
                                // center: Text("90.0%"),
                                barRadius: Radius.circular(3),
                                progressColor: Color(((index.toDouble() + (index+1)/10) * 0xFFFFFF).toInt()).withOpacity(1.0),
                              ),
                            ],
                          ),
                          HeightSpacer(myHeight: 20),
                        ],
                      );
                    }),
                widget.machineName.length != 0
                    ? const Divider(
                        color: Colors.black26,
                        height: 2.5,
                        thickness: 2,
                        indent: 5,
                        endIndent: 5,
                      )
                    : const HeightSpacer(myHeight: 0)
              ],
            ))
      ],
    );
  }

  Widget getDaysBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14);

    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text(
          "MO",
          style: style,
        );
        break;
      case 1:
        text = const Text(
          "TU",
          style: style,
        );
        break;
      case 2:
        text = const Text(
          "WE",
          style: style,
        );
        break;
      case 3:
        text = const Text(
          "TH",
          style: style,
        );
        break;
      case 4:
        text = const Text(
          "FR",
          style: style,
        );
        break;
      case 5:
        text = const Text(
          "SA",
          style: style,
        );
        break;
      case 6:
        text = const Text(
          "SU",
          style: style,
        );
        break;
      default:
        text = const Text(
          "",
          style: style,
        );
        break;
    }
    return SideTitleWidget(child: text, axisSide: meta.axisSide);
  }

  Widget getWeeksBottomTitles(double value, TitleMeta meta) {
    final DateFormat formatter = DateFormat('dd-MM');
    const style = TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14);

    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text(
          formatter.format((widget.date_i).add(Duration(days: 0))),
          style: style,
        );
        break;
      case 1:
        text = Text(
          formatter.format((widget.date_i).add(Duration(days: 7))),
          style: style,
        );
        break;
      case 2:
        text = Text(
          formatter.format((widget.date_i).add(Duration(days: 14))),
          style: style,
        );
        break;
      case 3:
        text = Text(
          formatter.format((widget.date_i).add(Duration(days: 21))),
          style: style,
        );
        break;
      case 4:
        text = Text(
          formatter.format((widget.date_i).add(Duration(days: 28))),
          style: style,
        );
        break;
      default:
        text = const Text(
          "",
          style: style,
        );
        break;
    }
    return SideTitleWidget(child: text, axisSide: meta.axisSide);
  }

  Widget getMonthsBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14);

    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text(
          "J",
          style: style,
        );
        break;
      case 1:
        text = const Text(
          "F",
          style: style,
        );
        break;
      case 2:
        text = const Text(
          "M",
          style: style,
        );
        break;
      case 3:
        text = const Text(
          "A",
          style: style,
        );
        break;
      case 4:
        text = const Text(
          "M",
          style: style,
        );
        break;
      case 5:
        text = const Text(
          "J",
          style: style,
        );
        break;
      case 6:
        text = const Text(
          "J",
          style: style,
        );
        break;
      case 7:
        text = const Text(
          "A",
          style: style,
        );
        break;
      case 8:
        text = const Text(
          "S",
          style: style,
        );
        break;
      case 9:
        text = const Text(
          "O",
          style: style,
        );
        break;
      case 10:
        text = const Text(
          "N",
          style: style,
        );
        break;
      case 11:
        text = const Text(
          "D",
          style: style,
        );
        break;
      default:
        text = const Text(
          "",
          style: style,
        );
        break;
    }
    return SideTitleWidget(child: text, axisSide: meta.axisSide);
  }
}
