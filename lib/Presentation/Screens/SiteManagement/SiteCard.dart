import 'dart:convert';

import 'package:agribot_two/Presentation/Components/spacer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../../Declarations/Constants/constants.dart';

class SiteCard extends StatefulWidget {
  final String site_id;
  final String site_name;
  final String userEmail;
  final reloadCallback deleteSiteFromList;
  final reloadCallback reloadSiteList;

  const SiteCard(
      {super.key,
      required this.site_id,
      required this.site_name,
      required this.userEmail,
      required this.deleteSiteFromList,
      required this.reloadSiteList});
  @override
  State<SiteCard> createState() => _SiteCardState();
}

enum Menu { remove }

class _SiteCardState extends State<SiteCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
          elevation: 4.0,
          color: const Color(0xff161B31),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 16.0, left: 16.0, right: 16.0, bottom: 16.0),
            child: Column(
              children: [
                HeightSpacer(myHeight: 10),
                Row(
                  children: [
                    WidthSpacer(myWidth: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.site_name,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 35),
                        ),
                        HeightSpacer(myHeight: 4),
                        Text(
                          "ID: ${widget.site_id}",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                        ),
                      ],
                    ),
                    new Spacer(),
                    PopupMenuButton<Menu>(
                      // popUpAnimationStyle: AnimationStyles.defaultStyle,
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 30,
                      ),
                      // constraints: const BoxConstraints.expand(width: 100, height: 100),
                      onSelected: (Menu item) async {
                        print("throw into trash");
                        final response = await http.delete(Uri.parse(
                            (dotenv.env['AGRIBOT_SITE_LIST_API'])! +
                                '?user_id=' +
                                widget.userEmail.toString() +
                                '&site_id=' +
                                widget.site_id));
                        if (response.statusCode == 200) {
                          widget.deleteSiteFromList();
                          widget.reloadSiteList();
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.success,
                            text: jsonDecode(response.body) as String,
                          );
                        } else {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.error,
                            text: "Error. Please Try Again",
                          );
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<Menu>>[
                        const PopupMenuItem<Menu>(
                          padding: EdgeInsets.zero,
                          value: Menu.remove,
                          child: ListTile(
                            leading: Icon(CupertinoIcons.trash),
                            title: Text('Remove Site'),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                HeightSpacer(myHeight: 10),
              ],
            ),
          )),
    );
  }
}
