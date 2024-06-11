import 'package:agribot_two/Class/Query.dart';
import 'package:agribot_two/Declarations/Constants/Images/image_files.dart';
import 'package:agribot_two/Presentation/Components/spacer.dart';
import 'package:agribot_two/Presentation/Screens/SiteManagement/SiteManagement.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import '../../../Declarations/Constants/constants.dart';
import '../../../main.dart';
import 'SiteTiles.dart';

class SideDrawer extends StatefulWidget {
  final String userEmail;
  final Future<Query> SiteInfo;
  final ValueChanged<int> update_view_site;
  final reloadCallback reloadSiteList;

  const SideDrawer(
      {super.key,
      required this.userEmail,
      required this.SiteInfo,
      required this.update_view_site, required this.reloadSiteList});

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  late Future<Query> SiteInfoVar;

  @override
  void didUpdateWidget(covariant SideDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.SiteInfo != widget.SiteInfo) {
      print("Changing Site Info");
      SiteInfoVar = widget.SiteInfo;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    SiteInfoVar = widget.SiteInfo;
  }

  @override
  Widget build(BuildContext context) {

    return Drawer(
        backgroundColor: Color(0xD2C2F8C3),
        child: Column(
          children: [
            HeightSpacer(myHeight: 40),
            CircleAvatar(
                radius: 48, // Image radius
                backgroundImage: AssetImage(loginImages)),
            HeightSpacer(myHeight: 10),
            Text(widget.userEmail,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            HeightSpacer(myHeight: 10),
            AnimatedButton(
                pressEvent: () async {
                  final user = await userPool.getCurrentUser();
                  user?.signOut();
                  Navigator.pushReplacementNamed(context, 'login');
                },
                text: 'Sign Out',
                width: 250,
                color: Colors.green[300]),
            Divider(
              thickness: 2,
              color: Colors.black54,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                  children: [
                    FutureBuilder(
                        future: SiteInfoVar,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              children: [
                                ListView.builder(
                                    // physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.items.length,
                                    itemBuilder: (context, index) {
                                      return SiteTiles(
                                        site_id: snapshot.data!.items[index]["site_id"],
                                        site_name: snapshot.data!.items[index]["site_name"],
                                        Index: index,
                                        Update: widget.update_view_site,
                                      );
                                    }),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }
                          // By default, show a loading spinner.
                          return Center(
                              child: const CircularProgressIndicator());
                        }),
                    const HeightSpacer(myHeight: 10),
                    AnimatedButton(
                        pressEvent: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(
                            context,
                            SiteManagement.routeName,
                            arguments: {"SiteInfo": SiteInfoVar, "UserEmail": widget.userEmail, "ReloadSiteList": widget.reloadSiteList},
                          );
                        },
                        text: 'Manage Site',
                        width: 250,
                        color: Color(0xff080C25)),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
