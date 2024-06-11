import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class MachineList {
  final List<dynamic> items;
  const MachineList({required this.items});
  factory MachineList.fromJson(Map<String, dynamic> json) {
    return MachineList(
      items: json['Items'] as List<dynamic>,
    );
  }
}

class AddMachine extends StatefulWidget {
  final String site;
  const AddMachine({super.key, required this.site});

  @override
  State<AddMachine> createState() => _AddMachineState();
}

class _AddMachineState extends State<AddMachine> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingController = TextEditingController();
  String responsebody = "";


  Future<void> showAddMachineDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          bool? isChecked = false;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _textEditingController,
                        validator: (value) {
                          return value!.isNotEmpty ? null : "Enter any text";
                        },
                        decoration:
                        InputDecoration(hintText: "Machine ID"),
                      ),
                    ],
                  )),
              title: Text('Add Machine'),
              actions: <Widget>[
                InkWell(
                  child: Text('OK   '),
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      final response = await http.post(Uri.parse(
                          (dotenv.env['AGRIBOT_ADD_MACHINE_LIST_API'])! + '?site_id='+widget.site.toString() + '&machine_id=' + _textEditingController.text
                      ));
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(SnackBar(content: Text(response.body)));
                      Navigator.of(context).pop();

                      // setState(() {
                      //   futureQuery = fetchQuery();
                      // });
                      }

                    },
                ),
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ElevatedButton(
          onPressed: () {
            showAddMachineDialog(context);
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 50.0,
          ),
          style: ElevatedButton.styleFrom(
              shape: CircleBorder(), backgroundColor: Colors.green),
        ));
  }
}
