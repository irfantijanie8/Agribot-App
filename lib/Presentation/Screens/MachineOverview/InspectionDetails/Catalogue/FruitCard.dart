import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class FruitCard extends StatefulWidget {
  final Map<String, dynamic> child;
  FruitCard({required this.child});

  @override
  State<FruitCard> createState() => _FruitCardState();
}

class _FruitCardState extends State<FruitCard> {
  late Future<String> _imageURL;

  Future<String> _getImageURL() async {
    print(widget.child);
    var response ;
    do{
      response = await http.get(Uri.parse(
          (dotenv.env['AGRIBOT_S3_DOWNLOAD_API'])! + '?' + "object=" + widget.child['machine_id'] + "/" + widget.child['timestamp']+ ".png"
      ));
    }
    while(jsonDecode(response.body).toString() == "{message: Service Unavailable}");
    return (jsonDecode(response.body).toString());
  }

  @override
  initState(){
    super.initState();
    _imageURL = _getImageURL();
  }

  @override
  void didUpdateWidget(covariant FruitCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      _imageURL = _getImageURL();
    }
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _imageURL,
        builder: (context, snapshot) {
          if(snapshot.hasData && snapshot.connectionState == ConnectionState.done){
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              width: MediaQuery.of(context).size.width,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    offset: Offset(
                      0.0,
                      10.0,
                    ),
                    blurRadius: 10.0,
                    spreadRadius: -6.0,
                  ),
                ],
                image: DecorationImage(
                  image: NetworkImage(snapshot.data!),
                  // image: NetworkImage('https://0je3rk9t12.execute-api.us-east-1.amazonaws.com/dev/agribot-guava/2023-11-14%2021:39:39.455716.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Align(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(
                        " ",
                        style: TextStyle(
                          fontSize: 19,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    alignment: Alignment.center,
                  ),
                  Align(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 18,
                              ),
                              SizedBox(width: 7),
                              Text(widget.child['grade']),
                            ],
                          ),
                        ),
                        // Flexible(
                        //   child: Container(
                        //     padding: EdgeInsets.all(5),
                        //     margin: EdgeInsets.all(10),
                        //     decoration: BoxDecoration(
                        //       color: Colors.white.withOpacity(0.4),
                        //       borderRadius: BorderRadius.circular(15),
                        //     ),
                        //     child: Flexible(
                        //       child: Row(
                        //             children: [
                        //               Icon(
                        //                 Icons.schedule,
                        //                 color: Colors.yellow,
                        //                 size: 18,
                        //               ),
                        //               SizedBox(width: 7),
                        //               Flexible(child: Text(widget.child['timestamp'],overflow:TextOverflow.ellipsis))
                        //             ],
                        //           ),
                        //     ),
                        //     ),
                        //     ),
                      ],
                    ),
                    alignment: Alignment.bottomLeft,
                  ),
                ],
              ),
            );
          }
          else
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
          width: MediaQuery.of(context).size.width,
          height: 180,
          decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
          BoxShadow(
          color: Colors.black.withOpacity(0.6),
          offset: Offset(
          0.0,
          10.0,
          ),
          blurRadius: 10.0,
          spreadRadius: -6.0,
          ),
          ],

          ),
                child: Center(child: SizedBox(width:30, height: 30,child: CircularProgressIndicator())),
            );

        }
    );
  }
}
