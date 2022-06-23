import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:tamafake/screens/homepage.dart';

class RegulationPage extends StatelessWidget {
  const RegulationPage({Key? key}) : super(key: key);

  static const route = '/regulation/';
  static const routename = 'RegulationPage';

  @override
  Widget build(BuildContext context) {
    print('${RegulationPage.routename} built');
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 234, 251, 255),
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
            title: const Center(child: Text('Regulation'))),
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
                        "Eevee's Regulation",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
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
                          "Hello friends of Eevee! Welcome to this new adventure!" +
                              "\n" +
                              "With Eevee we have fun training, but how does it work?" +
                              '\n' +
                              "After you connect your FitBit profile and upload data you can use it to train Eevee as well. For every thousand steps you will earn €5 that you can spend in the shop to feed Eevee. Based on the money spent you will increase your progress and every 100€ spent you can level up. You can then track calories burned on the EevveFIT page to change the mood of your digital friend!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                          )),
                    ],
                  ))),
            ],
          ),
        ),
      ),
    );
  }
}
