import 'package:flutter/material.dart';
import 'package:lightnote/constants/const.dart';
import 'package:lightnote/model/consumption.dart';
import 'package:provider/provider.dart';

class ConsumptionTypeScreen extends StatefulWidget {
  const ConsumptionTypeScreen({Key? key}) : super(key: key);

  @override
  _ConsumptionTypeState createState() => _ConsumptionTypeState();
}

class _ConsumptionTypeState extends State<ConsumptionTypeScreen> {
  int selectTypeIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 90,
      margin: EdgeInsets.symmetric(vertical: 20),
      child: GridView.count(
        crossAxisCount: 4,
        children: consumptionType.map((e) {
          return Column(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    selectTypeIndex = e["index"];
                    context.read<ComsumptionModel>().setIndex(e["index"]);
                  });
                },
                icon: Icon(e["icon"],
                    color: selectTypeIndex == e["index"]
                        ? Colors.green
                        : Colors.black),
              ),
              Text(e["name"]),
            ],
          );
        }).toList(),
      ),
    );
  }
}
