import 'package:flutter/material.dart';

import '../../../Declarations/Constants/constants.dart';
import '../spacer.dart';

class SiteTiles extends StatefulWidget {
  final String site_id;
  final String site_name;
  final int Index;
  final ValueChanged<int> Update;
  const SiteTiles({super.key, required this.site_id, required this.site_name, required this.Index, required this.Update});

  @override
  State<SiteTiles> createState() => _SiteTilesState();
}

class _SiteTilesState extends State<SiteTiles> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title:  Row(
        children: [
          WidthSpacer(myWidth: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.circle,
                    color: Colors.black54,
                    size: 15,
                  ),
                  WidthSpacer(myWidth: 10),
                  Text(widget.site_name, style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff080C25))
                    ,),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.circle,
                    color: Colors.transparent,
                    size: 15,
                  ),
                  WidthSpacer(myWidth: 10),
                  Text("ID: ${widget.site_id}", style: TextStyle(fontSize: 12),),
                ],
              ),
              HeightSpacer(myHeight: 13),
            ],
          ),
        ],
      ),
      onTap: () {
        // Update the state of the app
        print("Rendering site " + widget.site_name);
        (widget.Update)(widget.Index);
        Navigator.pop(context);

        // Navigator.pushReplacementNamed(context, 'homepage');

        // Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));


      },
    );
  }
}
