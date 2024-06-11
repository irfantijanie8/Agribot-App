import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../Declarations/Constants/constants.dart';
import '../../../../Components/spacer.dart';

class SiteInfo extends StatefulWidget {
  final String site_name;
  final String site_id;
  const SiteInfo({super.key, required this.site_id, required this.site_name});

  @override
  State<SiteInfo> createState() => _SiteInfoState();
}

class _SiteInfoState extends State<SiteInfo> {
  @override
  Widget build(BuildContext context) {
    return Card(
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
                CupertinoIcons.tree,
                color: Colors.black,
                size: 100.0,
              ),
              WidthSpacer(myWidth: 20),
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
                        'Status: ',
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
                        widget.site_name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                        ),
                      ),
                      HeightSpacer(myHeight: 8),
                      Text(
                        widget.site_id,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                        ),
                      ),
                      HeightSpacer(myHeight: 8),
                      Icon(
                        CupertinoIcons.check_mark_circled_solid,
                        color: Colors.green,
                        size: 17.0,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
