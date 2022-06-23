import 'package:flutter/material.dart';
import 'package:tamafake/screens/homepage.dart';

class TrainingPage extends StatelessWidget {
  const TrainingPage({Key? key}) : super(key: key);

  static const route = '/training/';
  static const routename = 'TrainingPage';

  @override
  Widget build(BuildContext context) {
    print('${TrainingPage.routename} built');
    return MaterialApp(
      home: Scaffold(
        backgroundColor:Color(0xFF75B7E1),
        appBar: AppBar(
            title: Text('Train with Eevee', style: TextStyle(fontSize: 25)),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 230, 67, 121),
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                    icon: const Icon(Icons.arrow_back_sharp),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()));

                      Scaffold.of(context).openDrawer();
                    },
                    tooltip:
                        MaterialLocalizations.of(context).openAppDrawerTooltip);
              },
            ),
            ),
        //body: 
      ),
    );
  }
}