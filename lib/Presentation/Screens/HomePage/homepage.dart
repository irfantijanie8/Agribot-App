import 'dart:convert';

import 'package:agribot_two/Declarations/Constants/constants.dart';
import 'package:agribot_two/Presentation/Components/Drawer/Drawer.dart';
import 'package:agribot_two/Presentation/Components/GradientContainer.dart';
import 'package:agribot_two/Presentation/Screens/SiteOverview/SiteOverview.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../../Class/Query.dart';
import '../../../main.dart';
import '../SiteManagement/SiteManagement.dart';

class HomePage extends StatefulWidget {
  static const routeName = 'homepage';
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Query> SiteQuery;
  late String siteTitle;
  int siteChoice = 0;
  String email = "";

  List<String> fruitList = ['All Fruits'];
  String fruitDropDownValue = 'All Fruits';

  Future<void> _updateSite(int site) async {
    print("index now = " + site.toString());
    setState(() => siteChoice = site);
    fetchFruitTypeList(((await SiteQuery).items)[siteChoice]["site_id"]);
  }

  Future<Query> fetchSiteList() async {
    final user = await userPool.getCurrentUser();
    final session = await user?.getSession();
    print(session?.isValid());
    final attributes = await user?.getUserAttributes();
    attributes?.forEach((attribute) async {
      if (attribute.getName() == "email") {
        setState(() {
          email = attribute.getValue().toString();
        });
      }
    });

    Map<String, dynamic> json;
    final response = await http.get(Uri.parse(
        (dotenv.env['AGRIBOT_SITE_LIST_API'])! +
            '?' +
            'user_id=' +
            email.toString()));
    if (response.statusCode == 200) {
      print("success site Query");
      // If the server did return a 200 OK response,

      json = jsonDecode(response.body) as Map<String, dynamic>;
      // then parse the JSON.
      Query localSiteQuery = Query.fromJson(jsonDecode(response.body) as Map<String, dynamic>);

      if((localSiteQuery.items).length > 0){
        fetchFruitTypeList((localSiteQuery.items)[siteChoice]["site_id"]);
      }

      return Query.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load query');
    }
  }

  void fetchFruitTypeList(String site_id) async {
    Map<String, dynamic> json;

    final response = await http.get(Uri.parse(
        '${(dotenv.env['AGRIBOT_FRUIT_TYPE_LIST_API'])!}?site_id=$site_id'));

    if (response.statusCode == 200) {
      print("success fruit list Query");
      // If the server did return a 200 OK response,

      json = jsonDecode(response.body) as Map<String, dynamic>;
      // then parse the JSON.
      Query FruitListResponse = Query.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      setState(() {
        fruitList = ['All Fruits'];
      });
      for(var i =0; i<(FruitListResponse.items)[0]["fruitTypeList"].length ; i++){
        fruitList.add((FruitListResponse.items)[0]["fruitTypeList"][i]);
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load query');
    }
  }

  @override
  void initState() {
    SiteQuery = fetchSiteList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SiteQuery,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            if ((snapshot.data!.items).isNotEmpty) {
              return Scaffold(
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  iconTheme: IconThemeData(
                    size: 30, //change size on your need
                    color: WhiteTextColor, //change color on your need
                  ),
                  backgroundColor: Color(0x0),
                  elevation: 0,
                  title: Padding(
                    padding: const EdgeInsets.only(right: 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text((snapshot.data!.items)[siteChoice]["site_name"],
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: WhiteTextColor)),
                        DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                          value: fruitDropDownValue,
                          barrierColor: Colors.transparent,
                          dropdownStyleData: DropdownStyleData(
                              // maxHeight: 50,
                              // width: 100,
                              elevation: 1,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.transparent,
                              )),
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              fruitDropDownValue = value!;
                            });
                          },
                          items: fruitList
                              .map((String item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                              .toList(),
                        ))
                      ],
                    ),
                  ),
                ),
                drawer: SideDrawer(
                    userEmail: email,
                    SiteInfo: SiteQuery,
                    update_view_site: _updateSite,
                    reloadSiteList: () {
                      setState(() {
                        fruitDropDownValue = 'All Fruits';
                        SiteQuery = fetchSiteList();
                      });
                    }),
                body: SingleChildScrollView(
                  child: GradientContainer(
                      child: SiteOverview(
                    site_id: (snapshot.data!.items)[siteChoice]["site_id"],
                    site_name: (snapshot.data!.items)[siteChoice]["site_name"],
                    fruitType: fruitDropDownValue,
                        reloadFruitList: (){
                      fruitDropDownValue = "All Fruits";
                      fetchFruitTypeList((snapshot.data!.items)[siteChoice]["site_id"]);}
                  )),
                ),
              );
            } else {
              return Scaffold(
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  iconTheme: IconThemeData(
                    size: 30, //change size on your need
                    color: WhiteTextColor, //change color on your need
                  ),
                  backgroundColor: Color(0x0),
                  elevation: 0,
                  title: Text("",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: WhiteTextColor)),
                ),
                drawer: SideDrawer(
                    userEmail: email,
                    SiteInfo: SiteQuery,
                    update_view_site: _updateSite,
                    reloadSiteList: () {
                      setState(() {
                        SiteQuery = fetchSiteList();
                      });
                    }),
                body: GradientContainer(
                    child: Center(
                  child: AnimatedButton(
                      pressEvent: () {
                        Navigator.pushNamed(
                          context,
                          SiteManagement.routeName,
                          arguments: {
                            "SiteInfo": SiteQuery,
                            "UserEmail": email,
                            "ReloadSiteList": () {
                              setState(() {
                                fruitDropDownValue = 'All Fruits';
                                SiteQuery = fetchSiteList();
                              });
                            }
                          },
                        );
                      },
                      text: 'Manage Site',
                      width: 250,
                      color: Color(0xff080C25)),
                )),
              );
            }
          }
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              iconTheme: IconThemeData(
                size: 30, //change size on your need
                color: WhiteTextColor, //change color on your need
              ),
              backgroundColor: Color(0x0),
              elevation: 0,
              title: Text("",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: WhiteTextColor)),
            ),
            body: const GradientContainer(
                child: Center(child: CircularProgressIndicator())),
          );
        });
  }
}
