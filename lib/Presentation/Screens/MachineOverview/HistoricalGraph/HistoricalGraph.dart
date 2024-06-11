import 'dart:ffi';
import 'dart:math';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../Class/Query.dart';
import '../../../../Declarations/Constants/constants.dart';

class HistoricalGraph extends StatefulWidget {
  static const routeName = "/HistoricalGraph";
  final String machine_id;
  const HistoricalGraph({super.key, required this.machine_id});

  @override
  State<HistoricalGraph> createState() => _HistoricalGraphState();
}

class _HistoricalGraphState extends State<HistoricalGraph> {
  DateTime firstDay = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
  late List<Future<Query>> futureQuery;

  // Future<Query> fetchQuery() async {
  //   Map<String, dynamic> json;
  //   final response = await http.get(Uri.parse(
  //       (dotenv.env['AGRIBOT_QUERY_FRUIT_API'])! +
  //           '?machine_id=' +
  //           widget.machine_id.toString() +
  //           '&date_i=' +
  //           (firstDay.year).toString() +
  //           "-" +
  //           (firstDay.month).toString().padLeft(2, "0") +
  //           "-" +
  //           (firstDay.day).toString().padLeft(2, "0") +
  //           '&date_f=' +
  //           (date_f.year).toString() +
  //           "-" +
  //           (date_f.month).toString().padLeft(2, "0") +
  //           "-" +
  //           (date_f.day).toString().padLeft(2, "0")));
  //
  //   print("finish fetching");
  //   if (response.statusCode == 200) {
  //     print("success Query");
  //     // If the server did return a 200 OK response,
  //     json = jsonDecode(response.body) as Map<String, dynamic>;
  //     setState(() {
  //       A = int.parse(json["a_count"]);
  //       B = int.parse(json["b_count"]);
  //       C = int.parse(json["c_count"]);
  //       R = int.parse(json["rej_count"]);
  //       TOTAL = json["Count"];
  //     });
  //     // then parse the JSON.
  //     return Query.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  //   } else {
  //     // If the server did not return a 200 OK response,
  //     // then throw an exception.
  //     throw Exception('Failed to load query');
  //   }
  // }

  late SelectionBehavior _selectionBehavior;
  late List<ChartData> chartData;
  bool plotBandVisible = false;
  String X = "abd";
  double first = 50;
  double? plotbandstart = null;
  double? plotbandend = null;

  List<StackedColumnSeries<ChartData, String>> getSeries() {
    return <StackedColumnSeries<ChartData, String>>[
      StackedColumnSeries<ChartData, String>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          selectionBehavior: _selectionBehavior),
      StackedColumnSeries<ChartData, String>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.yValue,
          selectionBehavior: _selectionBehavior)
    ];
  }

  @override
  void initState() {
    _selectionBehavior = SelectionBehavior(
        // Enables the selection
        enable: true);
    chartData = [
      ChartData("Q1", 50, 55, 72, 65),
      ChartData("Q2", 80, 75, 80, 60)
      // ChartData('USA', 6),
      // ChartData('China', 11),
      // ChartData('UK', 9),
      // ChartData('Japan', 14),
      // ChartData('France', 10),
    ];
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            // title: Text("HomePage"),
            centerTitle: true,
            title: Text(
              widget.machine_id,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          body: Center(
              child: Column(
            children: [
              Container(
                  child: SfCartesianChart(
                selectionType: SelectionType.cluster,
                onSelectionChanged: (SelectionArgs args) {
                  setState(() {
                    plotBandVisible = !plotBandVisible;
                    plotbandstart = -0.5 + args.pointIndex;
                    plotbandend = 0.5 + args.pointIndex;
                    print(plotbandstart);
                  });
                },
                plotAreaBorderWidth: 0,
                title: ChartTitle(text: "Historical Inspection"),
                primaryXAxis: CategoryAxis(
                    majorGridLines: MajorGridLines(width: 0),
                    plotBands: <PlotBand>[
                      PlotBand(
                          isVisible: plotBandVisible,
                          start: plotbandstart,
                          end: plotbandend,
                          color: const Color.fromRGBO(101, 199, 209, 1)
                      )
                    ]
                ),
                primaryYAxis:  NumericAxis(
                    axisLine: AxisLine(width: 0),
                    labelFormat: '{value}',
                    maximum: 300,
                    majorTickLines: MajorTickLines(size: 0)),
                series: getSeries(),
              )),
              TextButton(onPressed: (){
                setState(() {
                  // series.removeLast();

                  // chartData = [
                  //   ChartData("Q1", 10, 10, 10, 10),
                  //   ChartData("Q2", 10, 10, 10, 10)
                  //   // ChartData('USA', 6),
                  //   // ChartData('China', 11),
                  //   // ChartData('UK', 9),
                  //   // ChartData('Japan', 14),
                  //   // ChartData('France', 10),
                  // ];
                });
              }, child: Text("button"))
            ],
          ))),
    );
  }
}

class ChartData {
  ChartData(
    this.x,
    this.y,
    this.yValue,
    this.secondSeriesYValue,
    this.thirdSeriesYValue,
  );

  final String x;
  final double? y;

  /// Holds y value of the datapoint
  final num? yValue;

  /// Holds y value of the datapoint(for 2nd series)
  final num? secondSeriesYValue;

  /// Holds y value of the datapoint(for 3nd series)
  final num? thirdSeriesYValue;
}
