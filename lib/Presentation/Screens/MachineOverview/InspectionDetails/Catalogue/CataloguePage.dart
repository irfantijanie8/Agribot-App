import 'package:agribot_two/Presentation/Components/spacer.dart';
import 'package:flutter/material.dart';

import '../../../../../Class/Query.dart';
import 'FruitCard.dart';

class CataloguePage extends StatefulWidget {
  final Future<Query> futureQuery;
  final int imageNum;
  const CataloguePage({super.key, required this.futureQuery, required this.imageNum});

  @override
  State<CataloguePage> createState() => _CataloguePageState();
}

class _CataloguePageState extends State<CataloguePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          FutureBuilder<Query>(
            future: widget.futureQuery,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data!.items.isNotEmpty){
                  return ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.items.length <= widget.imageNum || widget.imageNum == -1 ? snapshot.data!.items.length : widget.imageNum,
                      itemBuilder: (context, index) {
                        return FruitCard(
                          child: snapshot.data!.items[index],
                        );
                      });
                }
                else{
                  return Column(
                    children: [
                      HeightSpacer(myHeight: 40),
                      Text("No Inspection Done During The Seleted Time Period", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20), textAlign: TextAlign.center,),
                    ],
                  );
                }

              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }
}