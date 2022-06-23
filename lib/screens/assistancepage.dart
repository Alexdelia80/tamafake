import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:tamafake/screens/homepage.dart';

class AssistancePage extends StatelessWidget {
  const AssistancePage({Key? key}) : super(key: key);

  static const route = '/assistance/';
  static const routename = 'AssistancePage';

  @override
  Widget build(BuildContext context) {
    print('${AssistancePage.routename} built');
    return MaterialApp(
      home: Scaffold(
        backgroundColor:Color(0xFF75B7E1),
        appBar: AppBar(
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
            centerTitle: true,
            title:  Text('Assistance', style: TextStyle(fontSize: 25))),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Via G. Gradenigo 6/B, 35131',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      Text(
                        'Padova (PD), Italy',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(30, 30, 30, 50),
                  child: (Column(
                    children: [
                      Text(
                          'You got a problem? Do not hesitate to contact us, our team of experts will always be at your disposal for any need!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                          )),
                      Text(''),
                      Text(''),
                      Text(
                          'The service is available during the week at the following times:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                          )),
                      Text(''),
                      Text('MONDAY-FRIDAY 10:00 - 18:00',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                          ))
                    ],
                  ))),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Icon(Icons.call, size: 40),
                      Text('CALL',
                          style: TextStyle(
                            fontSize: 18,
                          )),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
