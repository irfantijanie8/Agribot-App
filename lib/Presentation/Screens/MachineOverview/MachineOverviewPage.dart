import 'package:agribot_two/Presentation/Screens/MachineOverview/MachineStatistics/MachineStatistics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Declarations/Constants/constants.dart';
import '../../Components/spacer.dart';
import 'InspectionDetails/InspectionDetails.dart';

class MachineOverviewPage extends StatefulWidget {
  final String machine_id;
  final String machine_name;
  final String fruitType;
  const MachineOverviewPage({super.key, required this.machine_id, required this.machine_name, required this.fruitType});

  @override
  State<MachineOverviewPage> createState() => _MachineOverviewPageState();
}

class _MachineOverviewPageState extends State<MachineOverviewPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(alignment: Alignment.center, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            HeightSpacer(myHeight: 50),
            Card(
              elevation: 0,
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Container(
                padding: const EdgeInsets.only(
                    top: 22.0, left: 16.0, right: 16.0, bottom: 22.0),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        CupertinoIcons.desktopcomputer,
                        color: Colors.black,
                        size: 85.0,
                      ),
                      WidthSpacer(myWidth: 5),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Name: ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                ),
                              ),
                              HeightSpacer(myHeight: 8),
                              Text(
                                'ID: ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                ),
                              ),
                              HeightSpacer(myHeight: 8),
                              Text(
                                'Fruit Type: ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                ),
                              ),

                            ],
                          ),
                          WidthSpacer(myWidth: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.machine_name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                ),
                              ),
                              HeightSpacer(myHeight: 8),
                              Text(
                                widget.machine_id,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                              HeightSpacer(myHeight: 8),
                              Text(
                                widget.fruitType,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            MachineStatistics(machineId: widget.machine_id, fruitType: widget.fruitType,),
            HeightSpacer(myHeight: 10),
            Card(
              elevation: 4.0,
              color: TilesColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    InspectionDetails.routeName,
                    arguments: [widget.machine_id, widget.fruitType],
                  );
                },
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 7.0, left: 16.0, right: 16.0, bottom: 30.0),
                  // TodayStats(A: A, B: B, C: C, TOTAL: TOTAL),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.chart_pie_fill,
                          color: Colors.yellow,
                          size: 20.0,
                        ),
                        Text(
                          'View Inspection Images',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],

                    ),
                  ),
                ),
              ),
            ),
            HeightSpacer(myHeight: 40),
          ],
        ),
      ]),
    );
  }
}
