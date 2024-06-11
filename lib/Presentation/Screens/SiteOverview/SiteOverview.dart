import 'package:agribot_two/Declarations/Constants/constants.dart';
import 'package:agribot_two/Presentation/Components/spacer.dart';
import 'package:agribot_two/Presentation/Screens/SiteOverview/Card/SiteInfo/SiteInfo.dart';
import 'package:flutter/material.dart';

import 'Card/MachineCard/MachineCard.dart';
import 'Card/SiteStatistic/SiteStatistic.dart';

class SiteOverview extends StatefulWidget {
  static const routeName = '/SiteOverview';
  final String site_id;
  final String site_name;
  final String fruitType;
  final reloadCallback reloadFruitList;
  const SiteOverview({super.key, required this.site_id, required this.site_name, required this.fruitType, required this.reloadFruitList});

  @override
  State<SiteOverview> createState() => _SiteOverviewState();
}

class _SiteOverviewState extends State<SiteOverview> {
  bool buttonChange = false;


  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
            HeightSpacer(myHeight: 50),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  SiteInfo(site_id: widget.site_id, site_name: widget.site_name,),
                  SiteStatistic(siteID: widget.site_id, buttonChange: buttonChange, fruitType: widget.fruitType,),
                  MachineCard(Site: widget.site_id, reloadStats: () => setState(() => buttonChange = !buttonChange), fruitType: widget.fruitType, reloadFruitList: widget.reloadFruitList,),
                ],
              ),
            ),
          ],
        );
  }
}
