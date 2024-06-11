import 'dart:convert';

import 'package:agribot_two/Presentation/Components/spacer.dart';
import 'package:agribot_two/Presentation/Screens/SiteManagement/SiteCard.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../../Class/Query.dart';
import '../../../Declarations/Constants/constants.dart';

class SiteManagement extends StatefulWidget {
  final Future<Query> siteInfo;
  final String userEmail;
  final reloadCallback reloadSiteList;

  static const routeName = 'siteManagement';
  const SiteManagement(
      {super.key,
      required this.siteInfo,
      required this.userEmail,
      required this.reloadSiteList});

  @override
  State<SiteManagement> createState() => _SiteManagementState();
}

class _SiteManagementState extends State<SiteManagement>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController _addIdFieldController = TextEditingController();
  TextEditingController _addPasswordFieldController = TextEditingController();

  TextEditingController _regIdFieldController = TextEditingController();
  TextEditingController _regNameFieldController = TextEditingController();
  TextEditingController _regPasswordFieldController = TextEditingController();

  bool _isLoading = false;

  List<String> castSiteName = [];
  List<String> castSiteId = [];

  late Future<Query> SiteInfoVar;

  String? get _addIdErrorText {
    final text = _addIdFieldController.value.text;

    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    return null;
  }

  String? get _addPasswordErrorText {
    final text = _addPasswordFieldController.value.text;

    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    // return null if the text is valid
    return null;
  }

  //conditional check from site registration forms
  String? get _regIdErrorText {
    final text = _regIdFieldController.value.text;

    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    if (text.length > 10) {
      return 'I can\'t be more than 10 characters';
    }

    return null;
  }

  String? get _regNameErrorText {
    final text = _regNameFieldController.value.text;

    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    if (text.length > 10) {
      return 'Name can\'t be more than 10 characters';
    }
    // return null if the text is valid
    return null;
  }

  String? get _regPasswordErrorText {
    final text = _regPasswordFieldController.value.text;

    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    return null;
  }

  Future<void> castIdName() async {
    Query SiteInfo = await widget.siteInfo;

    for (var i = 0; i < SiteInfo.items.length; i++) {
      setState(() {
        castSiteId.add(SiteInfo.items[i]["site_id"]);
        castSiteName.add(SiteInfo.items[i]["site_name"]);
      });
    }
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    SiteInfoVar = widget.siteInfo;
    castIdName();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff080C25),
      appBar: AppBar(
        backgroundColor: Color(0xff080C25),
        // title: Text("HomePage"),
        centerTitle: true,
        title: Text(
          "Manage Site",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: castSiteId.length,
                              itemBuilder: (context, index) {
                                return SiteCard(
                                  site_id: castSiteId[index],
                                  site_name: castSiteName[index],
                                  deleteSiteFromList: () {
                                    setState(() {
                                      castSiteId.removeAt(index);
                                      castSiteName.removeAt(index);
                                    });
                                  },
                                  reloadSiteList: widget.reloadSiteList,
                                  userEmail: widget.userEmail,
                                );
                              }),
                        ],
                      ),
                      AnimatedButton(
                          pressEvent: () {
                            setState(() {
                              _isLoading = false;
                              _addIdFieldController.clear();
                              _addPasswordFieldController.clear();

                              _regIdFieldController.clear();
                              _regNameFieldController.clear();
                              _regPasswordFieldController.clear();
                            });
                            showDialog(
                                context: context,
                                builder: (context) {
                                  String? addIdError = null;
                                  String? addPassError = null;

                                  String? regIdError = null;
                                  String? regNameError = null;
                                  String? regPasswordError = null;
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    return SingleChildScrollView(
                                      child: AlertDialog(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                              20.0,
                                            ),
                                          ),
                                        ),
                                        contentPadding: const EdgeInsets.only(
                                          top: 10.0,
                                        ),
                                        content: Container(
                                          height: 650,
                                          width: 200,
                                          child: Column(
                                            children: [
                                              // Text("login or register"),
                                              Row(children: [IconButton(
                                                iconSize: 20,
                                                icon: const Icon(Icons.close),
                                                onPressed: () {
                                                  Navigator.pop(
                                                      context);
                                                },
                                              ),],),
                                              Container(
                                                width: 250,
                                                height: 45,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    25.0,
                                                  ),
                                                ),
                                                child: TabBar(
                                                  controller: _tabController,
                                                  // give the indicator a decoration (color and border radius)
                                                  indicator: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      25.0,
                                                    ),
                                                    color: Colors.green,
                                                  ),
                                                  labelColor: Colors.white,
                                                  unselectedLabelColor:
                                                      Colors.black,
                                                  tabs: [
                                                    // first tab [you can add an icon using the icon property]
                                                    Tab(
                                                      text: 'Existing',
                                                    ),

                                                    // second tab [you can add an icon using the icon property]
                                                    Tab(
                                                      text: 'Create',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: TabBarView(
                                                  controller: _tabController,
                                                  children: [
                                                    Center(
                                                      child: Column(
                                                        children: [
                                                          HeightSpacer(
                                                              myHeight: 20),
                                                          Text(
                                                            'Add Existing Site',
                                                            style: TextStyle(
                                                              fontSize: 25,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          HeightSpacer(
                                                              myHeight: 20),
                                                          Row(
                                                            children: [
                                                              WidthSpacer(
                                                                  myWidth: 20),
                                                              Text("Site ID"),
                                                              new Spacer()
                                                            ],
                                                          ),
                                                          HeightSpacer(
                                                              myHeight: 5),
                                                          SizedBox(
                                                            width: 250,
                                                            child: TextField(
                                                              controller:
                                                                  _addIdFieldController,
                                                              decoration: InputDecoration(
                                                                  border:
                                                                      OutlineInputBorder(),
                                                                  hintText:
                                                                      'Site ID',
                                                                  errorText:
                                                                      addIdError),
                                                              onChanged: (_) =>
                                                                  setState(
                                                                      () {}),
                                                            ),
                                                          ),
                                                          HeightSpacer(
                                                              myHeight: 20),
                                                          Row(
                                                            children: [
                                                              WidthSpacer(
                                                                  myWidth: 20),
                                                              Text("Password"),
                                                              new Spacer()
                                                            ],
                                                          ),
                                                          HeightSpacer(
                                                              myHeight: 5),
                                                          SizedBox(
                                                            width: 250,
                                                            child: TextField(
                                                              obscureText: true,
                                                              controller:
                                                                  _addPasswordFieldController,
                                                              decoration: InputDecoration(
                                                                  border:
                                                                      OutlineInputBorder(),
                                                                  hintText:
                                                                      'Password',
                                                                  errorText:
                                                                      addPassError),
                                                              onChanged: (_) =>
                                                                  setState(
                                                                      () {}),
                                                            ),
                                                          ),
                                                          HeightSpacer(
                                                              myHeight: 20),
                                                          Stack(children: [
                                                            Visibility(
                                                              visible:
                                                                  !_isLoading,
                                                              child: InkWell(
                                                                onTap:
                                                                    () async {
                                                                  setState(() {
                                                                    addIdError =
                                                                        _addIdErrorText;
                                                                    addPassError =
                                                                        _addPasswordErrorText;
                                                                  });

                                                                  if (_addIdErrorText ==
                                                                          null &&
                                                                      _addPasswordErrorText ==
                                                                          null) {

                                                                    setState((){
                                                                      _isLoading = true;
                                                                    });

                                                                    final response = await http.put(Uri.parse((dotenv.env[
                                                                            'AGRIBOT_SITE_LIST_API'])! +
                                                                        '?user_id=' +
                                                                        widget
                                                                            .userEmail
                                                                            .toString() +
                                                                        '&site_id=' +
                                                                        _addIdFieldController
                                                                            .text +
                                                                        '&password=' +
                                                                        _addPasswordFieldController
                                                                            .text));

                                                                    if (response
                                                                            .statusCode ==
                                                                        200) {

                                                                      widget
                                                                          .reloadSiteList();

                                                                      Navigator.pop(
                                                                          context);
                                                                      Navigator.pop(
                                                                          context);
                                                                      QuickAlert
                                                                          .show(
                                                                        context:
                                                                            context,
                                                                        type: QuickAlertType
                                                                            .success,
                                                                        text: jsonDecode(response.body)
                                                                            as String,
                                                                      );
                                                                    } else {
                                                                      setState(
                                                                          () {
                                                                        _isLoading =
                                                                            false;
                                                                      });
                                                                      QuickAlert
                                                                          .show(
                                                                        context:
                                                                            context,
                                                                        type: QuickAlertType
                                                                            .error,
                                                                        text: jsonDecode(response.body)
                                                                            as String,
                                                                      );
                                                                    }
                                                                    setState((){
                                                                      _isLoading = false;
                                                                    });
                                                                  }
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: 100,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        13,
                                                                  ),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .black,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                  child: Text(
                                                                    "Submit",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Visibility(
                                                                visible:
                                                                    _isLoading,
                                                                child:
                                                                    CircularProgressIndicator())
                                                          ]),
                                                        ],
                                                      ),
                                                    ),
                                                    // second tab bar view widget
                                                    Center(
                                                      child: Column(
                                                        children: [
                                                          HeightSpacer(
                                                              myHeight: 20),
                                                          Text(
                                                            'Register New Site',
                                                            style: TextStyle(
                                                              fontSize: 25,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          HeightSpacer(
                                                              myHeight: 20),
                                                          Row(
                                                            children: [
                                                              WidthSpacer(
                                                                  myWidth: 20),
                                                              Text("Site ID"),
                                                              new Spacer()
                                                            ],
                                                          ),
                                                          HeightSpacer(
                                                              myHeight: 5),
                                                          SizedBox(
                                                            width: 250,
                                                            child: TextField(
                                                              controller:
                                                                  _regIdFieldController,
                                                              decoration: InputDecoration(
                                                                  border:
                                                                      OutlineInputBorder(),
                                                                  hintText:
                                                                      'Site ID',
                                                                  errorText:
                                                                      regIdError),
                                                              onChanged: (_) =>
                                                                  setState(
                                                                      () {}),
                                                            ),
                                                          ),
                                                          HeightSpacer(
                                                              myHeight: 20),
                                                          Row(
                                                            children: [
                                                              WidthSpacer(
                                                                  myWidth: 20),
                                                              Text("Site Name"),
                                                              new Spacer()
                                                            ],
                                                          ),
                                                          HeightSpacer(
                                                              myHeight: 5),
                                                          SizedBox(
                                                            width: 250,
                                                            child: TextField(
                                                              controller:
                                                                  _regNameFieldController,
                                                              decoration: InputDecoration(
                                                                  border:
                                                                      OutlineInputBorder(),
                                                                  hintText:
                                                                      'Site Name',
                                                                  errorText:
                                                                      regNameError),
                                                              onChanged: (_) =>
                                                                  setState(
                                                                      () {}),
                                                            ),
                                                          ),
                                                          HeightSpacer(
                                                              myHeight: 20),
                                                          Row(
                                                            children: [
                                                              WidthSpacer(
                                                                  myWidth: 20),
                                                              Text("Password"),
                                                              new Spacer()
                                                            ],
                                                          ),
                                                          HeightSpacer(
                                                              myHeight: 5),
                                                          SizedBox(
                                                            width: 250,
                                                            child: TextField(
                                                              obscureText: true,
                                                              controller:
                                                                  _regPasswordFieldController,
                                                              decoration: InputDecoration(
                                                                  border:
                                                                      OutlineInputBorder(),
                                                                  hintText:
                                                                      'Password',
                                                                  errorText:
                                                                      regPasswordError),
                                                              onChanged: (_) =>
                                                                  setState(
                                                                      () {}),
                                                            ),
                                                          ),
                                                          HeightSpacer(
                                                              myHeight: 20),
                                                          Stack(
                                                            children: [
                                                              Visibility(
                                                                  visible:
                                                                      _isLoading,
                                                                  child:
                                                                      CircularProgressIndicator()),
                                                              Visibility(
                                                                visible:
                                                                    !_isLoading,
                                                                child: InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    print(
                                                                        "register");
                                                                    setState(
                                                                        () {
                                                                      regNameError =
                                                                          _regNameErrorText;
                                                                      regIdError =
                                                                          _regIdErrorText;
                                                                      regPasswordError =
                                                                          _regPasswordErrorText;
                                                                    });
                                                                    print(
                                                                        "${_regNameErrorText} ${_regIdErrorText} ${_regPasswordErrorText}");

                                                                    if (_regNameErrorText == null &&
                                                                        _regIdErrorText ==
                                                                            null &&
                                                                        _regPasswordErrorText ==
                                                                            null) {
                                                                      setState(
                                                                          () {
                                                                        _isLoading =
                                                                            true;
                                                                      });
                                                                      final response = await http.post(Uri.parse((dotenv.env[
                                                                              'AGRIBOT_SITE_LIST_API'])! +
                                                                          '?user_id=' +
                                                                          widget
                                                                              .userEmail
                                                                              .toString() +
                                                                          '&site_name=' +
                                                                          _regNameFieldController
                                                                              .text +
                                                                          '&site_id=' +
                                                                          _regIdFieldController
                                                                              .text +
                                                                          '&password=' +
                                                                          _regPasswordFieldController
                                                                              .text));
                                                                      print(response
                                                                          .body);
                                                                      setState(
                                                                          () {
                                                                        _isLoading =
                                                                            false;
                                                                      });

                                                                      if (response
                                                                              .statusCode ==
                                                                          200) {
                                                                        widget
                                                                            .reloadSiteList();

                                                                        Navigator.pop(
                                                                            context);
                                                                        Navigator.pop(
                                                                            context);
                                                                        QuickAlert
                                                                            .show(
                                                                          context:
                                                                              context,
                                                                          type:
                                                                              QuickAlertType.success,
                                                                          text: jsonDecode(response.body)
                                                                              as String,
                                                                        );
                                                                      } else {
                                                                        setState(
                                                                            () {
                                                                          _isLoading =
                                                                              false;
                                                                        });
                                                                        QuickAlert
                                                                            .show(
                                                                          context:
                                                                              context,
                                                                          type:
                                                                              QuickAlertType.error,
                                                                          text: jsonDecode(response.body)
                                                                              as String,
                                                                        );
                                                                      }
                                                                    }
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    width: 100,
                                                                    padding:
                                                                        EdgeInsets
                                                                            .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          13,
                                                                    ),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .black,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                    child: Text(
                                                                      "Submit",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                                });
                          },
                          text: 'Add Site',
                          width: 120,
                          color: Colors.green[300]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // body: InspectionDetails(machine_id: widget.machine_id),
    );
  }
}
