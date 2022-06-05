import 'package:flutter/material.dart';
//import 'package:tamafake/screens/fetchuserdata.dart';

class HeartPage extends StatefulWidget {
  const HeartPage({Key? key}) : super(key: key);

  static const route = '/heartpage/';
  static const routename = 'HeartPage';

  @override
  State<HeartPage> createState() => _HeartPageState();
}

class _HeartPageState extends State<HeartPage> {
  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)!.settings.arguments! as List;

    return Scaffold(
      appBar: AppBar(title: Text('HeartPage')),
      body: Center(
        child: SizedBox(
          width: 300,
          height: 500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Table(
                border: TableBorder.all(),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    decoration: const BoxDecoration(
                      color: Colors.pinkAccent,
                    ),
                    children: [
                      Center(child: Text('DAY')),
                      Center(child: Text('HEART RATE')),
                      Center(child: Text('CALORIES'))
                    ],
                  ),
                  TableRow(
                    children: [
                      Text('${message[0].dateOfMonitoring}'),
                      Text('${message[0].restingHeartRate}'),
                      Text('${message[0].caloriesCardio}'),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text('${message[1].dateOfMonitoring}'),
                      Text('${message[1].restingHeartRate}'),
                      Text('${message[1].caloriesCardio}'),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text('${message[2].dateOfMonitoring}'),
                      Text('${message[2].restingHeartRate}'),
                      Text('${message[2].caloriesCardio}'),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text('${message[3].dateOfMonitoring}'),
                      Text('${message[3].restingHeartRate}'),
                      Text('${message[3].caloriesCardio}'),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text('${message[4].dateOfMonitoring}'),
                      Text('${message[4].restingHeartRate}'),
                      Text('${message[4].caloriesCardio}'),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text('${message[5].dateOfMonitoring}'),
                      Text('${message[5].restingHeartRate}'),
                      Text('${message[5].caloriesCardio}'),
                    ],
                  ),
                  /*
                  TableRow(
                    children: [
                      Text('${message[6].dateOfMonitoring}'),
                      Text('${message[6].restingHeartRate}'),
                      Text('${message[6].caloriesCardio}'),
                    ],
                  ),
                  */
                ],
              ),

              /*'The day ${message[0].dateOfMonitoring}, you walked ${message[0].value} ${message[0].type} ')*/

              ElevatedButton(
                child: Text('To Homepage'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
