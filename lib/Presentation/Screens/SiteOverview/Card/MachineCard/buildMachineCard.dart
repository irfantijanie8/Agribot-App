import 'dart:convert';

import 'package:agribot_two/Declarations/Constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:http/http.dart' as http;


import '../../../MachineOverview/MachineOverview.dart';

class buildMachineCard extends StatefulWidget {
  final String SiteID;
  final String MachineID;
  final String MachineName;
  final reloadCallback reloadStats;
  final reloadCallback reloadMachineList;
  final String fruitType;
  const buildMachineCard({super.key,required this.SiteID ,required this.MachineID, required this.MachineName, required this.reloadStats, required this.reloadMachineList, required this.fruitType});

  @override
  State<buildMachineCard> createState() => _buildMachineCardState();
}

enum Menu { remove }

class _buildMachineCardState extends State<buildMachineCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0.0,
        color: MachineCardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        child: ListTile(
            onTap: () {
              Navigator.pushNamed(
                context,
                MachineOverview.routeName,
                arguments: [widget.MachineID, widget.MachineName, widget.fruitType],
              );
            },
            leading: Icon(
              CupertinoIcons.circle_fill,
              color: Colors.green,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.MachineName,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0),
                ),
                Text( "Machine ID: ${widget.MachineID}",
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 10.0),
                ),
                Text( "Fruit Type: ${widget.fruitType}",
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 10.0),
                ),
              ],
            ),
            // subtitle: Text('Here is a second line'),
            trailing: Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Color(0xFF000000),
              ),
              child: PopupMenuButton<Menu>(
                // popUpAnimationStyle: AnimationStyles.defaultStyle,
                icon: const Icon(Icons.more_vert),
                // constraints: const BoxConstraints.expand(width: 100, height: 100),
                onSelected: (Menu item) async {
                  if(item == Menu.remove){
                    print(item );
                    final response = await http.delete(Uri.parse(
                        (dotenv.env['AGRIBOT_MACHINE_LIST_API'])! +
                            '?site_id=' +
                            widget.SiteID.toString() +
                            '&machine_id=' + widget.MachineID
                    ));

                    if (response.statusCode == 200) {
                      widget.reloadMachineList();
                      widget.reloadStats();
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        text: "Machine Has Been Successfully Delete",
                      );

                    } else {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        text: "Error During Deletion. Please Try Again",
                      );

                    }
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                  const PopupMenuItem<Menu>(
                    padding: EdgeInsets.zero,
                    value: Menu.remove,
                    child: ListTile(
                      leading: Icon(CupertinoIcons.trash),
                      title: Text('Remove Machine'),
                    ),
                  )
                ],
              ),
            )));
  }
}
