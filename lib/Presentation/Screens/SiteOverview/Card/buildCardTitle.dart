import 'package:flutter/material.dart';

import '../../../../../Declarations/Constants/constants.dart';
import '../../../Components/spacer.dart';

class BuildCardTitle extends StatelessWidget {
  final String title;
  const BuildCardTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        /*2*/
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 8.0),
          child: Text(
            title,
            style: TextStyle(
                color: WhiteTextColor, fontSize: 30, fontWeight: FontWeight.w600),
            textAlign: TextAlign.left,
          ),
        ),
        const HeightSpacer(myHeight: 10),
      ],
    );
  }
}
