import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:flutter/material.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:tamafake/repository/databaseRepository.dart';
import 'package:tamafake/database/entities/tables.dart';
//import 'package:tamafake/database/daos/tablesDao.dart';
import 'package:tamafake/screens/homepage.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlotPage extends StatefulWidget {
  const PlotPage({Key? key}) : super(key: key);

  static const route = '/plot/';
  static const routename = 'PlotPage';

  @override
  _PlotPageState createState() => _PlotPageState();
}

class _PlotPageState extends State<PlotPage> {
  final List<Feature> features = [
    Feature(
      title: "Flutter",
      color: Colors.blue,
      data: [0, 0.2, 0.4, 0.6, 0.8, 1],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Flutter Draw Graph Demo"),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              "Experience Progress",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
          LineGraph(
            features: features,
            size: Size(420, 450),
            labelX: ['Day 1', 'Day 2', 'Day 3', 'Day 4', 'Day 5', 'Day 6'],
            labelY: ['25%', '45%', '65%', '75%', '85%', '100%'],
            showDescription: true,
            graphColor: Colors.black87,
          ),
          SizedBox(
            height: 50,
          ),
          ElevatedButton(
            child: const Text('To Homepage'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
