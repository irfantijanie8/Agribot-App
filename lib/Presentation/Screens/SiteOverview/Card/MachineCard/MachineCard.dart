import 'dart:convert';

import 'package:agribot_two/Class/Query.dart';
import 'package:agribot_two/Declarations/Constants/constants.dart';
import 'package:agribot_two/Presentation/Components/spacer.dart';
import 'package:agribot_two/Presentation/Screens/SiteOverview/Card/MachineCard/buildMachineCard.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../buildCardTitle.dart';
import 'package:http/http.dart' as http;

class MachineCard extends StatefulWidget {
  final String Site;
  final reloadCallback reloadStats;
  final String fruitType;
  final reloadCallback reloadFruitList;
  const MachineCard(
      {super.key,
      required this.Site,
      required this.reloadStats,
      required this.fruitType,
      required this.reloadFruitList});

  @override
  State<MachineCard> createState() => _MachineCardState();
}

class _MachineCardState extends State<MachineCard> {
  TextEditingController _machineNameFieldController = TextEditingController();
  TextEditingController _machineIdFieldController = TextEditingController();

  late Future<Query> MachineListQuery;

  bool isSubmitLoading = false;

  Future<Query> QueryMachineList() async {
    final response = await http.get(Uri.parse(
        '${(dotenv.env['AGRIBOT_MACHINE_LIST_API'])!}?site_id=${widget.Site}'));

    if (response.statusCode == 200) {
      return Query.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load machine list');
    }
  }

  @override
  void initState() {
    MachineListQuery = QueryMachineList();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MachineCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.Site != widget.Site) {
      MachineListQuery = QueryMachineList();
    }
  }

  String? get _nameErrorText {
    final text = _machineNameFieldController.value.text;

    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    if (text.length > 10) {
      return 'Name can\'t be more than 10 characters';
    }
    // return null if the text is valid
    return null;
  }

  String? get _idErrorText {
    final text = _machineIdFieldController.value.text;

    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    if (!macRegExp.hasMatch(text)) {
      return 'Invalid Machine ID Format';
    }
    // return null if the text is valid
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0,
        color: CardBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            const Center(child: BuildCardTitle(title: "Machine")),
            FutureBuilder(
                future: MachineListQuery,
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    return Column(
                      children: [
                        snapshot.data!.items.isNotEmpty ?
                        ListView.builder(
                            padding: EdgeInsets.zero,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data!.items.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  buildMachineCard(
                                    SiteID: widget.Site,
                                    MachineID: snapshot.data!.items[index]
                                        ["machine_id"],
                                    MachineName: snapshot.data!.items[index]
                                        ["machine_name"],
                                    reloadStats: widget.reloadStats,
                                    reloadMachineList: () {
                                      widget.reloadFruitList();
                                      setState(() {
                                        MachineListQuery = QueryMachineList();
                                      });
                                    },
                                    fruitType: snapshot.data!.items[index]
                                        ["fruitType"],
                                  ),
                                ],
                              );
                            }) : Text("No Existing Machine!"),
                        HeightSpacer(myHeight: 10),
                        AnimatedButton(
                            pressEvent: () {
                              setState(() {
                                _machineNameFieldController.clear();
                                _machineIdFieldController.clear();
                              });
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    String? nameError = null;
                                    String? idError = null;
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
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
                                          height: 400,
                                          width: 200,
                                          child: Center(
                                            child: Column(
                                              children: [
                                                HeightSpacer(myHeight: 20),
                                                const Text(
                                                  'Add Machine',
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const HeightSpacer(
                                                    myHeight: 20),
                                                const Row(
                                                  children: [
                                                    WidthSpacer(myWidth: 20),
                                                    Text("Machine Name"),
                                                    Spacer()
                                                  ],
                                                ),
                                                const HeightSpacer(myHeight: 5),
                                                SizedBox(
                                                  width: 250,
                                                  child: TextField(
                                                    controller:
                                                        _machineNameFieldController,
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      hintText: 'Machine Name',
                                                      errorText: nameError,
                                                    ),
                                                    onChanged: (_) =>
                                                        setState(() {}),
                                                  ),
                                                ),
                                                const HeightSpacer(
                                                    myHeight: 20),
                                                const Row(
                                                  children: [
                                                    WidthSpacer(myWidth: 20),
                                                    Text("Machine ID"),
                                                    Spacer()
                                                  ],
                                                ),
                                                const HeightSpacer(myHeight: 5),
                                                SizedBox(
                                                  width: 250,
                                                  child: TextField(
                                                    controller:
                                                        _machineIdFieldController,
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      hintText: 'Machine ID',
                                                      errorText: idError,
                                                    ),
                                                    onChanged: (_) =>
                                                        setState(() {}),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Machine ID Format: AA:AA:AA:AA:AA:AA",
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                  ],
                                                ),
                                                const HeightSpacer(
                                                    myHeight: 20),
                                                const HeightSpacer(myHeight: 5),
                                                Stack(
                                                  children: [
                                                    Visibility(
                                                        visible: isSubmitLoading,
                                                        child: CircularProgressIndicator()),

                                                    Visibility(
                                                      visible: !isSubmitLoading,
                                                      child: InkWell(
                                                      onTap: () async {
                                                        setState(() {
                                                          nameError =
                                                              _nameErrorText;
                                                          idError = _idErrorText;
                                                        });

                                                        if (_nameErrorText ==
                                                                null &&
                                                            _idErrorText == null) {
                                                          setState((){
                                                            isSubmitLoading = true;
                                                          });
                                                          final response = await http
                                                              .post(Uri.parse((dotenv
                                                                          .env[
                                                                      'AGRIBOT_MACHINE_LIST_API'])! +
                                                                  '?site_id=' +
                                                                  widget.Site
                                                                      .toString() +
                                                                  '&machine_id=' +
                                                                  _machineIdFieldController
                                                                      .text +
                                                                  '&machine_name=' +
                                                                  _machineNameFieldController
                                                                      .text));

                                                          if (response.statusCode ==
                                                              200) {
                                                            MachineListQuery =
                                                                QueryMachineList();
                                                            Navigator.pop(context);
                                                            QuickAlert.show(
                                                              context: context,
                                                              type: QuickAlertType
                                                                  .success,
                                                              text:
                                                                  "Machine Has Been Successfully Added",
                                                            );
                                                            widget.reloadStats();
                                                            widget.reloadFruitList();
                                                          } else {
                                                            QuickAlert.show(
                                                              context: context,
                                                              type: QuickAlertType
                                                                  .error,
                                                              text: jsonDecode(
                                                                      response.body)
                                                                  as String,
                                                            );
                                                          }
                                                          setState((){
                                                            isSubmitLoading = false;
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        width: 100,
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                          horizontal: 10,
                                                          vertical: 13,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          color: Colors.black,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  8.0),
                                                        ),
                                                        child: Text(
                                                          "Submit",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                  ),
                                                    )],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                                  });
                            },
                            text: 'Add Machine',
                            width: 120,
                            color: Colors.green[300])
                      ],
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
            const HeightSpacer(myHeight: 20),
          ],
        ));
  }
}
