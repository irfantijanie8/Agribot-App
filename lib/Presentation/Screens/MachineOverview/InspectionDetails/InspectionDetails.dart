import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;
import 'package:wheel_slider/wheel_slider.dart';

import '../../../../Class/Query.dart';
import '../../../../Declarations/Constants/constants.dart';
import '../../../Components/GradientContainer.dart';
import '../../../Components/spacer.dart';
import 'package:intl/intl.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

import 'Catalogue/CataloguePage.dart';

class InspectionDetails extends StatefulWidget {
  static const routeName = "/InspectionDetails";
  final List<String> machine_info;
  const InspectionDetails({super.key, required this.machine_info});

  @override
  State<InspectionDetails> createState() => _InspectionDetailsState();
}

class _InspectionDetailsState extends State<InspectionDetails> {
  int value = 0;

  int timeChoice = DateTime.now().minute > 30
      ? (DateTime.now().hour * 2) + 1
      : (DateTime.now().hour * 2);

  DateTime date_i =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  String quoteStartDate = "";

  List<String> imageNumList = [
    "5 images",
    "20 images",
    "50 images",
    "100 images",
    "All images"
  ];
  String imageNumvalue = "5 images";

  late Future<Query> futureQuery;

  Future<Query> fetchQuery() async {
    Map<String, dynamic> json;
    final response = await http.get(Uri.parse(
        (dotenv.env['AGRIBOT_QUERY_INSPECTION_DETAILS_API'])! +
            '?machine_id=' +
            widget.machine_info[0].toString() +
            '&date_i=' +
            (date_i.year).toString() +
            "-" +
            (date_i.month).toString().padLeft(2, "0") +
            "-" +
            (date_i.day).toString().padLeft(2, "0") + " " +
            (timeChoice < 20
                ? ((timeChoice & 0x01) == 0
                    ? "0${timeChoice ~/ 2}:00"
                    : "0${(timeChoice - 1) ~/ 2}:30")
                : ((timeChoice & 0x01) == 0
                    ? "${timeChoice ~/ 2}:00"
                    : "${(timeChoice - 1) ~/ 2}:30"))));

    print((dotenv.env['AGRIBOT_QUERY_INSPECTION_DETAILS_API'])! +
        '?machine_id=' +
        widget.machine_info[0].toString() +
        '&date_i=' +
        (date_i.year).toString() +
        "-" +
        (date_i.month).toString().padLeft(2, "0") +
        "-" +
        (date_i.day).toString().padLeft(2, "0") + " " +
        (timeChoice < 20
            ? ((timeChoice & 0x01) == 0
            ? "0${timeChoice ~/ 2}:00"
            : "0${(timeChoice - 1) ~/ 2}:30")
            : ((timeChoice & 0x01) == 0
            ? "${timeChoice ~/ 2}:00"
            : "${(timeChoice - 1) ~/ 2}:30")));

    print("finish fetching");
    if (response.statusCode == 200) {
      print("success details Query");
      print(response.body);
      // If the server did return a 200 OK response,
      json = jsonDecode(response.body) as Map<String, dynamic>;
      // then parse the JSON.
      return Query.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load query');
    }
  }

  @override
  void initState() {
    futureQuery = fetchQuery();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                Text("Inspection Images",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: WhiteTextColor)),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: GradientContainer(
            child: Column(
              children: [
                const HeightSpacer(myHeight: 80),
                Padding(
                    padding: const EdgeInsets.only(left: 18, right: 18),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () async {
                                var selectedFirstDate =
                                    await DatePicker.showSimpleDatePicker(
                                  context,
                                  initialDate: date_i,
                                  firstDate: DateTime(2015),
                                  lastDate: DateTime.now(),
                                  dateFormat: "yyyy-MMMM-dd",
                                  locale: DateTimePickerLocale.en_us,
                                  looping: true,
                                );

                                setState(() {
                                  setState(() {
                                    if (selectedFirstDate != null) {
                                      date_i = selectedFirstDate;
                                      futureQuery = fetchQuery();
                                    }
                                  });
                                });
                              },
                              child: Row(
                                children: [
                                  Text(
                                    DateFormat.yMMMMd('en_US').format(date_i),
                                    style: const TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Color(0xFF000000),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  ),
                                  const WidthSpacer(myWidth: 5),
                                  const Icon(Icons.calendar_today)
                                ],
                              ),
                            ),
                            DropdownButtonHideUnderline(
                                child: DropdownButton2<String>(
                              value: imageNumvalue,
                              barrierColor: Colors.transparent,
                              dropdownStyleData: DropdownStyleData(
                                  // maxHeight: 50,
                                  // width: 100,
                                  elevation: 0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Colors.white60,
                                  )),
                              onChanged: (String? value) {
                                // This is called when the user selects an item.
                                setState(() {
                                  imageNumvalue = value!;
                                  futureQuery = fetchQuery();
                                });
                              },
                              items: imageNumList
                                  .map(
                                      (String item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ))
                                  .toList(),
                            ))
                          ],
                        ),
                      ],
                    )),
                Text(
                  "Time",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                WheelSlider.customWidget(
                  totalCount: 48,
                  initValue: DateTime.now().minute > 30
                      ? (DateTime.now().hour * 2) + 1
                      : (DateTime.now().hour * 2),
                  isInfinite: false,
                  scrollPhysics: const BouncingScrollPhysics(),
                  onValueChanged: (val) {
                    setState(() {
                      // _cCurrentValue = val;
                    });
                  },
                  // hapticFeedbackType: HapticFeedbackType.vibrate,
                  showPointer: false,
                  itemSize: 80,
                  children: List.generate(
                      48,
                      (index) => Center(
                            child: ElevatedButton(
                              // Defines the style of the button
                              style: timeChoice == index
                                  ? ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                    )
                                  : ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                      foregroundColor: Colors.white,
                                    ),

                              onPressed: () {
                                setState(() {
                                  timeChoice = index;
                                  futureQuery = fetchQuery();
                                });
                                print("${timeChoice}");
                              },
                              // Text to be displayed on the button
                              child: Text((index & 0x01) == 0
                                  ? "${index ~/ 2}:00"
                                  : "${(index - 1) ~/ 2}:30"),
                            ),
                          )),
                ),
                CataloguePage(
                    futureQuery: futureQuery,
                    imageNum: imageNumvalue == "All images"
                        ? -1
                        : int.parse((imageNumvalue.split(" ")[0]))),
              ],
            ),
          ),
        ));
  }
}
