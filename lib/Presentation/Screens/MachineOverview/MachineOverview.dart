import 'package:flutter/material.dart';

import '../../../Declarations/Constants/constants.dart';
import '../../Components/GradientContainer.dart';
import 'MachineOverviewPage.dart';

class MachineOverview extends StatefulWidget {
  static const routeName = "/MachineOverview";
  final List<String> machine_info;
  const MachineOverview({super.key, required this.machine_info});

  @override
  State<MachineOverview> createState() => _MachineOverviewState();
}

class _MachineOverviewState extends State<MachineOverview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          size: 30, //change size on your need
          color: WhiteTextColor, //change color on your need
        ),
        backgroundColor: Color(0x0),
        elevation: 0,
        title: Text(widget.machine_info[1],
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: WhiteTextColor)),
      ),
      //drawer: SideDrawer(SiteList: SiteList, update: _updateSite,),
      body: SingleChildScrollView(
          child: GradientContainer(
              child: MachineOverviewPage(
        machine_id: widget.machine_info[0],
        machine_name: widget.machine_info[1],
        fruitType: widget.machine_info[2],
      ))),
    );
  }
}
